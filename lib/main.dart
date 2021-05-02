import 'package:flutter/material.dart';
import 'package:pizza_order/pages/pizza_order_details.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Pizza Order', home: PizzaOrderDetails());
  }
}
