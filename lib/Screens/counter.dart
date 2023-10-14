import 'package:flutter/material.dart';

class Counter extends StatefulWidget {
  const Counter({super.key});

  @override
  State<Counter> createState() => _CounterState();
}

class _CounterState extends State<Counter> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _resetCounter() {
    setState(() {
      _counter = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: _incrementCounter,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff3a57e8),
          title: Text('Tasbih'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: MediaQuery.of(context).size.height * 0.4),
              Text(
                'Tasbih Count:',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '$_counter',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  FloatingActionButton(
                    backgroundColor: Color(0xff3a57e8),
                    onPressed: _resetCounter,
                    tooltip: 'Reset',
                    child: Icon(Icons.refresh),
                  ),
                ],
              ),
              Spacer(), // This will push the next widget to the bottom
              Container(
                margin: EdgeInsets.only(bottom: 20),
                child: Text(
                  'Double Tap Anywhere to increase',
                  style: TextStyle(color: Color(0xff3a57e8)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
