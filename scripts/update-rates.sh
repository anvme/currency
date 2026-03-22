#!/usr/bin/env bash
set -euo pipefail
export LC_ALL=C

ECB_URL="https://www.ecb.europa.eu/stats/eurofxref/eurofxref-daily.xml"
JUPITER_URL="https://lite-api.jup.ag/price/v3?ids=So11111111111111111111111111111111111111112,cbbtcf3aa214zXHbiAZQwf4122FBYbraNdFqgw4iMij,7vfCXTUXx5WJV5JADk17DUJ4ksgau7utNKj4b963voxs"
BINANCE_URL="https://data-api.binance.vision/api/v3/ticker/price?symbols=%5B%22SOLUSDT%22,%22BTCUSDT%22,%22ETHUSDT%22%5D"
COINGECKO_URL="https://api.coingecko.com/api/v3/simple/price?ids=solana,bitcoin,ethereum&vs_currencies=usd"
MAX_DIVERGENCE=0.05

tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT

# --- Fiat rates from ECB (single sed | awk pipe) ---
ecb_xml=$(curl -sf --retry 3 --connect-timeout 5 "$ECB_URL")
fiat_date=$(sed -n "s/.*time='\([^']*\)'.*/\1/p" <<< "$ecb_xml")
usd_eur=$(sed -n "s/.*currency='USD' rate='\([^']*\)'.*/\1/p" <<< "$ecb_xml")

fiat_rates=$(sed -n "s/.*currency='\([^']*\)' rate='\([^']*\)'.*/\1 \2/p" <<< "$ecb_xml" | \
  awk -v usd="$usd_eur" '
    BEGIN { printf "{\"EUR\":%.4f,\"USD\":1", 1/usd }
    { printf ",\"%s\":%.4f", $1, $2/usd }
    END { print "}" }')

echo "✓ Fetched fiat currencies (date: $fiat_date)"

# --- Crypto prices from 3 sources (parallel fetch) ---
echo "Fetching crypto prices..."

curl -sf --retry 2 --max-time 10 --connect-timeout 5 "$JUPITER_URL"  > "$tmp/jup" 2>/dev/null &
curl -sf --retry 2 --max-time 10 --connect-timeout 5 "$BINANCE_URL"  > "$tmp/bin" 2>/dev/null &
curl -sf --retry 2 --max-time 10 --connect-timeout 5 "$COINGECKO_URL" > "$tmp/cg"  2>/dev/null &
wait

# Check which sources succeeded
jup_raw=$(cat "$tmp/jup" 2>/dev/null) || jup_raw=""
bin_raw=$(cat "$tmp/bin" 2>/dev/null) || bin_raw=""
cg_raw=$(cat "$tmp/cg" 2>/dev/null)  || cg_raw=""

[ -n "$jup_raw" ] && echo "  ✓ Jupiter"  || echo "  ✗ Jupiter: failed"
[ -n "$bin_raw" ] && echo "  ✓ Binance"  || echo "  ✗ Binance: failed"
[ -n "$cg_raw" ]  && echo "  ✓ CoinGecko" || echo "  ✗ CoinGecko: failed"

# --- Single jq: normalize all 3 sources + validate + build output ---
jq -c -n \
  --argjson jup_raw  "${jup_raw:-null}" \
  --argjson bin_raw  "${bin_raw:-null}" \
  --argjson cg_raw   "${cg_raw:-null}" \
  --argjson max_div  "$MAX_DIVERGENCE" \
  --arg     updated  "$(date -u +%Y-%m-%dT%H:%M:%S.000Z)" \
  --arg     base     "USD" \
  --arg     fiatDate "$fiat_date" \
  --argjson fiat     "$fiat_rates" \
'
  # Normalize each source to {"SOL": x, "BTC": x, "ETH": x}
  def norm_jup:
    if $jup_raw == null then {} else {
      SOL: $jup_raw["So11111111111111111111111111111111111111112"].usdPrice,
      BTC: $jup_raw["cbbtcf3aa214zXHbiAZQwf4122FBYbraNdFqgw4iMij"].usdPrice,
      ETH: $jup_raw["7vfCXTUXx5WJV5JADk17DUJ4ksgau7utNKj4b963voxs"].usdPrice
    } end;
  def norm_bin:
    if $bin_raw == null then {} else
      [$bin_raw[] | {(.symbol | sub("USDT$";"")): (.price | tonumber)}] | add
    end;
  def norm_cg:
    if $cg_raw == null then {} else {
      SOL: $cg_raw.solana.usd,
      BTC: $cg_raw.bitcoin.usd,
      ETH: $cg_raw.ethereum.usd
    } end;

  norm_jup as $jup | norm_bin as $bin | norm_cg as $cg |

  # Median (3 sources) or validated average (2 sources)
  def safe_price(coin):
    [[$jup[coin], $bin[coin], $cg[coin]] | .[] | select(. != null and . > 0)] |
    sort |
    if length >= 3 then
      .[1]
    elif length == 2 then
      if (((.[1] - .[0]) / .[0]) | fabs) > $max_div then
        error("Price divergence >\($max_div * 100)% for \(coin): \(.[0]) vs \(.[1])")
      else
        ((.[0] + .[1]) / 2)
      end
    else
      error("Need at least 2 sources for \(coin), got \(length)")
    end |
    . * 100 | round / 100;

  {
    updated: $updated,
    base: $base,
    fiatDate: $fiatDate,
    rates: ($fiat + { SOL: safe_price("SOL"), BTC: safe_price("BTC"), ETH: safe_price("ETH") })
  }
' > latest.json

echo "✓ Updated latest.json with $(jq -r '.rates | length' latest.json) rates"
