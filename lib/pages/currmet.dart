import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CurrencyConverter extends StatefulWidget {
  const CurrencyConverter({super.key});

  @override
  State<CurrencyConverter> createState() => _CurrencyConverterState();
}

class _CurrencyConverterState extends State<CurrencyConverter> {
  final TextEditingController amountController = TextEditingController();
  double convertedAmount = 0.0;
  String fromCurrency = "USD";
  String toCurrency = "INR";
  Map<String, dynamic> exchangeRates = {};
  final List<String> currencies = [
    "USD", "EUR", "CNY", "JPY", "GBP", "AUD", "CAD", "CHF", "HKD", "SGD", 
    "KRW", "INR", "BRL", "RUB", "ZAR", "MXN", "NZD", "TRY", "SAR", "AED"
  ];

  // Map to store the full form and country of each currency
  final Map<String, String> currencyDetails = {
    "USD": "United States Dollar (USA)",
    "EUR": "Euro (European Union)",
    "CNY": "Chinese Yuan (China)",
    "JPY": "Japanese Yen (Japan)",
    "GBP": "British Pound (United Kingdom)",
    "AUD": "Australian Dollar (Australia)",
    "CAD": "Canadian Dollar (Canada)",
    "CHF": "Swiss Franc (Switzerland)",
    "HKD": "Hong Kong Dollar (Hong Kong)",
    "SGD": "Singapore Dollar (Singapore)",
    "KRW": "South Korean Won (South Korea)",
    "INR": "Indian Rupee (India)",
    "BRL": "Brazilian Real (Brazil)",
    "RUB": "Russian Ruble (Russia)",
    "ZAR": "South African Rand (South Africa)",
    "MXN": "Mexican Peso (Mexico)",
    "NZD": "New Zealand Dollar (New Zealand)",
    "TRY": "Turkish Lira (Turkey)",
    "SAR": "Saudi Riyal (Saudi Arabia)",
    "AED": "United Arab Emirates Dirham (UAE)",
  };

  @override
  void initState() {
    super.initState();
    fetchExchangeRates();
  }

  Future<void> fetchExchangeRates() async {
    const apiKey = "fb3394ac3ebe86b5c63040b8"; // Replace with your valid API key
    final url = Uri.parse("https://v6.exchangerate-api.com/v6/$apiKey/latest/USD");

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          exchangeRates = data["conversion_rates"];
        });
      } else {
        print("Failed to fetch exchange rates. Status Code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching exchange rates: $e");
    }
  }

  void convertCurrency() {
    double input = double.tryParse(amountController.text) ?? 0;
    if (input == 0 || exchangeRates.isEmpty) return;

    // Convert from 'fromCurrency' to USD, then from USD to 'toCurrency'
    double usdAmount = input / exchangeRates[fromCurrency]; 
    double result = usdAmount * exchangeRates[toCurrency];

    setState(() {
      convertedAmount = result;
    });
  }

  void showCurrencyInfo(String currency) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(currencyDetails[currency] ?? "Unknown Currency"),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Currency Converter"),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 234, 193, 46),
        elevation: 4,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.amber.withOpacity(0.8), Colors.white70.withOpacity(0.8)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  "Converted Amount: ${convertedAmount.toStringAsFixed(2)} $toCurrency",
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Enter amount",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => showCurrencyInfo(fromCurrency),
                    child: DropdownButton<String>(
                      value: fromCurrency,
                      onChanged: (value) => setState(() => fromCurrency = value!),
                      items: currencies.map((currency) {
                        return DropdownMenuItem(value: currency, child: Text(currency));
                      }).toList(),
                    ),
                  ),
                  const Icon(Icons.arrow_forward),
                  GestureDetector(
                    onTap: () => showCurrencyInfo(toCurrency),
                    child: DropdownButton<String>(
                      value: toCurrency,
                      onChanged: (value) => setState(() => toCurrency = value!),
                      items: currencies.map((currency) {
                        return DropdownMenuItem(value: currency, child: Text(currency));
                      }).toList(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shadowColor: Colors.black,
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: convertCurrency,
                child: const Text(
                  "Convert",
                  style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
