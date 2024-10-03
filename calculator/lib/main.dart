import 'package:flutter/material.dart';

void main() {
  runApp(CalculatorApp());
}

class CalculatorApp extends StatefulWidget {
  @override
  _CalculatorAppState createState() => _CalculatorAppState();
}

class _CalculatorAppState extends State<CalculatorApp> {
  String _input = '';  // Holds the input expression
  String _result = ''; // Holds the calculated result

  // Function to handle button presses
  void _onPressed(String value) {
    setState(() {
      if (value == 'DEL') {
        // Clear the input or remove the last character
        if (_input.isNotEmpty) {
          _input = _input.substring(0, _input.length - 1);
        }
      } else if (value == '=') {
        // Evaluate the input expression
        _calculateResult();
      } else {
        // Append the pressed button value to the input
        _input += value;
      }
    });
  }

  // Basic calculation logic
  void _calculateResult() {
    try {
      String finalInput = _input;
      finalInput = finalInput.replaceAll('×', '*');
      finalInput = finalInput.replaceAll('÷', '/');
      
      // Evaluate the expression
      Parser parser = Parser();
      _result = parser.evaluateExpression(finalInput).toString();
    } catch (e) {
      _result = 'Error';
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator',
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            // Top blue rectangle with 'Calculator' text
            Container(
              height: 100,
              color: Colors.blue,
              child: Center(
                child: Text(
                  'Calculator',
                  style: TextStyle(
                    fontSize: 32,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            // Display area for input and result
            Container(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              alignment: Alignment.centerRight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _input,
                    style: TextStyle(fontSize: 28, color: Colors.black87),
                  ),
                  SizedBox(height: 10),
                  Text(
                    _result,
                    style: TextStyle(fontSize: 34, color: Colors.black54),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20), // Space between display and buttons
            // First row with DEL and = buttons covering full width
            Row(
              children: [
                Expanded(
                  child: _buildButton('DEL', Colors.blue, Colors.white, true),
                ),
                Expanded(
                  child: _buildButton('=', Colors.blue, Colors.white, true),
                ),
              ],
            ),
            SizedBox(height: 20), // Space below the first row
            // Grid layout for numbers and operators
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0), // Adjust padding for smaller buttons
                child: GridView.count(
                  crossAxisCount: 4,
                  childAspectRatio: 1.2, // Adjust this for smaller buttons
                  children: [
                    // First row: 1, 2, 3, /
                    _buildButton('1', Colors.orange, Colors.white, false),
                    _buildButton('2', Colors.orange, Colors.white, false),
                    _buildButton('3', Colors.orange, Colors.white, false),
                    _buildButton('/', Colors.green, Colors.white, false),
                    // Second row: 4, 5, 6, -
                    _buildButton('4', Colors.orange, Colors.white, false),
                    _buildButton('5', Colors.orange, Colors.white, false),
                    _buildButton('6', Colors.orange, Colors.white, false),
                    _buildButton('-', Colors.green, Colors.white, false),
                    // Third row: 7, 8, 9, *
                    _buildButton('7', Colors.orange, Colors.white, false),
                    _buildButton('8', Colors.orange, Colors.white, false),
                    _buildButton('9', Colors.orange, Colors.white, false),
                    _buildButton('*', Colors.green, Colors.white, false),
                    // Fourth row: ., 0, %, +
                    _buildButton('.', Colors.orange, Colors.white, false),
                    _buildButton('0', Colors.orange, Colors.white, false),
                    _buildButton('%', Colors.green, Colors.white, false),
                    _buildButton('+', Colors.green, Colors.white, false),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Button builder function
  Widget _buildButton(String text, Color bgColor, Color textColor, bool isRectangular) {
    return Container(
      margin: EdgeInsets.all(4.0), // Adjust margin for smaller buttons
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          minimumSize: Size(double.infinity, 50), // Set the button height to a smaller size
          shape: isRectangular
              ? RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                )
              : RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0), // Square for grid buttons
                ),
        ),
        onPressed: () => _onPressed(text), // Call onPressed method when button is pressed
        child: Text(
          text,
          style: TextStyle(color: textColor, fontSize: 20), // Adjusted font size
        ),
      ),
    );
  }
}

// Simple parser to handle operations
class Parser {
  double evaluateExpression(String expression) {
    List<String> tokens = _tokenize(expression);
    return _evaluateTokens(tokens);
  }

  List<String> _tokenize(String expression) {
    final List<String> tokens = [];
    final StringBuffer currentNumber = StringBuffer();

    for (int i = 0; i < expression.length; i++) {
      final char = expression[i];

      if ('0123456789.'.contains(char)) {
        currentNumber.write(char);
      } else {
        if (currentNumber.isNotEmpty) {
          tokens.add(currentNumber.toString());
          currentNumber.clear();
        }
        tokens.add(char);
      }
    }

    if (currentNumber.isNotEmpty) {
      tokens.add(currentNumber.toString());
    }

    return tokens;
  }

  double _evaluateTokens(List<String> tokens) {
    // Support for only +, -, *, / operations, add more if needed
    double currentResult = double.parse(tokens[0]);

    for (int i = 1; i < tokens.length; i += 2) {
      final operator = tokens[i];
      final nextNumber = double.parse(tokens[i + 1]);

      if (operator == '+') {
        currentResult += nextNumber;
      } else if (operator == '-') {
        currentResult -= nextNumber;
      } else if (operator == '*') {
        currentResult *= nextNumber;
      } else if (operator == '/') {
        currentResult /= nextNumber;
      }
    }

    return currentResult;
  }
}
