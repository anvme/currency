
## 💻 Usage Examples

<details>
<summary><strong>JavaScript / Node.js</strong></summary>

```javascript
// Fetch rates
const response = await fetch('https://cdn.jsdelivr.net/gh/anvme/currency@main/latest.json');
const data = await response.json();

// Get specific rate
console.log(`1 USD = ${data.rates.EUR} EUR`);
console.log(`Bitcoin: $${data.rates.BTC}`);

// Convert amount
const usdAmount = 100;
const eurAmount = usdAmount * data.rates.EUR;
console.log(`$${usdAmount} = €${eurAmount.toFixed(2)}`);

// Convert from EUR to USD
const eurToUsd = eurAmount / data.rates.EUR;
console.log(`€${eurAmount} = $${eurToUsd.toFixed(2)}`);
```

</details>

<details>
<summary><strong>Python</strong></summary>

```python
import requests
from datetime import datetime

# Fetch rates
response = requests.get('https://cdn.jsdelivr.net/gh/anvme/currency@main/latest.json')
data = response.json()

# Get specific rate
print(f"1 USD = {data['rates']['EUR']} EUR")
print(f"Bitcoin: ${data['rates']['BTC']:,.2f}")

# Convert amount
usd_amount = 100
eur_amount = usd_amount * data['rates']['EUR']
print(f"${usd_amount} = €{eur_amount:.2f}")

# Show last updated time
updated = datetime.fromisoformat(data['updated'].replace('Z', '+00:00'))
print(f"Last updated: {updated.strftime('%Y-%m-%d %H:%M:%S UTC')}")
```

</details>

<details>
<summary><strong>Java</strong></summary>

```java
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import com.google.gson.Gson;
import com.google.gson.JsonObject;
import java.util.Map;

public class CurrencyConverter {
    public static void main(String[] args) throws Exception {
        // Fetch rates
        HttpClient client = HttpClient.newHttpClient();
        HttpRequest request = HttpRequest.newBuilder()
            .uri(URI.create("https://cdn.jsdelivr.net/gh/anvme/currency@main/latest.json"))
            .build();
        
        HttpResponse<String> response = client.send(request, 
            HttpResponse.BodyHandlers.ofString());
        
        // Parse JSON
        Gson gson = new Gson();
        JsonObject data = gson.fromJson(response.body(), JsonObject.class);
        JsonObject rates = data.getAsJsonObject("rates");
        
        // Get specific rate
        double eurRate = rates.get("EUR").getAsDouble();
        double btcRate = rates.get("BTC").getAsDouble();
        
        System.out.printf("1 USD = %.4f EUR%n", eurRate);
        System.out.printf("Bitcoin: $%.2f%n", btcRate);
        
        // Convert amount
        double usdAmount = 100;
        double eurAmount = usdAmount * eurRate;
        System.out.printf("$%.2f = €%.2f%n", usdAmount, eurAmount);
    }
    
    // Helper method for conversions
    public static double convert(double amount, double fromRate, double toRate) {
        return (amount / fromRate) * toRate;
    }
}
```

</details>

<details>
<summary><strong>TypeScript</strong></summary>

```typescript
interface CurrencyData {
  updated: string;
  base: string;
  fiatDate: string;
  rates: Record<string, number>;
}

// Fetch rates with type safety
async function getRates(): Promise<CurrencyData> {
  const response = await fetch('https://cdn.jsdelivr.net/gh/anvme/currency@main/latest.json');
  return await response.json();
}

// Usage
const data = await getRates();
console.log(`1 USD = ${data.rates.EUR} EUR`);
console.log(`Bitcoin: $${data.rates.BTC.toLocaleString()}`);

// Type-safe conversion function
function convert(amount: number, fromRate: number, toRate: number): number {
  return (amount / fromRate) * toRate;
}

// Convert 100 USD to EUR
const eurAmount = convert(100, 1, data.rates.EUR);
console.log(`$100 = €${eurAmount.toFixed(2)}`);
```

</details>

<details>
<summary><strong>C / C++</strong></summary>

```cpp
#include <iostream>
#include <curl/curl.h>
#include <nlohmann/json.hpp>
#include <string>

using json = nlohmann::json;

// Callback function for curl
size_t WriteCallback(void* contents, size_t size, size_t nmemb, std::string* userp) {
    userp->append((char*)contents, size * nmemb);
    return size * nmemb;
}

int main() {
    CURL* curl;
    CURLcode res;
    std::string readBuffer;
    
    curl = curl_easy_init();
    if(curl) {
        curl_easy_setopt(curl, CURLOPT_URL, "https://cdn.jsdelivr.net/gh/anvme/currency@main/latest.json");
        curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, WriteCallback);
        curl_easy_setopt(curl, CURLOPT_WRITEDATA, &readBuffer);
        
        res = curl_easy_perform(curl);
        curl_easy_cleanup(curl);
        
        if(res == CURLE_OK) {
            // Parse JSON
            json data = json::parse(readBuffer);
            
            // Get specific rate
            double eurRate = data["rates"]["EUR"];
            double btcRate = data["rates"]["BTC"];
            
            std::cout << "1 USD = " << eurRate << " EUR" << std::endl;
            std::cout << "Bitcoin: $" << btcRate << std::endl;
            
            // Convert amount
            double usdAmount = 100.0;
            double eurAmount = usdAmount * eurRate;
            std::cout << "$" << usdAmount << " = €" << eurAmount << std::endl;
            
            // Convert between currencies
            double gbpRate = data["rates"]["GBP"];
            double jpyRate = data["rates"]["JPY"];
            double gbpToJpy = (50.0 / gbpRate) * jpyRate;
            std::cout << "£50 = ¥" << gbpToJpy << std::endl;
        }
    }
    
    return 0;
}

// Compile with: g++ -o currency currency.cpp -lcurl
```

</details>

<details>
<summary><strong>C# / .NET</strong></summary>

```csharp
using System;
using System.Net.Http;
using System.Text.Json;
using System.Threading.Tasks;

public class CurrencyConverter
{
    public class CurrencyData
    {
        public string Updated { get; set; }
        public string Base { get; set; }
        public string FiatDate { get; set; }
        public Dictionary<string, decimal> Rates { get; set; }
    }
    
    public static async Task Main()
    {
        // Fetch rates
        using var client = new HttpClient();
        var response = await client.GetStringAsync(
            "https://cdn.jsdelivr.net/gh/anvme/currency@main/latest.json");
        
        var data = JsonSerializer.Deserialize<CurrencyData>(response);
        
        // Get specific rate
        Console.WriteLine($"1 USD = {data.Rates["EUR"]:F4} EUR");
        Console.WriteLine($"Bitcoin: ${data.Rates["BTC"]:N2}");
        
        // Convert amount
        decimal usdAmount = 100;
        decimal eurAmount = usdAmount * data.Rates["EUR"];
        Console.WriteLine($"${usdAmount} = €{eurAmount:F2}");
        
        // Convert between currencies
        decimal gbpToJpy = Convert(50, data.Rates["GBP"], data.Rates["JPY"]);
        Console.WriteLine($"£50 = ¥{gbpToJpy:F2}");
    }
    
    public static decimal Convert(decimal amount, decimal fromRate, decimal toRate)
    {
        return (amount / fromRate) * toRate;
    }
}
```

