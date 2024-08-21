import 'package:get/get.dart';

class CounterController extends GetxController {
  var counter = 0;

  void increment() {
    counter++;
    update(); // Triggers UI update
  }
}