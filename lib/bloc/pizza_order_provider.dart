import 'package:flutter/material.dart';
import 'pizza_order_bloc.dart';

class PizzaOrderProvider extends InheritedWidget {
  final PizzaOrderBloC bloc;
  final Widget child;

  PizzaOrderProvider({this.bloc, @required this.child}) : super(child: child);

  static PizzaOrderBloC of(BuildContext context) =>
      context.findAncestorWidgetOfExactType<PizzaOrderProvider>().bloc;

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => true;
}
