import 'package:flutter/material.dart';
import 'package:pizza_order/bloc/pizza_order_provider.dart';
import 'package:pizza_order/model/ingredient.dart';

const itemsize = 45.0;

class PizzaIngredients extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = PizzaOrderProvider.of(context);
    return ValueListenableBuilder(
      valueListenable: bloc.notifierTotal,
      builder: (context, value, _) {
        return ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: ingredients.length,
          itemBuilder: (context, index) {
            final ingredient = ingredients[index];
            return PizzaIngredientsItem(
              ingredient: ingredient,
              exits: bloc.containsIngredient(ingredient),
              onTap: () => bloc.removeIngredient(ingredient),
            );
          },
        );
      },
    );
  }
}

class PizzaIngredientsItem extends StatelessWidget {
  const PizzaIngredientsItem({
    Key key,
    this.ingredient,
    this.exits,
    this.onTap,
  }) : super(key: key);

  final Ingredient ingredient;
  final bool exits;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final _buildChild = GestureDetector(
      onTap: exits ? onTap : null,
      child: Container(
        height: 60.0,
        width: 60.0,
        decoration: BoxDecoration(
          color: Color(0xFFF5EED3),
          shape: BoxShape.circle,
        ),
        child: exits
            ? Container(
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(50.0),
                ),
                child: Image.asset(
                  ingredient.image,
                  fit: BoxFit.contain,
                ),
              )
            : Image.asset(
                ingredient.image,
                fit: BoxFit.contain,
              ),
      ),
    );
    return Center(
      child: exits
          ? Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  _buildChild,
                  SizedBox(height: 10.0),
                  Text(
                    ingredient.name,
                    style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            )
          : Draggable(
              feedback: _buildChild,
              data: ingredient,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    _buildChild,
                    SizedBox(height: 10.0),
                    Text(
                      ingredient.name,
                      style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