</details>

<details>
<summary><strong>PHP</strong></summary>

```php
<?php
// Fetch rates
$json = file_get_contents('https://cdn.jsdelivr.net/gh/anvme/currency@main/latest.json');
$data = json_decode($json, true);

// Get specific rate
echo "1 USD = " . $data['rates']['EUR'] . " EUR\n";
echo "Bitcoin: $" . number_format($data['rates']['BTC'], 2) . "\n";

// Convert amount
$usdAmount = 100;
$eurAmount = $usdAmount * $data['rates']['EUR'];
echo "$" . $usdAmount . " = €" . number_format($eurAmount, 2) . "\n";

// Function for any currency conversion
function convert($amount, $fromRate, $toRate) {
    return ($amount / $fromRate) * $toRate;
}

// Convert 50 GBP to JPY
$gbpToJpy = convert(50, $data['rates']['GBP'], $data['rates']['JPY']);
echo "£50 = ¥" . number_format($gbpToJpy, 2);
?>
```

</details>

<details>
<summary><strong>SQL (via JSON functions)</strong></summary>

```sql
-- PostgreSQL Example
-- Assuming you have a table with the JSON data or using a function to fetch it

-- Create a function to fetch and parse currency data
CREATE OR REPLACE FUNCTION get_exchange_rate(currency_code TEXT)
RETURNS NUMERIC AS $$
DECLARE
    json_data JSONB;
BEGIN
    -- In real scenario, you'd fetch this via HTTP extension or have it stored
    -- For demo, assuming json_data is available
    SELECT content::jsonb INTO json_data 
    FROM currency_data 
    WHERE id = 'latest';
    
    RETURN (json_data->'rates'->>currency_code)::NUMERIC;
END;
$$ LANGUAGE plpgsql;

-- Query examples
-- Get EUR rate
SELECT (data->'rates'->>'EUR')::NUMERIC as eur_rate
FROM currency_json;

-- Convert 100 USD to EUR
SELECT 100 * (data->'rates'->>'EUR')::NUMERIC as eur_amount
FROM currency_json;

-- Convert between currencies (50 GBP to JPY)
SELECT (50 / (data->'rates'->>'GBP')::NUMERIC) * 
       (data->'rates'->>'JPY')::NUMERIC as jpy_amount
FROM currency_json;

-- List all available currencies
SELECT jsonb_object_keys(data->'rates') as currency
FROM currency_json
ORDER BY currency;

-- MySQL 8.0+ Example
SELECT 
    JSON_UNQUOTE(JSON_EXTRACT(rates_json, '$.rates.EUR')) as eur_rate,
    JSON_UNQUOTE(JSON_EXTRACT(rates_json, '$.rates.BTC')) as btc_rate
FROM currency_table;
```

</details>

<details>
<summary><strong>Go</strong></summary>

```go
package main

import (
    "encoding/json"
    "fmt"
    "net/http"
)

type CurrencyResponse struct {
    Updated  string             `json:"updated"`
    Base     string             `json:"base"`
    FiatDate string             `json:"fiatDate"`
    Rates    map[string]float64 `json:"rates"`
}

func main() {
    // Fetch rates
    resp, err := http.Get("https://cdn.jsdelivr.net/gh/anvme/currency@main/latest.json")
    if err != nil {
        panic(err)
    }
    defer resp.Body.Close()
    
    var data CurrencyResponse
    json.NewDecoder(resp.Body).Decode(&data)
    
    // Get specific rate
    fmt.Printf("1 USD = %.4f EUR\n", data.Rates["EUR"])
    fmt.Printf("Bitcoin: $%.2f\n", data.Rates["BTC"])
    
    // Convert amount
    usdAmount := 100.0
    eurAmount := usdAmount * data.Rates["EUR"]
    fmt.Printf("$%.2f = €%.2f\n", usdAmount, eurAmount)
    
    // Convert between currencies
    convert := func(amount, fromRate, toRate float64) float64 {
        return (amount / fromRate) * toRate
    }
    
    gbpToJpy := convert(50, data.Rates["GBP"], data.Rates["JPY"])
    fmt.Printf("£50 = ¥%.2f\n", gbpToJpy)
}
```

</details>

<details>
<summary><strong>Shell Script (Bash)</strong></summary>

```bash
#!/bin/bash

# Fetch rates
URL="https://cdn.jsdelivr.net/gh/anvme/currency@main/latest.json"
DATA=$(curl -s "$URL")

# Extract rates using jq
EUR_RATE=$(echo "$DATA" | jq -r '.rates.EUR')
BTC_RATE=$(echo "$DATA" | jq -r '.rates.BTC')
GBP_RATE=$(echo "$DATA" | jq -r '.rates.GBP')
JPY_RATE=$(echo "$DATA" | jq -r '.rates.JPY')

# Display rates
echo "1 USD = $EUR_RATE EUR"
echo "Bitcoin: \$$BTC_RATE"

# Convert amount
USD_AMOUNT=100
EUR_AMOUNT=$(echo "$USD_AMOUNT * $EUR_RATE" | bc -l)
printf "\$%.2f = €%.2f\n" "$USD_AMOUNT" "$EUR_AMOUNT"

# Convert between currencies
convert() {
    local amount=$1
    local from_rate=$2
    local to_rate=$3
    echo "scale=2; ($amount / $from_rate) * $to_rate" | bc -l
}

GBP_TO_JPY=$(convert 50 "$GBP_RATE" "$JPY_RATE")
printf "£50 = ¥%.2f\n" "$GBP_TO_JPY"

# Get all available currencies
echo -e "\nAvailable currencies:"
echo "$DATA" | jq -r '.rates | keys[]' | sort
```

</details>

<details>
<summary><strong>Swift (iOS/macOS)</strong></summary>

```swift
import Foundation

struct CurrencyResponse: Codable {
    let updated: String
    let base: String
    let fiatDate: String
    let rates: [String: Double]
}

func fetchRates() async throws -> CurrencyResponse {
    let url = URL(string: "https://cdn.jsdelivr.net/gh/anvme/currency@main/latest.json")!
    let (data, _) = try await URLSession.shared.data(from: url)
    let decoder = JSONDecoder()
    return try decoder.decode(CurrencyResponse.self, from: data)
}

func convert(amount: Double, fromRate: Double, toRate: Double) -> Double {
    return (amount / fromRate) * toRate
}

// Usage
Task {
    do {
        let data = try await fetchRates()
        
        // Get specific rate
        if let eurRate = data.rates["EUR"], let btcRate = data.rates["BTC"] {
            print("1 USD = \(eurRate) EUR")
            print("Bitcoin: $\(String(format: "%.2f", btcRate))")
        }
        
        // Convert amount
        let usdAmount = 100.0
        if let eurRate = data.rates["EUR"] {
            let eurAmount = usdAmount * eurRate
            print("$\(usdAmount) = €\(String(format: "%.2f", eurAmount))")
        }
        
        // Convert between currencies
        if let gbpRate = data.rates["GBP"], let jpyRate = data.rates["JPY"] {
            let gbpToJpy = convert(amount: 50, fromRate: gbpRate, toRate: jpyRate)
            print("£50 = ¥\(String(format: "%.2f", gbpToJpy))")
        }
    } catch {
        print("Error: \(error)")
    }
}
```

