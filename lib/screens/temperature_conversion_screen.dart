import 'package:flutter/material.dart';

class TemperatureConverterScreen extends StatefulWidget {
  @override
  _TemperatureConverterScreenState createState() => _TemperatureConverterScreenState();
}

class _TemperatureConverterScreenState extends State<TemperatureConverterScreen> {
  double _temperature = 0.0;
  String _fromUnit = 'Celsius';
  String _toUnit = 'Fahrenheit';

  void _convertTemperature() {
    double convertedTemp = 0.0;
    if (_fromUnit == 'Celsius' && _toUnit == 'Fahrenheit') {
      convertedTemp = (_temperature * 9 / 5) + 32;
    } else if (_fromUnit == 'Celsius' && _toUnit == 'Kelvin') {
      convertedTemp = _temperature + 273.15;
    } else if (_fromUnit == 'Fahrenheit' && _toUnit == 'Celsius') {
      convertedTemp = (_temperature - 32) * 5 / 9;
    } else if (_fromUnit == 'Fahrenheit' && _toUnit == 'Kelvin') {
      convertedTemp = (_temperature - 32) * 5 / 9 + 273.15;
    } else if (_fromUnit == 'Kelvin' && _toUnit == 'Celsius') {
      convertedTemp = _temperature - 273.15;
    } else if (_fromUnit == 'Kelvin' && _toUnit == 'Fahrenheit') {
      convertedTemp = (_temperature - 273.15) * 9 / 5 + 32;
    }
    setState(() {
      _temperature = convertedTemp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Temperature Converter'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  _temperature = double.parse(value);
                });
              },
              decoration: InputDecoration(
                hintText: 'Enter temperature',
              ),
            ),
            SizedBox(height: 16.0),
            Row(
              children: [
                DropdownButton<String>(
                  value: _fromUnit,
                  onChanged: (newValue) {
                    setState(() {
                      _fromUnit = newValue!;
                    });
                  },
                  items: ['Celsius', 'Fahrenheit', 'Kelvin']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                SizedBox(width: 16.0),
                DropdownButton<String>(
                  value: _toUnit,
                  onChanged: (newValue) {
                    setState(() {
                      _toUnit = newValue!;
                    });
                  },
                  items: ['Celsius', 'Fahrenheit', 'Kelvin']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _convertTemperature,
              child: Text('Convert'),
            ),
            SizedBox(height: 16.0),
            Text(
              '${_temperature.toStringAsFixed(2)} $_toUnit',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}