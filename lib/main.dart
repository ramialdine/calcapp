import 'package:flutter/material.dart';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _expression = '';
  String _result = '';

  void _onPressed(String value) {
    setState(() {
      if (value == 'C') {
        _expression = '';
        _result = '';
      } else if (value == '=') {
        try {
          _result = _evaluateExpression(_expression).toString();
          _expression = '$_expression = $_result';
        } catch (e) {
          _result = 'Error';
        }
      } else {
        _expression += value;
      }
    });
  }

  double _evaluateExpression(String expression) {
    List<String> tokens = _tokenize(expression);
    List<String> postfix = _toPostfix(tokens);
    return _evaluatePostfix(postfix);
  }

  // Tokenize the input expression string into numbers and operators
  List<String> _tokenize(String expression) {
    List<String> tokens = [];
    StringBuffer buffer = StringBuffer();
    
    for (int i = 0; i < expression.length; i++) {
      String char = expression[i];
      
      if (_isOperator(char)) {
        if (buffer.isNotEmpty) {
          tokens.add(buffer.toString());
          buffer.clear();
        }
        tokens.add(char);
      } else {
        buffer.write(char);
      }
    }
    
    if (buffer.isNotEmpty) {
      tokens.add(buffer.toString());
    }
    
    return tokens;
  }

  // Convert infix to postfix (RPN) for easier evaluation using Shunting Yard algorithm
  List<String> _toPostfix(List<String> tokens) {
    List<String> output = [];
    List<String> operators = [];
    
    for (String token in tokens) {
      if (_isOperator(token)) {
        while (operators.isNotEmpty && _precedence(operators.last) >= _precedence(token)) {
          output.add(operators.removeLast());
        }
        operators.add(token);
      } else {
        output.add(token);
      }
    }
    
    while (operators.isNotEmpty) {
      output.add(operators.removeLast());
    }
    
    return output;
  }

  // Evaluate the postfix expression
  double _evaluatePostfix(List<String> postfix) {
    List<double> stack = [];
    
    for (String token in postfix) {
      if (_isOperator(token)) {
        double b = stack.removeLast();
        double a = stack.removeLast();
        
        switch (token) {
          case '+':
            stack.add(a + b);
            break;
          case '-':
            stack.add(a - b);
            break;
          case '*':
            stack.add(a * b);
            break;
          case '/':
            stack.add(a / b);
            break;
          case '%':
            stack.add(a % b);
            break;
        }
      } else {
        stack.add(double.parse(token));
      }
    }
    
    return stack.last;
  }

  // Helper to determine if a string is an operator
  bool _isOperator(String token) {
    return token == '+' || token == '-' || token == '*' || token == '/' || token == '%';
  }

  // Helper to get operator precedence
  int _precedence(String operator) {
    if (operator == '+' || operator == '-') return 1;
    if (operator == '*' || operator == '/' || operator == '%') return 2;
    return 0;
  }

  Widget _buildButton(String text, Color color) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            padding: const EdgeInsets.all(20.0),
          ),
          onPressed: () => _onPressed(text),
          child: Text(
            text,
            style: const TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Name\'s Calculator'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              alignment: Alignment.bottomRight,
              padding: const EdgeInsets.all(24),
              child: Text(
                _expression,
                style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const Divider(),
          Expanded(
            child: Container(
              alignment: Alignment.bottomRight,
              padding: const EdgeInsets.all(24),
              child: Text(
                _result,
                style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Row(
            children: <Widget>[
              _buildButton('7', Colors.grey),
              _buildButton('8', Colors.grey),
              _buildButton('9', Colors.grey),
              _buildButton('/', Colors.blue),
            ],
          ),
          Row(
            children: <Widget>[
              _buildButton('4', Colors.grey),
              _buildButton('5', Colors.grey),
              _buildButton('6', Colors.grey),
              _buildButton('*', Colors.blue),
            ],
          ),
          Row(
            children: <Widget>[
              _buildButton('1', Colors.grey),
              _buildButton('2', Colors.grey),
              _buildButton('3', Colors.grey),
              _buildButton('-', Colors.blue),
            ],
          ),
          Row(
            children: <Widget>[
              _buildButton('C', Colors.red),
              _buildButton('0', Colors.grey),
              _buildButton('=', Colors.green),
              _buildButton('+', Colors.blue),
            ],
          ),
          Row(
            children: <Widget>[
              _buildButton('%', Colors.blue),
            ],
          ),
        ],
      ),
    );
  }
}