</details>

<details>
<summary><strong>Kotlin (Android)</strong></summary>

```kotlin
import kotlinx.coroutines.*
import kotlinx.serialization.*
import kotlinx.serialization.json.*
import java.net.URL

@Serializable
data class CurrencyResponse(
    val updated: String,
    val base: String,
    val fiatDate: String,
    val rates: Map<String, Double>
)

suspend fun fetchRates(): CurrencyResponse = withContext(Dispatchers.IO) {
    val url = "https://cdn.jsdelivr.net/gh/anvme/currency@main/latest.json"
    val json = URL(url).readText()
    Json.decodeFromString<CurrencyResponse>(json)
}

fun convert(amount: Double, fromRate: Double, toRate: Double): Double {
    return (amount / fromRate) * toRate
}

// Usage
fun main() = runBlocking {
    val data = fetchRates()
    
    // Get specific rate
    val eurRate = data.rates["EUR"] ?: 0.0
    val btcRate = data.rates["BTC"] ?: 0.0
    
    println("1 USD = $eurRate EUR")
    println("Bitcoin: $${"%.2f".format(btcRate)}")
    
    // Convert amount
    val usdAmount = 100.0
    val eurAmount = usdAmount * eurRate
    println("$$usdAmount = €${"%.2f".format(eurAmount)}")
    
    // Convert between currencies
    val gbpRate = data.rates["GBP"] ?: 0.0
    val jpyRate = data.rates["JPY"] ?: 0.0
    val gbpToJpy = convert(50.0, gbpRate, jpyRate)
    println("£50 = ¥${"%.2f".format(gbpToJpy)}")
}
```

</details>

<details>
<summary><strong>Ruby</strong></summary>

```ruby
require 'net/http'
require 'json'

# Fetch rates
uri = URI('https://cdn.jsdelivr.net/gh/anvme/currency@main/latest.json')
response = Net::HTTP.get(uri)
data = JSON.parse(response)

# Get specific rate
puts "1 USD = #{data['rates']['EUR']} EUR"
puts "Bitcoin: $#{data['rates']['BTC'].round(2)}"

# Convert amount
usd_amount = 100
eur_amount = usd_amount * data['rates']['EUR']
puts "$#{usd_amount} = €#{eur_amount.round(2)}"

# Convert between any two currencies
def convert(amount, from_rate, to_rate)
  (amount / from_rate) * to_rate
end

# Convert 50 EUR to GBP
eur_to_gbp = convert(50, data['rates']['EUR'], data['rates']['GBP'])
puts "€50 = £#{eur_to_gbp.round(2)}"
```

</details>

<details>
<summary><strong>R</strong></summary>

```r
library(httr)
library(jsonlite)

# Fetch rates
url <- "https://cdn.jsdelivr.net/gh/anvme/currency@main/latest.json"
response <- GET(url)
data <- fromJSON(content(response, "text", encoding = "UTF-8"))

# Get specific rate
cat(sprintf("1 USD = %.4f EUR\n", data$rates$EUR))
cat(sprintf("Bitcoin: $%.2f\n", data$rates$BTC))

# Convert amount
usd_amount <- 100
eur_amount <- usd_amount * data$rates$EUR
cat(sprintf("$%.2f = €%.2f\n", usd_amount, eur_amount))

# Function for conversion
convert <- function(amount, from_rate, to_rate) {
  (amount / from_rate) * to_rate
}

# Convert between currencies
gbp_to_jpy <- convert(50, data$rates$GBP, data$rates$JPY)
cat(sprintf("£50 = ¥%.2f\n", gbp_to_jpy))

# Create a data frame of all rates
rates_df <- data.frame(
  Currency = names(data$rates),
  Rate = unlist(data$rates),
  row.names = NULL
)

# Display top rates
print(head(rates_df[order(-rates_df$Rate), ]))
```

</details>

<details>
<summary><strong>Rust</strong></summary>

```rust
use reqwest;
use serde::{Deserialize, Serialize};
use std::collections::HashMap;

#[derive(Debug, Serialize, Deserialize)]
struct CurrencyResponse {
    updated: String,
    base: String,
    #[serde(rename = "fiatDate")]
    fiat_date: String,
    rates: HashMap<String, f64>,
}

#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    // Fetch rates
    let url = "https://cdn.jsdelivr.net/gh/anvme/currency@main/latest.json";
    let response = reqwest::get(url).await?;
    let data: CurrencyResponse = response.json().await?;
    
    // Get specific rate
    let eur_rate = data.rates.get("EUR").unwrap();
    let btc_rate = data.rates.get("BTC").unwrap();
    
    println!("1 USD = {:.4} EUR", eur_rate);
    println!("Bitcoin: ${:.2}", btc_rate);
    
    // Convert amount
    let usd_amount = 100.0;
    let eur_amount = usd_amount * eur_rate;
    println!("${:.2} = €{:.2}", usd_amount, eur_amount);
    
    // Convert between currencies
    let gbp_rate = data.rates.get("GBP").unwrap();
    let jpy_rate = data.rates.get("JPY").unwrap();
    let gbp_to_jpy = (50.0 / gbp_rate) * jpy_rate;
    println!("£50 = ¥{:.2}", gbp_to_jpy);
    
    Ok(())
}
```

</details>

<details>
<summary><strong>PowerShell</strong></summary>

```powershell
# Fetch rates
$url = "https://cdn.jsdelivr.net/gh/anvme/currency@main/latest.json"
$data = Invoke-RestMethod -Uri $url

# Get specific rate
Write-Host "1 USD = $($data.rates.EUR) EUR"
Write-Host "Bitcoin: `$$([math]::Round($data.rates.BTC, 2))"

# Convert amount
$usdAmount = 100
$eurAmount = $usdAmount * $data.rates.EUR
Write-Host "`$$usdAmount = €$([math]::Round($eurAmount, 2))"

# Function for conversion
function Convert-Currency {
    param(
        [double]$Amount,
        [double]$FromRate,
        [double]$ToRate
    )
    return ($Amount / $FromRate) * $ToRate
}

# Convert between currencies
$gbpToJpy = Convert-Currency -Amount 50 -FromRate $data.rates.GBP -ToRate $data.rates.JPY
Write-Host "£50 = ¥$([math]::Round($gbpToJpy, 2))"

