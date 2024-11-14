import 'package:flutter/material.dart';

class DiscountCalculatorScreen extends StatefulWidget {
  @override
  _DiscountCalculatorScreenState createState() => _DiscountCalculatorScreenState();
}

class _DiscountCalculatorScreenState extends State<DiscountCalculatorScreen> {
  double _originalPrice = 0.0;
  double _discountPercentage = 0.0;
  double _discountedPrice = 0.0;

  void _calculateDiscountedPrice() {
    setState(() {
      _discountedPrice = _originalPrice * (1 - _discountPercentage / 100);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Discount Calculator'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Enter the original price and discount percentage:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Original Price'),
                    SizedBox(height: 8),
                    SizedBox(
                      width: 150,
                      child: TextField(
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          setState(() {
                            _originalPrice = double.parse(value);
                          });
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Discount (%)'),
                    SizedBox(height: 8),
                    SizedBox(
                      width: 150,
                      child: TextField(
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          setState(() {
                            _discountPercentage = double.parse(value);
                          });
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: _calculateDiscountedPrice,
              child: Text('Calculate Discounted Price'),
            ),
            SizedBox(height: 24),
            if (_discountedPrice > 0)
              Text(
                'The discounted price is: \$${_discountedPrice.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
      ),
    );
  }
}