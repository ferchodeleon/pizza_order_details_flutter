import 'package:flutter/material.dart';

class PizzaCartButton extends StatefulWidget {
  const PizzaCartButton({Key key, this.onTap}) : super(key: key);

  final VoidCallback onTap;

  @override
  _PizzaCartButtonState createState() => _PizzaCartButtonState();
}

class _PizzaCartButtonState extends State<PizzaCartButton>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      // upperBound: 1.0,
      // lowerBound: 1.5,
      duration: const Duration(milliseconds: 150),
      reverseDuration: const Duration(milliseconds: 200),
    );
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _animateButton() async {
    await _animationController.forward(from: 0.0);
    await _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onTap();
        _animateButton();
      },
      child: AnimatedBuilder(
        animation: _animationController,
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.orange.withOpacity(0.5),
                  Colors.orange,
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 15.0,
                  offset: Offset(0.0, 4.0),
                  spreadRadius: 4.0,
                ),
              ]),
          child: Icon(
            Icons.add_shopping_cart_sharp,
            color: Colors.white,
            size: 35.0,
          ),
        ),
        builder: (context, child) {
          return Transform.scale(
            scale: 1 - _animationController.value,
            child: child,
          );
        },
      ),
    );
  }
}