# Display all available currencies
Write-Host "`nAvailable currencies:"
$data.rates.PSObject.Properties | ForEach-Object {
    Write-Host "$($_.Name): $($_.Value)"
} | Sort-Object
```

</details>

<details>
<summary><strong>Scala</strong></summary>

```scala
import scala.concurrent.Future
import scala.concurrent.ExecutionContext.Implicits.global
import scala.io.Source
import play.api.libs.json._

case class CurrencyData(
  updated: String,
  base: String,
  fiatDate: String,
  rates: Map[String, Double]
)

object CurrencyConverter {
  implicit val ratesFormat: Format[Map[String, Double]] = 
    Format(Reads.mapReads[Double], Writes.mapWrites[Double])
  implicit val currencyFormat: Format[CurrencyData] = Json.format[CurrencyData]

  def fetchRates(): Future[CurrencyData] = Future {
    val url = "https://cdn.jsdelivr.net/gh/anvme/currency@main/latest.json"
    val json = Source.fromURL(url).mkString
    Json.parse(json).as[CurrencyData]
  }

  def convert(amount: Double, fromRate: Double, toRate: Double): Double = {
    (amount / fromRate) * toRate
  }

  def main(args: Array[String]): Unit = {
    fetchRates().map { data =>
      // Get specific rate
      val eurRate = data.rates("EUR")
      val btcRate = data.rates("BTC")
      
      println(f"1 USD = $eurRate%.4f EUR")
      println(f"Bitcoin: $$$btcRate%.2f")
      
      // Convert amount
      val usdAmount = 100.0
      val eurAmount = usdAmount * eurRate
      println(f"$$$usdAmount = €$eurAmount%.2f")
      
      // Convert between currencies
      val gbpToJpy = convert(50, data.rates("GBP"), data.rates("JPY"))
      println(f"£50 = ¥$gbpToJpy%.2f")
    }
  }
}
```

</details>

<details>
<summary><strong>MATLAB / Octave</strong></summary>

```matlab
% Fetch rates
url = 'https://cdn.jsdelivr.net/gh/anvme/currency@main/latest.json';
data = webread(url);

% Get specific rate
fprintf('1 USD = %.4f EUR\n', data.rates.EUR);
fprintf('Bitcoin: $%.2f\n', data.rates.BTC);

% Convert amount
usd_amount = 100;
eur_amount = usd_amount * data.rates.EUR;
fprintf('$%.2f = €%.2f\n', usd_amount, eur_amount);

% Function for conversion
function result = convert(amount, from_rate, to_rate)
    result = (amount / from_rate) * to_rate;
end

% Convert between currencies
gbp_to_jpy = convert(50, data.rates.GBP, data.rates.JPY);
fprintf('£50 = ¥%.2f\n', gbp_to_jpy);

% Get all currency codes
currency_codes = fieldnames(data.rates);
fprintf('\nAvailable currencies:\n');
disp(currency_codes);

% Create a table of top 10 rates
rates_array = struct2array(data.rates);
[sorted_rates, idx] = sort(rates_array, 'descend');
sorted_currencies = currency_codes(idx);

fprintf('\nTop 10 currencies by rate:\n');
for i = 1:min(10, length(sorted_currencies))
    fprintf('%s: %.4f\n', sorted_currencies{i}, sorted_rates(i));
end
```

</details>

<details>
<summary><strong>Dart / Flutter</strong></summary>

```dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class CurrencyResponse {
  final String updated;
  final String base;
  final String fiatDate;
  final Map<String, double> rates;

  CurrencyResponse({
    required this.updated,
    required this.base,
    required this.fiatDate,
    required this.rates,
  });

  factory CurrencyResponse.fromJson(Map<String, dynamic> json) {
    return CurrencyResponse(
      updated: json['updated'],
      base: json['base'],
      fiatDate: json['fiatDate'],
      rates: Map<String, double>.from(json['rates']),
    );
  }
}

Future<CurrencyResponse> fetchRates() async {
  final response = await http.get(
    Uri.parse('https://cdn.jsdelivr.net/gh/anvme/currency@main/latest.json'),
  );
  
  if (response.statusCode == 200) {
    return CurrencyResponse.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load rates');
  }
}

double convert(double amount, double fromRate, double toRate) {
  return (amount / fromRate) * toRate;
}

void main() async {
  final data = await fetchRates();
  
  // Get specific rate
  final eurRate = data.rates['EUR']!;
  final btcRate = data.rates['BTC']!;
  
  print('1 USD = ${eurRate.toStringAsFixed(4)} EUR');
  print('Bitcoin: \$${btcRate.toStringAsFixed(2)}');
  
  // Convert amount
  final usdAmount = 100.0;
  final eurAmount = usdAmount * eurRate;
  print('\$${usdAmount.toStringAsFixed(2)} = €${eurAmount.toStringAsFixed(2)}');
  
  // Convert between currencies
  final gbpRate = data.rates['GBP']!;
  final jpyRate = data.rates['JPY']!;
  final gbpToJpy = convert(50, gbpRate, jpyRate);
  print('£50 = ¥${gbpToJpy.toStringAsFixed(2)}');
}
```

</details>

<details>
<summary><strong>Perl</strong></summary>

```perl
use strict;
use warnings;
use LWP::UserAgent;
use JSON;

# Fetch rates
my $url = 'https://cdn.jsdelivr.net/gh/anvme/currency@main/latest.json';
my $ua = LWP::UserAgent->new;
my $response = $ua->get($url);
die "Failed to fetch rates" unless $response->is_success;

my $data = decode_json($response->decoded_content);
my %rates = %{$data->{rates}};

# Get specific rate
printf "1 USD = %.4f EUR\n", $rates{EUR};
printf "Bitcoin: \$%.2f\n", $rates{BTC};

# Convert amount
my $usd_amount = 100;
my $eur_amount = $usd_amount * $rates{EUR};
printf "\$%.2f = €%.2f\n", $usd_amount, $eur_amount;

# Function for conversion
sub convert {
    my ($amount, $from_rate, $to_rate) = @_;
    return ($amount / $from_rate) * $to_rate;
}

# Convert between currencies
my $gbp_to_jpy = convert(50, $rates{GBP}, $rates{JPY});
printf "£50 = ¥%.2f\n", $gbp_to_jpy;

# List all available currencies
print "\nAvailable currencies:\n";
foreach my $currency (sort keys %rates) {
    printf "%s: %.4f\n", $currency, $rates{$currency};
}
```

</details>

<details>
<summary><strong>VBA (Excel)</strong></summary>

```vba
' Add reference to Microsoft XML, v6.0 and Microsoft Scripting Runtime

