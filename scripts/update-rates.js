import { XMLParser } from 'fast-xml-parser';
import { writeFileSync } from 'fs';

const ECB_URL = 'https://www.ecb.europa.eu/stats/eurofxref/eurofxref-daily.xml';
const JUPITER_URL = 'https://lite-api.jup.ag/price/v3?ids=So11111111111111111111111111111111111111112,cbbtcf3aa214zXHbiAZQwf4122FBYbraNdFqgw4iMij,7vfCXTUXx5WJV5JADk17DUJ4ksgau7utNKj4b963voxs';

// Retry helper with exponential backoff
async function fetchWithRetry(url, maxAttempts = 5) {
  for (let attempt = 1; attempt <= maxAttempts; attempt++) {
    try {
      const response = await fetch(url);
      if (!response.ok) throw new Error(`HTTP ${response.status}`);
      return await response.text();
    } catch (error) {
      if (attempt === maxAttempts) throw error;
      const delay = Math.pow(2, attempt) * 1000; // 2s, 4s, 8s, 16s
      console.log(`Attempt ${attempt} failed, retrying in ${delay}ms...`);
      await new Promise(resolve => setTimeout(resolve, delay));
    }
  }
}

// Fetch ECB data
async function fetchECB() {
  console.log('Fetching ECB data...');
  const xml = await fetchWithRetry(ECB_URL, 3);
  
  const parser = new XMLParser({ ignoreAttributes: false });
  const data = parser.parse(xml);
  
  // Navigate XML structure: Envelope -> Cube -> Cube (with time) -> Cube[] (currencies)
  const timeCube = data['gesmes:Envelope'].Cube.Cube;
  const fiatDate = timeCube['@_time'];
  const currencies = timeCube.Cube;
  
  // Build rates object
  const rates = {};
  let usdRate = null;
  
  // First pass: find USD rate
  for (const currency of currencies) {
    if (currency['@_currency'] === 'USD') {
      usdRate = parseFloat(currency['@_rate']);
      break;
    }
  }
  
  if (!usdRate) throw new Error('USD rate not found in ECB data');
  
  // Second pass: convert all to USD base
  for (const currency of currencies) {
    const code = currency['@_currency'];
    const eurRate = parseFloat(currency['@_rate']);
    rates[code] = parseFloat((eurRate / usdRate).toFixed(4));
  }
  
  console.log(`✓ Fetched ${Object.keys(rates).length} fiat currencies (date: ${fiatDate})`);
  return { rates, fiatDate };
}

// Fetch Jupiter crypto data
async function fetchJupiter() {
  console.log('Fetching Jupiter crypto data...');
  const json = await fetchWithRetry(JUPITER_URL, 5);
  const data = JSON.parse(json);
  
  const rates = {
    SOL: parseFloat(data['So11111111111111111111111111111111111111112'].usdPrice.toFixed(2)),
    BTC: parseFloat(data['cbbtcf3aa214zXHbiAZQwf4122FBYbraNdFqgw4iMij'].usdPrice.toFixed(2)),
    ETH: parseFloat(data['7vfCXTUXx5WJV5JADk17DUJ4ksgau7utNKj4b963voxs'].usdPrice.toFixed(2))
  };
  
  console.log('✓ Fetched crypto prices');
  return rates;
}

// Main execution
async function main() {
  try {
    const [ecb, crypto] = await Promise.all([
      fetchECB(),
      fetchJupiter()
    ]);
    
    const output = {
      updated: new Date().toISOString(),
      base: 'USD',
      fiatDate: ecb.fiatDate,
      rates: {
        ...ecb.rates,
        ...crypto
      }
    };
    
    writeFileSync('latest.json', JSON.stringify(output));
    console.log('✓ Updated latest.json');
    console.log(`Total rates: ${Object.keys(output.rates).length}`);
    
  } catch (error) {
    console.error('Error:', error.message);
    process.exit(1);
  }
}

main();
