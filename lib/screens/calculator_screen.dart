import 'package:flutter/material.dart';
import 'dart:math' as math;

class CalculatorScreen extends StatefulWidget {
  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _output = "0";
  String _currentNumber = "";
  double _firstNumber = 0;
  String _operation = "";
  bool _isNewNumber = true;

  void _onButtonPressed(String buttonText) {
    setState(() {
      if (buttonText == "C") {
        _output = "0";
        _currentNumber = "";
        _firstNumber = 0;
        _operation = "";
        _isNewNumber = true;
      } else if (buttonText == "+" || buttonText == "-" ||
          buttonText == "×" || buttonText == "÷" ||
          buttonText == "x²" || buttonText == "√") {
        if (buttonText == "x²") {
          double number = double.parse(_output);
          _output = (number * number).toString();
          _currentNumber = _output;
        } else if (buttonText == "√") {
          double number = double.parse(_output);
          _output = math.sqrt(number).toString();
          _currentNumber = _output;
        } else {
          _firstNumber = double.parse(_output);
          _operation = buttonText;
          _isNewNumber = true;
        }
      } else if (buttonText == "=") {
        double secondNumber = double.parse(_output);
        if (_operation == "+") {
          _output = (_firstNumber + secondNumber).toString();
        }
        if (_operation == "-") {
          _output = (_firstNumber - secondNumber).toString();
        }
        if (_operation == "×") {
          _output = (_firstNumber * secondNumber).toString();
        }
        if (_operation == "÷") {
          _output = (_firstNumber / secondNumber).toString();
        }
        if (_output.endsWith('.0')) {
          _output = _output.substring(0, _output.length - 2);
        }
        _currentNumber = _output;
        _operation = "";
      } else {
        if (_isNewNumber) {
          _output = buttonText;
          _isNewNumber = false;
        } else {
          _output = _output + buttonText;
        }
        _currentNumber = _output;
      }
    });
  }

  Widget _buildButton(String buttonText, {Color? color, double size = 24}) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.all(4),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: color ?? Colors.grey[300],
            foregroundColor: color != null ? Colors.white : Colors.black87,
            padding: EdgeInsets.all(24),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: () => _onButtonPressed(buttonText),
          child: Text(
            buttonText,
            style: TextStyle(
              fontSize: size,
              fontWeight: FontWeight.bold,
              color: color != null ? Colors.white : Colors.black87,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Calculator'),
        backgroundColor: Colors.indigo,
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(24),
            alignment: Alignment.bottomRight,
            child: Text(
              _output,
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          Divider(thickness: 2, color: Colors.grey),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(8),
              child: Column(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        _buildButton("C", color: Colors.red),
                        _buildButton("x²", color: Colors.indigo),
                        _buildButton("√", color: Colors.indigo),
                        _buildButton("÷", color: Colors.indigo),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        _buildButton("7"),
                        _buildButton("8"),
                        _buildButton("9"),
                        _buildButton("×", color: Colors.indigo),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        _buildButton("4"),
                        _buildButton("5"),
                        _buildButton("6"),
                        _buildButton("-", color: Colors.indigo),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        _buildButton("1"),
                        _buildButton("2"),
                        _buildButton("3"),
                        _buildButton("+", color: Colors.indigo),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        _buildButton("0", size: 24),
                        _buildButton("."),
                        _buildButton("=", color: Colors.indigo),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