Sub FetchCurrencyRates()
    Dim http As Object
    Dim json As Object
    Dim url As String
    Dim response As String
    
    ' Create HTTP request
    Set http = CreateObject("MSXML2.XMLHTTP")
    url = "https://cdn.jsdelivr.net/gh/anvme/currency@main/latest.json"
    
    ' Fetch data
    http.Open "GET", url, False
    http.send
    response = http.responseText
    
    ' Parse JSON
    Set json = JsonConverter.ParseJson(response)
    
    ' Write to Excel cells
    Range("A1").Value = "Currency"
    Range("B1").Value = "Rate"
    
    ' EUR rate
    Range("A2").Value = "EUR"
    Range("B2").Value = json("rates")("EUR")
    
    ' BTC rate
    Range("A3").Value = "BTC"
    Range("B3").Value = json("rates")("BTC")
    
    ' Display message
    MsgBox "1 USD = " & json("rates")("EUR") & " EUR" & vbCrLf & _
           "Bitcoin: $" & Format(json("rates")("BTC"), "#,##0.00")
    
    ' Convert 100 USD to EUR
    Dim usdAmount As Double
    Dim eurAmount As Double
    usdAmount = 100
    eurAmount = usdAmount * json("rates")("EUR")
    
    Range("A5").Value = "USD Amount"
    Range("B5").Value = usdAmount
    Range("A6").Value = "EUR Amount"
    Range("B6").Value = eurAmount
End Sub

' Function to convert between currencies
Function ConvertCurrency(amount As Double, fromRate As Double, toRate As Double) As Double
    ConvertCurrency = (amount / fromRate) * toRate
End Function

' Example usage: Convert 50 GBP to JPY
Sub ConvertExample()
    Dim json As Object
    Dim gbpToJpy As Double
    
    ' Assuming json is already loaded
    gbpToJpy = ConvertCurrency(50, json("rates")("GBP"), json("rates")("JPY"))
    
    MsgBox "£50 = ¥" & Format(gbpToJpy, "#,##0.00")
End Sub
```

</details>

<details>
<summary><strong>Objective-C</strong></summary>

```objc
#import <Foundation/Foundation.h>

@interface CurrencyConverter : NSObject
- (void)fetchRates;
@end

@implementation CurrencyConverter

- (void)fetchRates {
    NSURL *url = [NSURL URLWithString:@"https://cdn.jsdelivr.net/gh/anvme/currency@main/latest.json"];
    
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithURL:url 
        completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (error) {
            NSLog(@"Error: %@", error.localizedDescription);
            return;
        }
        
        NSError *jsonError;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data 
                                                            options:0 
                                                              error:&jsonError];
        
        if (jsonError) {
            NSLog(@"JSON Error: %@", jsonError.localizedDescription);
            return;
        }
        
        NSDictionary *rates = json[@"rates"];
        
        // Get specific rate
        double eurRate = [rates[@"EUR"] doubleValue];
        double btcRate = [rates[@"BTC"] doubleValue];
        
        NSLog(@"1 USD = %.4f EUR", eurRate);
        NSLog(@"Bitcoin: $%.2f", btcRate);
        
        // Convert amount
        double usdAmount = 100.0;
        double eurAmount = usdAmount * eurRate;
        NSLog(@"$%.2f = €%.2f", usdAmount, eurAmount);
        
        // Convert between currencies
        double gbpRate = [rates[@"GBP"] doubleValue];
        double jpyRate = [rates[@"JPY"] doubleValue];
        double gbpToJpy = (50.0 / gbpRate) * jpyRate;
        NSLog(@"£50 = ¥%.2f", gbpToJpy);
    }];
    
    [task resume];
}

- (double)convert:(double)amount fromRate:(double)fromRate toRate:(double)toRate {
    return (amount / fromRate) * toRate;
}

@end

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        CurrencyConverter *converter = [[CurrencyConverter alloc] init];
        [converter fetchRates];
        
        // Keep the app running to see results
        [[NSRunLoop currentRunLoop] run];
    }
    return 0;
}
```

</details>

<details>
<summary><strong>Lua</strong></summary>

```lua
-- Requires lua-cjson and lua-http libraries
local http = require("socket.http")
local json = require("cjson")

-- Fetch rates
local url = "https://cdn.jsdelivr.net/gh/anvme/currency@main/latest.json"
local response, status = http.request(url)

if status == 200 then
    local data = json.decode(response)
    local rates = data.rates
    
    -- Get specific rate
    print(string.format("1 USD = %.4f EUR", rates.EUR))
    print(string.format("Bitcoin: $%.2f", rates.BTC))
    
    -- Convert amount
    local usd_amount = 100
    local eur_amount = usd_amount * rates.EUR
    print(string.format("$%.2f = €%.2f", usd_amount, eur_amount))
    
    -- Function for conversion
    local function convert(amount, from_rate, to_rate)
        return (amount / from_rate) * to_rate
    end
    
    -- Convert between currencies
    local gbp_to_jpy = convert(50, rates.GBP, rates.JPY)
    print(string.format("£50 = ¥%.2f", gbp_to_jpy))
    
    -- List available currencies
    print("\nAvailable currencies:")
    for currency, rate in pairs(rates) do
        print(string.format("%s: %.4f", currency, rate))
    end
else
    print("Failed to fetch rates")
end
```

</details>

<details>
<summary><strong>Elixir</strong></summary>

```elixir
# Add :httpoison and :jason to your mix.exs dependencies

defmodule CurrencyConverter do
  def fetch_rates do
    url = "https://cdn.jsdelivr.net/gh/anvme/currency@main/latest.json"
    
    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        Jason.decode!(body)
      {:error, reason} ->
        {:error, reason}
    end
  end

  def convert(amount, from_rate, to_rate) do
    (amount / from_rate) * to_rate
  end

  def demo do
    data = fetch_rates()
    rates = data["rates"]
    
    # Get specific rate
    IO.puts("1 USD = #{rates["EUR"]} EUR")
    IO.puts("Bitcoin: $#{:erlang.float_to_binary(rates["BTC"], decimals: 2)}")
    
    # Convert amount
    usd_amount = 100
    eur_amount = usd_amount * rates["EUR"]
    IO.puts("$#{usd_amount} = €#{:erlang.float_to_binary(eur_amount, decimals: 2)}")
    
    # Convert between currencies
    gbp_to_jpy = convert(50, rates["GBP"], rates["JPY"])
    IO.puts("£50 = ¥#{:erlang.float_to_binary(gbp_to_jpy, decimals: 2)}")
  end
end

# Usage
CurrencyConverter.demo()
```

</details>

<details>
<summary><strong>Julia</strong></summary>

```julia
using HTTP
using JSON

# Fetch rates
url = "https://cdn.jsdelivr.net/gh/anvme/currency@main/latest.json"
response = HTTP.get(url)
data = JSON.parse(String(response.body))

# Get specific rate
rates = data["rates"]
eur_rate = rates["EUR"]
btc_rate = rates["BTC"]

println("1 USD = $(eur_rate) EUR")
println("Bitcoin: \$$(round(btc_rate, digits=2))")

# Convert amount
usd_amount = 100
eur_amount = usd_amount * eur_rate
println("\$$(usd_amount) = €$(round(eur_amount, digits=2))")

# Function for conversion
function convert(amount, from_rate, to_rate)
    return (amount / from_rate) * to_rate
