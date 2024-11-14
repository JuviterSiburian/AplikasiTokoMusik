import 'package:flutter/material.dart';

class BmiScreen extends StatefulWidget {
  @override
  _BmiScreenState createState() => _BmiScreenState();
}

class _BmiScreenState extends State<BmiScreen> {
  double _height = 170.0;
  double _weight = 70.0;
  double _bmi = 0.0;
  String _category = "";

  void _calculateBmi() {
    setState(() {
      _bmi = _weight / ((_height / 100) * (_height / 100));

      // Determine BMI category
      if (_bmi < 18.5) {
        _category = "Underweight";
      } else if (_bmi >= 18.5 && _bmi < 24.9) {
        _category = "Normal weight";
      } else if (_bmi >= 25 && _bmi < 29.9) {
        _category = "Overweight";
      } else {
        _category = "Obesity";
      }
    });
  }

  Color _getBmiColor() {
    if (_bmi < 18.5) return Colors.blue;
    if (_bmi >= 18.5 && _bmi < 24.9) return Colors.green;
    if (_bmi >= 25 && _bmi < 29.9) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BMI Calculator'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Enter your height and weight:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Text('Height (cm): ${_height.toStringAsFixed(1)}'),
            Slider(
              value: _height,
              min: 100,
              max: 220,
              divisions: 120,
              label: "${_height.toStringAsFixed(1)} cm",
              onChanged: (value) {
                setState(() {
                  _height = value;
                });
              },
            ),
            SizedBox(height: 16),
            Text('Weight (kg): ${_weight.toStringAsFixed(1)}'),
            Slider(
              value: _weight,
              min: 30,
              max: 150,
              divisions: 120,
              label: "${_weight.toStringAsFixed(1)} kg",
              onChanged: (value) {
                setState(() {
                  _weight = value;
                });
              },
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: _calculateBmi,
              child: Text('Calculate BMI'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple, // Ganti primary dengan backgroundColor
              ),
            ),
            SizedBox(height: 24),
            if (_bmi > 0)
              Column(
                children: [
                  Text(
                    'Your BMI is: ${_bmi.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Category: $_category',
                    style: TextStyle(
                      fontSize: 18,
                      color: _getBmiColor(),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
