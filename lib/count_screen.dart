import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'counter_controller.dart'; // import your controller

class CountScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(title: Text('Counter with GetX')),
      body: Center(
        child: GetBuilder<CounterController>(
          init: CounterController(),
          builder: (controller) => Text(
            'Counter: ${controller.counter}',
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.find<CounterController>().increment();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