end

# Convert between currencies
gbp_rate = rates["GBP"]
jpy_rate = rates["JPY"]
gbp_to_jpy = convert(50, gbp_rate, jpy_rate)
println("£50 = ¥$(round(gbp_to_jpy, digits=2))")

# Display all available currencies
println("\nAvailable currencies:")
for (currency, rate) in sort(collect(rates))
    println("$(currency): $(round(rate, digits=4))")
end
```

</details>

<details>
<summary><strong>F#</strong></summary>

```fsharp
open System
open System.Net.Http
open System.Text.Json

type CurrencyData = {
    updated: string
    ``base``: string
    fiatDate: string
    rates: Map<string, decimal>
}

let fetchRates () =
    async {
        use client = new HttpClient()
        let! response = client.GetStringAsync("https://cdn.jsdelivr.net/gh/anvme/currency@main/latest.json") 
                        |> Async.AwaitTask
        return JsonSerializer.Deserialize<CurrencyData>(response)
    }

let convert amount fromRate toRate =
    (amount / fromRate) * toRate

[<EntryPoint>]
let main argv =
    let data = fetchRates() |> Async.RunSynchronously
    
    // Get specific rate
    let eurRate = data.rates.["EUR"]
    let btcRate = data.rates.["BTC"]
    
    printfn "1 USD = %.4f EUR" (float eurRate)
    printfn "Bitcoin: $%.2f" (float btcRate)
    
    // Convert amount
    let usdAmount = 100M
    let eurAmount = usdAmount * eurRate
    printfn "$%.2f = €%.2f" (float usdAmount) (float eurAmount)
    
    // Convert between currencies
    let gbpRate = data.rates.["GBP"]
    let jpyRate = data.rates.["JPY"]
    let gbpToJpy = convert 50M gbpRate jpyRate
    printfn "£50 = ¥%.2f" (float gbpToJpy)
    
    // List all currencies
    printfn "\nAvailable currencies:"
    data.rates 
    |> Map.iter (fun currency rate -> printfn "%s: %.4f" currency (float rate))
    
    0
```

</details>

<details>
<summary><strong>Haskell</strong></summary>

```haskell
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}

import Network.HTTP.Simple
import Data.Aeson
import GHC.Generics
import qualified Data.Map as Map
import Data.Maybe (fromMaybe)

data CurrencyResponse = CurrencyResponse
    { updated :: String
    , base :: String
    , fiatDate :: String
    , rates :: Map.Map String Double
    } deriving (Show, Generic)

instance FromJSON CurrencyResponse

fetchRates :: IO (Maybe CurrencyResponse)
fetchRates = do
    request <- parseRequest "https://cdn.jsdelivr.net/gh/anvme/currency@main/latest.json"
    response <- httpJSON request
    return $ getResponseBody response

convert :: Double -> Double -> Double -> Double
convert amount fromRate toRate = (amount / fromRate) * toRate

main :: IO ()
main = do
    maybeData <- fetchRates
    case maybeData of
        Just currencyData -> do
            let ratesMap = rates currencyData
            let eurRate = fromMaybe 0 $ Map.lookup "EUR" ratesMap
            let btcRate = fromMaybe 0 $ Map.lookup "BTC" ratesMap
            
            -- Get specific rate
            putStrLn $ "1 USD = " ++ show eurRate ++ " EUR"
            putStrLn $ "Bitcoin: $" ++ show btcRate
            
            -- Convert amount
            let usdAmount = 100.0
            let eurAmount = usdAmount * eurRate
            putStrLn $ "$" ++ show usdAmount ++ " = €" ++ show eurAmount
            
            -- Convert between currencies
            let gbpRate = fromMaybe 0 $ Map.lookup "GBP" ratesMap
            let jpyRate = fromMaybe 0 $ Map.lookup "JPY" ratesMap
            let gbpToJpy = convert 50 gbpRate jpyRate
            putStrLn $ "£50 = ¥" ++ show gbpToJpy
            
            -- List all currencies
            putStrLn "\nAvailable currencies:"
            mapM_ (\(curr, rate) -> putStrLn $ curr ++ ": " ++ show rate) 
                  (Map.toList ratesMap)
        
        Nothing -> putStrLn "Failed to fetch rates"
```

</details>

<details>
<summary><strong>Erlang</strong></summary>

```erlang
-module(currency_converter).
-export([fetch_rates/0, convert/3, demo/0]).

fetch_rates() ->
    Url = "https://cdn.jsdelivr.net/gh/anvme/currency@main/latest.json",
    {ok, {{_, 200, _}, _, Body}} = httpc:request(get, {Url, []}, [], []),
    jiffy:decode(Body, [return_maps]).

convert(Amount, FromRate, ToRate) ->
    (Amount / FromRate) * ToRate.

demo() ->
    inets:start(),
    ssl:start(),
    
    Data = fetch_rates(),
    Rates = maps:get(<<"rates">>, Data),
    
    % Get specific rate
    EurRate = maps:get(<<"EUR">>, Rates),
    BtcRate = maps:get(<<"BTC">>, Rates),
    
    io:format("1 USD = ~.4f EUR~n", [EurRate]),
    io:format("Bitcoin: $~.2f~n", [BtcRate]),
    
    % Convert amount
    UsdAmount = 100.0,
    EurAmount = UsdAmount * EurRate,
    io:format("$~.2f = €~.2f~n", [UsdAmount, EurAmount]),
    
    % Convert between currencies
    GbpRate = maps:get(<<"GBP">>, Rates),
    JpyRate = maps:get(<<"JPY">>, Rates),
    GbpToJpy = convert(50.0, GbpRate, JpyRate),
    io:format("£50 = ¥~.2f~n", [GbpToJpy]),
    
    % List all currencies
    io:format("~nAvailable currencies:~n"),
    maps:foreach(
        fun(Currency, Rate) -> 
            io:format("~s: ~.4f~n", [Currency, Rate]) 
        end, 
        Rates
    ).
```

</details>

<details>
<summary><strong>Fortran</strong></summary>

```fortran
program currency_converter
    use http
    use json_module
    implicit none
    
    type(json_core) :: json
    type(json_value), pointer :: p, rates
    character(len=:), allocatable :: json_str
    real(8) :: eur_rate, btc_rate, usd_amount, eur_amount
    real(8) :: gbp_rate, jpy_rate, gbp_to_jpy
    logical :: found
    integer :: unit
    
    ! Note: This requires external libraries like json-fortran and http libraries
    ! Fetch data (pseudo-code, actual implementation depends on HTTP library)
    call fetch_url('https://cdn.jsdelivr.net/gh/anvme/currency@main/latest.json', json_str)
    
    ! Parse JSON
    call json%initialize()
    call json%deserialize(p, json_str)
    
    ! Get rates object
    call json%get(p, 'rates', rates, found)
    
    ! Get specific rates
    call json%get(rates, 'EUR', eur_rate, found)
    call json%get(rates, 'BTC', btc_rate, found)
    
    ! Display rates
    print '(A,F10.4,A)', '1 USD = ', eur_rate, ' EUR'
    print '(A,F12.2)', 'Bitcoin: $', btc_rate
    
    ! Convert amount
    usd_amount = 100.0d0
    eur_amount = usd_amount * eur_rate
    print '(A,F8.2,A,F8.2)', '$', usd_amount, ' = €', eur_amount
    
    ! Convert between currencies
    call json%get(rates, 'GBP', gbp_rate, found)
    call json%get(rates, 'JPY', jpy_rate, found)
    gbp_to_jpy = (50.0d0 / gbp_rate) * jpy_rate
    print '(A,F10.2)', '£50 = ¥', gbp_to_jpy
    
    ! Cleanup
    call json%destroy(p)
    
