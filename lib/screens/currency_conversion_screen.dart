import 'package:flutter/material.dart';

class CurrencyConverterScreen extends StatefulWidget {
  @override
  _CurrencyConverterScreenState createState() => _CurrencyConverterScreenState();
}

class _CurrencyConverterScreenState extends State<CurrencyConverterScreen> {
  double _amount = 0.0;
  double _convertedAmount = 0.0;
  String _fromCurrency = 'USD';
  String _toCurrency = 'EUR';
  bool _showConversionResult = false;

  final Map<String, double> _currencyRates = {
    'USD': 1.0,
    'EUR': 0.85,
    'JPY': 110.15,
    'GBP': 0.72,
    'AUD': 1.31,
    'CAD': 1.25,
    'CHF': 0.92,
    'CNY': 6.46,
    'HKD': 7.76,
    'NZD': 1.39,
    'SEK': 8.44,
    'SGD': 1.33,
    'KRW': 1115.40,
    'ZAR': 14.27,
    'MXN': 19.94,
    'IDR': 15000.0, // Added IDR (Indonesian Rupiah)
  };

  void _convertCurrency() {
    if (_amount <= 0) return;

    double rate = _currencyRates[_toCurrency]! / _currencyRates[_fromCurrency]!;
    setState(() {
      _convertedAmount = _amount * rate;
      _showConversionResult = true;
    });
  }

  Widget _buildCurrencyDropdown(String currency, ValueChanged<String?> onChanged) {
    return DropdownButton<String>(
      value: currency,
      onChanged: onChanged,
      icon: Icon(Icons.arrow_drop_down_circle, color: Colors.deepPurple),
      items: _currencyRates.keys.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Row(
            children: [
              Icon(Icons.monetization_on, color: Colors.deepPurple), // Currency icon
              SizedBox(width: 8),
              Text(value, style: TextStyle(fontSize: 18)),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildConversionResult() {
    return AnimatedOpacity(
      opacity: _showConversionResult ? 1.0 : 0.0,
      duration: Duration(milliseconds: 300),
      child: Card(
        elevation: 8,
        margin: EdgeInsets.only(top: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.deepPurple[50],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Conversion Result:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
              SizedBox(height: 8),
              Text(
                '$_amount $_fromCurrency = ${_convertedAmount.toStringAsFixed(2)} $_toCurrency',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Currency Converter'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Convert Currency:',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: TextField(
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        _amount = double.tryParse(value) ?? 0.0;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Enter Amount',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.attach_money, color: Colors.deepPurple),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                _buildCurrencyDropdown(_fromCurrency, (newValue) {
                  setState(() {
                    _fromCurrency = newValue!;
                  });
                }),
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildCurrencyDropdown(_toCurrency, (newValue) {
                  setState(() {
                    _toCurrency = newValue!;
                  });
                }),
                SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _convertCurrency,
                  child: Text('Convert', style: TextStyle(fontSize: 16)),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.deepPurple),
                    padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 24, vertical: 12)),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    )),
                  ),
                ),
              ],
            ),
            _buildConversionResult(),
          ],
        ),
      ),
    );
  }
}
