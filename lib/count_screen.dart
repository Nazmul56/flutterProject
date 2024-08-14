// second_screen.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CountScreen extends StatefulWidget {
  @override
  State<CountScreen> createState() => _CountScreenState();
}

class _CountScreenState extends State<CountScreen> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(title: Text('Second Screen')),
      body: ListView(
        children: <Widget>[
          Text('$_counter'),
          SizedBox(
              width: 50,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  _incrementCounter();
                },
                child: const Text('Increment'),
              ))
        ],
      ),
    );
  }
}
