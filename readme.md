# Currency Exchange Rates API

Automated exchange rate aggregator providing USD-based rates for fiat currencies and major cryptocurrencies (Bitcoin, Solana & Ethereum). Updates every 15 minutes via GitHub Actions.

## 🔡 API Endpoint

```
https://cdn.jsdelivr.net/gh/anvme/currency@main/latest.json
```

### Why Use jsDelivr CDN?

**jsDelivr CDN is recommended over raw GitHub links** for production use because it provides:
- **Global edge caching** - 99.9% uptime with servers worldwide for faster response times
- **Production-grade reliability** - Enterprise CDN infrastructure vs GitHub's rate-limited raw content
- **Bandwidth optimization** - Reduced load on GitHub's servers and better performance for your users


## 📦 Response Format example

```json
{
  "updated": "2025-10-28T20:10:29.665Z",
  "base": "USD",
  "fiatDate": "2025-10-28",
  "rates": {
    "USD": 1,
    "EUR": 0.927,
    "GBP": 0.753,
    "JPY": 152.29,
    ...
    "SOL": 194.25,
    "BTC": 113154.6,
    "ETH": 4025.1
  }
}
```

### Response Fields Explained

- **`updated`**: ISO 8601 timestamp of when the data was last refreshed
- **`base`**: Base currency for all rates is USD
- **`fiatDate`**: Date of fiat currency rates from European Central Bank
- **`rates`**: Object containing all exchange rates where `1 USD = X units` of target currency

### Currency Codes Explained

**Fiat Currencies (Traditional Money):**
- **USD** - United States Dollar
- **EUR** - Euro
- **JPY** - Japanese Yen
- **GBP** - British Pound Sterling
- **CNY** - Chinese Yuan
- **AUD** - Australian Dollar
- **CAD** - Canadian Dollar
- **CHF** - Swiss Franc
- **HKD** - Hong Kong Dollar
- **SGD** - Singapore Dollar
- **NZD** - New Zealand Dollar
- **SEK** - Swedish Krona
- **KRW** - South Korean Won
- **NOK** - Norwegian Krone
- **INR** - Indian Rupee
- **MXN** - Mexican Peso
- **BRL** - Brazilian Real
- **ZAR** - South African Rand
- **TRY** - Turkish Lira
- **DKK** - Danish Krone
- **PLN** - Polish Zloty
- **CZK** - Czech Koruna
- **ILS** - Israeli New Shekel
- **THB** - Thai Baht
- **MYR** - Malaysian Ringgit
- **PHP** - Philippine Peso
- **IDR** - Indonesian Rupiah
- **HUF** - Hungarian Forint
- **RON** - Romanian Leu
- **BGN** - Bulgarian Lev
- **ISK** - Icelandic Króna

**Cryptocurrencies:**
- **BTC** - Bitcoin
- **SOL** - Solana
- **ETH** - Ethereum

## 💻 Usage Examples
📚 [Usage Examples](usage-example.md) - JavaScript, Python, Go, Rust, and more!

## 📊 Update Frequency

- **Fiat currencies:** Daily (weekdays) from European Central Bank
- **Cryptocurrencies:** Every 20 minutes
- **Workflow runs:** Every 20 minutes via GitHub Actions

## 💡 Pro Tips

- **Cache responses** locally to reduce API calls
- **Implement retry logic** for production applications
- **Monitor the `updated` field** to ensure data freshness
- **Store rates locally** and refresh only when needed (every 20 min for crypto, daily for fiat)

## 🔒 Rate Limits

- **No rate limits** on jsDelivr CDN!
- **Best practice:** Cache responses for at least 15-20 minutes to reduce unnecessary requests

## 📄 License

Free to use

## 🤝 Contributing

This API is maintained automatically via GitHub Actions. For issues or feature requests, please visit the GitHub repository.

---

**Need help?** Open an issue on GitHub or check the documentation for your specific programming language above.