contains
    
    real(8) function convert(amount, from_rate, to_rate)
        real(8), intent(in) :: amount, from_rate, to_rate
        convert = (amount / from_rate) * to_rate
    end function convert
    
end program currency_converter
```

</details>

<details>
<summary><strong>Apex (Salesforce)</strong></summary>

```apex
public class CurrencyConverter {
    
    public class CurrencyResponse {
        public String updated;
        public String base;
        public String fiatDate;
        public Map<String, Decimal> rates;
    }
    
    public static CurrencyResponse fetchRates() {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://cdn.jsdelivr.net/gh/anvme/currency@main/latest.json');
        request.setMethod('GET');
        
        HttpResponse response = http.send(request);
        
        if (response.getStatusCode() == 200) {
            return (CurrencyResponse) JSON.deserialize(
                response.getBody(), 
                CurrencyResponse.class
            );
        }
        
        return null;
    }
    
    public static Decimal convert(Decimal amount, Decimal fromRate, Decimal toRate) {
        return (amount / fromRate) * toRate;
    }
    
    public static void demo() {
        CurrencyResponse data = fetchRates();
        
        if (data != null && data.rates != null) {
            // Get specific rate
            Decimal eurRate = data.rates.get('EUR');
            Decimal btcRate = data.rates.get('BTC');
            
            System.debug('1 USD = ' + eurRate.setScale(4) + ' EUR');
            System.debug('Bitcoin: $' + btcRate.setScale(2));
            
            // Convert amount
            Decimal usdAmount = 100;
            Decimal eurAmount = usdAmount * eurRate;
            System.debug('$' + usdAmount + ' = €' + eurAmount.setScale(2));
            
            // Convert between currencies
            Decimal gbpRate = data.rates.get('GBP');
            Decimal jpyRate = data.rates.get('JPY');
            Decimal gbpToJpy = convert(50, gbpRate, jpyRate);
            System.debug('£50 = ¥' + gbpToJpy.setScale(2));
            
            // List all available currencies
            System.debug('\nAvailable currencies:');
            for (String currency : data.rates.keySet()) {
                System.debug(currency + ': ' + data.rates.get(currency).setScale(4));
            }
        }
    }
}

// Execute in Anonymous Apex
CurrencyConverter.demo();

// Note: Remember to add the endpoint to Remote Site Settings:
// Setup > Security > Remote Site Settings > New Remote Site
// Remote Site URL: https://cdn.jsdelivr.net
```

</details>

<details>
<summary><strong>SAS</strong></summary>

```sas
/* Fetch currency rates using PROC HTTP */
filename response temp;

proc http
    url="https://cdn.jsdelivr.net/gh/anvme/currency@main/latest.json"
    method="GET"
    out=response;
run;

/* Parse JSON response */
libname rates JSON fileref=response;

/* Read rates into a dataset */
data currency_rates;
    set rates.rates;
run;

/* Display specific rates */
proc sql;
    select element as currency, value as rate format=12.4
    from currency_rates
    where element in ('EUR', 'BTC', 'GBP', 'JPY')
    order by element;
quit;

/* Convert 100 USD to EUR */
data conversion;
    set currency_rates;
    if element = 'EUR' then do;
        usd_amount = 100;
        eur_amount = usd_amount * value;
        output;
    end;
    keep element usd_amount eur_amount;
run;

proc print data=conversion noobs;
    var usd_amount eur_amount;
    format usd_amount eur_amount 12.2;
    title 'Currency Conversion: USD to EUR';
run;

/* Function macro for currency conversion */
%macro convert(amount, from_curr, to_curr);
    proc sql noprint;
        select value into :from_rate
        from currency_rates
        where element = "&from_curr";
        
        select value into :to_rate
        from currency_rates
        where element = "&to_curr";
    quit;
    
    data _null_;
        result = (&amount / &from_rate) * &to_rate;
        put "Converting &amount &from_curr to &to_curr: " result 12.2;
    run;
%mend convert;

/* Convert 50 GBP to JPY */
%convert(50, GBP, JPY);

/* List all available currencies */
proc print data=currency_rates;
    var element value;
    format value 12.4;
    title 'All Available Currency Rates';
run;

/* Clean up */
filename response clear;
libname rates clear;
```

</details>

<details>
<summary><strong>Nim</strong></summary>

```nim
import httpclient
import json
import strformat

type
  CurrencyResponse = object
    updated: string
    base: string
    fiatDate: string
    rates: JsonNode

proc fetchRates(): CurrencyResponse =
  var client = newHttpClient()
  let response = client.getContent("https://cdn.jsdelivr.net/gh/anvme/currency@main/latest.json")
  let data = parseJson(response)
  
  result.updated = data["updated"].getStr()
  result.base = data["base"].getStr()
  result.fiatDate = data["fiatDate"].getStr()
  result.rates = data["rates"]

proc convert(amount: float, fromRate: float, toRate: float): float =
  return (amount / fromRate) * toRate

proc main() =
  let data = fetchRates()
  let rates = data.rates
  
  # Get specific rate
  let eurRate = rates["EUR"].getFloat()
  let btcRate = rates["BTC"].getFloat()
  
  echo fmt"1 USD = {eurRate:.4f} EUR"
  echo fmt"Bitcoin: ${btcRate:.2f}"
  
  # Convert amount
  let usdAmount = 100.0
  let eurAmount = usdAmount * eurRate
  echo fmt"${usdAmount:.2f} = €{eurAmount:.2f}"
  
  # Convert between currencies
  let gbpRate = rates["GBP"].getFloat()
  let jpyRate = rates["JPY"].getFloat()
  let gbpToJpy = convert(50.0, gbpRate, jpyRate)
  echo fmt"£50 = ¥{gbpToJpy:.2f}"
  
  # List all available currencies
  echo "\nAvailable currencies:"
  for currency, rate in rates.pairs:
    echo fmt"{currency}: {rate.getFloat():.4f}"

when isMainModule:
  main()
```

</details>

<details>
<summary><strong>Crystal</strong></summary>

```crystal
require "http/client"
require "json"

struct CurrencyResponse
  include JSON::Serializable
  
  property updated : String
  property base : String
  property fiatDate : String
  property rates : Hash(String, Float64)
end

