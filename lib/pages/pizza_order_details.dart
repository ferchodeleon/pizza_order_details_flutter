import 'package:flutter/material.dart';

class PizzaOrderDetails extends StatelessWidget {
  const PizzaOrderDetails({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'New Orleans Pizza',
          style: TextStyle(color: Colors.brown, fontSize: 24.0),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.shopping_cart_outlined,
              color: Colors.brown,
              size: 35.0,
            ),
            onPressed: () {},
          )
        ],
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: null,
    );
  }
}
