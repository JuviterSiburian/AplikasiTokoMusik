import 'package:flutter/material.dart';
import 'dart:math';

class StatisticsScreen extends StatefulWidget {
  @override
  _StatisticsScreenState createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen>
    with SingleTickerProviderStateMixin {
  final List<double> _numbers = [];
  late AnimationController _controller;
  late Animation<double> _animation;
  TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    _textController.dispose();
    super.dispose();
  }

  void _addNumber() {
    setState(() {
      final input = _textController.text;
      if (input.isNotEmpty) {
        _numbers.add(double.parse(input));
        _textController.clear();
        _controller.forward(from: 0); // Restart animation
      }
    });
  }

  double _calculateMean() {
    if (_numbers.isEmpty) return 0;
    final sum = _numbers.reduce((a, b) => a + b);
    return sum / _numbers.length;
  }

  double _calculateMedian() {
    if (_numbers.isEmpty) return 0;
    List<double> sortedNumbers = List.from(_numbers)..sort();
    int middle = sortedNumbers.length ~/ 2;
    if (sortedNumbers.length.isOdd) {
      return sortedNumbers[middle];
    } else {
      return (sortedNumbers[middle - 1] + sortedNumbers[middle]) / 2;
    }
  }

  List<double> _calculateMode() {
    if (_numbers.isEmpty) return [];
    Map<double, int> frequencyMap = {};
    for (var num in _numbers) {
      frequencyMap[num] = (frequencyMap[num] ?? 0) + 1;
    }
    int maxFrequency = frequencyMap.values.reduce(max);
    List<double> modes = frequencyMap.entries
        .where((entry) => entry.value == maxFrequency)
        .map((entry) => entry.key)
        .toList();
    return modes.length > 1 ? modes : [modes.first];
  }

  double _calculateVariance() {
    if (_numbers.isEmpty) return 0;
    double mean = _calculateMean();
    double sumOfSquares = _numbers.map((x) => pow(x - mean, 2).toDouble()).reduce((a, b) => a + b);
    return sumOfSquares / _numbers.length;
  }

  double _calculateStandardDeviation() {
    return sqrt(_calculateVariance());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Statistics Screen"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _textController,
              decoration: InputDecoration(
                labelText: "Enter a number",
                suffixIcon: IconButton(
                  icon: Icon(Icons.add),
                  onPressed: _addNumber,
                ),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            FadeTransition(
              opacity: _animation,
              child: Column(
                children: [
                  Text("Mean: ${_calculateMean().toStringAsFixed(2)}"),
                  Text("Median: ${_calculateMedian().toStringAsFixed(2)}"),
                  Text("Mode: ${_calculateMode().isNotEmpty ? _calculateMode().join(', ') : 'No mode'}"),
                  Text("Variance: ${_calculateVariance().toStringAsFixed(2)}"),
                  Text("Standard Deviation: ${_calculateStandardDeviation().toStringAsFixed(2)}"),
                ],
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _numbers.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_numbers[index].toString()),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
