import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() => runApp(ScientificCalculator());

class ScientificCalculator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Scientific Calculator',
      theme: ThemeData.dark(useMaterial3: true).copyWith(
        scaffoldBackgroundColor: Colors.black,
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Colors.white, fontSize: 24),
        ),
      ),
      home: CalculatorHome(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class CalculatorHome extends StatefulWidget {
  @override
  _CalculatorHomeState createState() => _CalculatorHomeState();
}

class _CalculatorHomeState extends State<CalculatorHome> {
  String expression = '';
  String result = '';

  void _onButtonPressed(String text) {
    setState(() {
      if (text == 'C') {
        expression = '';
        result = '';
      } else if (text == '⌫') {
        if (expression.isNotEmpty) {
          expression = expression.substring(0, expression.length - 1);
        }
      } else if (text == '=') {
        try {
          String parsedExpr = expression
              .replaceAll('×', '*')
              .replaceAll('÷', '/')
              .replaceAll('π', '3.1415926535')
              .replaceAllMapped(RegExp(r'√(\d+(\.\d+)?)'), (m) => 'sqrt(${m[1]})')
              .replaceAllMapped(RegExp(r'sin(\d+(\.\d+)?)'), (m) => 'sin(${m[1]})')
              .replaceAllMapped(RegExp(r'cos(\d+(\.\d+)?)'), (m) => 'cos(${m[1]})')
              .replaceAllMapped(RegExp(r'tan(\d+(\.\d+)?)'), (m) => 'tan(${m[1]})')
              .replaceAllMapped(RegExp(r'log(\d+(\.\d+)?)'), (m) => 'log10(${m[1]})');

          Parser p = Parser();
          Expression exp = p.parse(parsedExpr);
          ContextModel cm = ContextModel();
          double eval = exp.evaluate(EvaluationType.REAL, cm);
          result = eval.toStringAsFixed(6).replaceAll(RegExp(r'\.?0+$'), '');
        } catch (e) {
          result = 'Error';
        }
      } else {
        if (text == '.' && expression.endsWith('.')) return;
        expression += text;
      }
    });
  }

  Widget buildButton(String text, {Color? color}) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color ?? Colors.grey[900],
        padding: EdgeInsets.all(20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onPressed: () => _onButtonPressed(text),
      child: Text(text, style: TextStyle(fontSize: 22, color: Colors.white)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final buttons = [
      ['C', '⌫', '(', ')'],
      ['sin', 'cos', 'tan', '√'],
      ['7', '8', '9', '÷'],
      ['4', '5', '6', '×'],
      ['1', '2', '3', '-'],
      ['0', '.', 'π', '+'],
      ['log', '^', '=', '']
    ];

    return Scaffold(
      appBar: AppBar(title: Text('Scientific Calculator')),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(20),
            alignment: Alignment.centerRight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(expression, style: TextStyle(fontSize: 28, color: Colors.white70)),
                SizedBox(height: 10),
                Text(result, style: TextStyle(fontSize: 34, color: Colors.greenAccent)),
              ],
            ),
          ),
          Divider(color: Colors.white24),
          Expanded(
            child: GridView.count(
              crossAxisCount: 4,
              padding: EdgeInsets.all(10),
              children: buttons.expand((row) => row.map((btn) {
                if (btn.isEmpty) return SizedBox.shrink();
                Color color = ['C', '⌫'].contains(btn)
                    ? Colors.redAccent
                    : ['=', '+', '-', '×', '÷', '^'].contains(btn)
                        ? Colors.deepPurple
                        : ['sin', 'cos', 'tan', 'log', '√', 'π'].contains(btn)
                            ? Colors.blueGrey
                            : Colors.grey[850]!;
                return Padding(
                  padding: const EdgeInsets.all(4),
                  child: buildButton(btn, color: color),
                );
              })).toList(),
            ),
          )
        ],
      ),
    );
  }
}
