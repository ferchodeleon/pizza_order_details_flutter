import 'package:flutter/material.dart';

class PizzaSizeButton extends StatelessWidget {
  const PizzaSizeButton({
    Key key,
    this.selected,
    this.text,
    this.onTap,
  }) : super(key: key);

  final bool selected;
  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            boxShadow: selected
                ? [
                    BoxShadow(
                      spreadRadius: 3.0,
                      color: Colors.black12,
                      offset: Offset(0.0, 2.0),
                      blurRadius: 5.0,
                    ),
                  ]
                : null,
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              text,
              style: TextStyle(
                color: Colors.brown,
                fontWeight: selected ? FontWeight.bold : FontWeight.w400,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