def fetch_rates : CurrencyResponse
  response = HTTP::Client.get("https://cdn.jsdelivr.net/gh/anvme/currency@main/latest.json")
  CurrencyResponse.from_json(response.body)
end

def convert(amount : Float64, from_rate : Float64, to_rate : Float64) : Float64
  (amount / from_rate) * to_rate
end

# Main execution
data = fetch_rates
rates = data.rates

# Get specific rate
eur_rate = rates["EUR"]
btc_rate = rates["BTC"]

puts "1 USD = #{eur_rate.round(4)} EUR"
puts "Bitcoin: $#{btc_rate.round(2)}"

# Convert amount
usd_amount = 100.0
eur_amount = usd_amount * eur_rate
puts "$#{usd_amount.round(2)} = €#{eur_amount.round(2)}"

# Convert between currencies
gbp_rate = rates["GBP"]
jpy_rate = rates["JPY"]
gbp_to_jpy = convert(50.0, gbp_rate, jpy_rate)
puts "£50 = ¥#{gbp_to_jpy.round(2)}"

# List all available currencies
puts "\nAvailable currencies:"
rates.each do |currency, rate|
  puts "#{currency}: #{rate.round(4)}"
end
```

</details>

<details>
<summary><strong>Tcl</strong></summary>

```tcl
package require http
package require json

# Fetch rates
proc fetchRates {} {
    set url "https://cdn.jsdelivr.net/gh/anvme/currency@main/latest.json"
    set token [::http::geturl $url]
    set data [::http::data $token]
    ::http::cleanup $token
    
    return [::json::json2dict $data]
}

# Convert between currencies
proc convert {amount fromRate toRate} {
    return [expr {($amount / $fromRate) * $toRate}]
}

# Main execution
set data [fetchRates]
set rates [dict get $data rates]

# Get specific rate
set eurRate [dict get $rates EUR]
set btcRate [dict get $rates BTC]

puts "1 USD = [format %.4f $eurRate] EUR"
puts "Bitcoin: \$[format %.2f $btcRate]"

# Convert amount
set usdAmount 100.0
set eurAmount [expr {$usdAmount * $eurRate}]
puts "\$[format %.2f $usdAmount] = €[format %.2f $eurAmount]"

# Convert between currencies
set gbpRate [dict get $rates GBP]
set jpyRate [dict get $rates JPY]
set gbpToJpy [convert 50.0 $gbpRate $jpyRate]
puts "£50 = ¥[format %.2f $gbpToJpy]"

# List all available currencies
puts "\nAvailable currencies:"
dict for {currency rate} $rates {
    puts "$currency: [format %.4f $rate]"
}
```

</details>

<details>
<summary><strong>COBOL</strong></summary>

```cobol
       IDENTIFICATION DIVISION.
       PROGRAM-ID. CURRENCY-CONVERTER.
       
       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT CURRENCY-FILE ASSIGN TO "rates.json"
               ORGANIZATION IS LINE SEQUENTIAL.
       
       DATA DIVISION.
       FILE SECTION.
       FD  CURRENCY-FILE.
       01  CURRENCY-RECORD     PIC X(5000).
       
       WORKING-STORAGE SECTION.
       01  WS-EOF              PIC A(1) VALUE 'N'.
       01  WS-JSON-DATA        PIC X(5000).
       01  WS-EUR-RATE         PIC 9(5)V9(4).
       01  WS-BTC-RATE         PIC 9(8)V9(2).
       01  WS-USD-AMOUNT       PIC 9(5)V9(2) VALUE 100.00.
       01  WS-EUR-AMOUNT       PIC 9(5)V9(2).
       01  WS-GBP-RATE         PIC 9(5)V9(4).
       01  WS-JPY-RATE         PIC 9(5)V9(4).
       01  WS-GBP-AMOUNT       PIC 9(5)V9(2) VALUE 50.00.
       01  WS-JPY-AMOUNT       PIC 9(8)V9(2).
       
       01  WS-DISPLAY-LINE.
           05  WS-MESSAGE      PIC X(50).
           05  WS-AMOUNT       PIC Z(5)9.99.
       
       PROCEDURE DIVISION.
       MAIN-PROCEDURE.
      *    Note: In real COBOL, you would need to:
      *    1. Use CALL to external HTTP library or system command
      *    2. Parse JSON using JSON PARSE statement (COBOL 2002+)
      *    or use external JSON parser
      *    
      *    This is a simplified example showing the logic
           
           DISPLAY "Currency Converter - COBOL Edition".
           DISPLAY "===================================".
           
      *    Simulate fetched data (in real scenario, fetch via HTTP)
           MOVE 0.8598 TO WS-EUR-RATE.
           MOVE 112614.20 TO WS-BTC-RATE.
           MOVE 0.7532 TO WS-GBP-RATE.
           MOVE 152.2872 TO WS-JPY-RATE.
           
      *    Display rates
           DISPLAY "1 USD = " WS-EUR-RATE " EUR".
           DISPLAY "Bitcoin: $" WS-BTC-RATE.
           
      *    Convert USD to EUR
           COMPUTE WS-EUR-AMOUNT = WS-USD-AMOUNT * WS-EUR-RATE.
           DISPLAY "$" WS-USD-AMOUNT " = €" WS-EUR-AMOUNT.
           
      *    Convert GBP to JPY
           COMPUTE WS-JPY-AMOUNT = 
               (WS-GBP-AMOUNT / WS-GBP-RATE) * WS-JPY-RATE.
           DISPLAY "£" WS-GBP-AMOUNT " = ¥" WS-JPY-AMOUNT.
           
           STOP RUN.
```

</details>

<details>
<summary><strong>cURL (Advanced)</strong></summary>

```bash
# Fetch all rates
curl https://cdn.jsdelivr.net/gh/anvme/currency@main/latest.json

# Extract specific rate with jq
curl -s https://cdn.jsdelivr.net/gh/anvme/currency@main/latest.json | jq '.rates.BTC'

# Convert 100 USD to EUR
curl -s https://cdn.jsdelivr.net/gh/anvme/currency@main/latest.json | jq '.rates.EUR * 100'

# Get multiple rates
curl -s https://cdn.jsdelivr.net/gh/anvme/currency@main/latest.json | \
  jq '{EUR: .rates.EUR, GBP: .rates.GBP, BTC: .rates.BTC}'

# Convert between currencies (50 GBP to JPY)
curl -s https://cdn.jsdelivr.net/gh/anvme/currency@main/latest.json | \
  jq '(50 / .rates.GBP) * .rates.JPY'

# Format output nicely
curl -s https://cdn.jsdelivr.net/gh/anvme/currency@main/latest.json | \
  jq -r '"1 USD = \(.rates.EUR) EUR\nBitcoin: $\(.rates.BTC)"'

# Save to file with timestamp
curl -s https://cdn.jsdelivr.net/gh/anvme/currency@main/latest.json \
  -o "rates_$(date +%Y%m%d_%H%M%S).json"
```

</details>
