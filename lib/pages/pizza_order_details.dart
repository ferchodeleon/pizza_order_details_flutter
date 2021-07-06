import 'package:flutter/material.dart';
import 'package:pizza_order/bloc/pizza_order_bloc.dart';
import 'package:pizza_order/bloc/pizza_order_provider.dart';
import 'package:pizza_order/widgets/pizza_ingredients.dart';

import '../model/ingredient.dart';
import '../widgets/pizza_card_button.dart';
import '../widgets/pizza_size_button.dart';

class PizzaOrderDetails extends StatefulWidget {
  const PizzaOrderDetails({Key key}) : super(key: key);

  @override
  _PizzaOrderDetailsState createState() => _PizzaOrderDetailsState();
}

class _PizzaOrderDetailsState extends State<PizzaOrderDetails> {
  @override
  Widget build(BuildContext context) {
    final pizzaOrderBloc = PizzaOrderBloC();
    const _pizzaSizeButton = 55.0;
    return PizzaOrderProvider(
      bloc: pizzaOrderBloc,
      child: Scaffold(
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
        body: Stack(
          children: [
            Positioned.fill(
              right: 10.0,
              left: 10.0,
              bottom: 50.0,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                elevation: 10.0,
                child: Column(
                  children: [
                    Expanded(
                      flex: 3,
                      child: PizzaDetails(),
                    ),
                    Expanded(
                      flex: 1,
                      child: PizzaIngredients(),
                    )
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 25.0,
              width: _pizzaSizeButton,
              height: _pizzaSizeButton,
              left:
                  MediaQuery.of(context).size.width / 2 - _pizzaSizeButton / 2,
              child: PizzaCartButton(
                onTap: () {
                  print('cart');
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

class PizzaDetails extends StatefulWidget {
  const PizzaDetails({Key key}) : super(key: key);

  @override
  _PizzaDetailsState createState() => _PizzaDetailsState();
}

enum _PizzaSizeValue { s, m, l }

class _PizzaSizeState {
  _PizzaSizeState(this.value) : factor = _getFactorBySize(value);
  final _PizzaSizeValue value;
  final double factor;

  static double _getFactorBySize(_PizzaSizeValue value) {
    switch (value) {
      case _PizzaSizeValue.s:
        return 0.78;
      case _PizzaSizeValue.m:
        return 0.88;
      case _PizzaSizeValue.l:
        return 1.00;
    }
    return 1.0;
  }
}

class _PizzaDetailsState extends State<PizzaDetails>
    with TickerProviderStateMixin {
  AnimationController _animationController;
  AnimationController _animationRotationController;
  final _notifierFocused = ValueNotifier(false);
  List<Animation> _animationList = <Animation>[];
  BoxConstraints _pizzaConstrains;
  final _notifierPizzaSize = ValueNotifier<_PizzaSizeState>(
    _PizzaSizeState(_PizzaSizeValue.m),
  );

  Widget _buildIngredientsWidget() {
    final listIngredient = PizzaOrderProvider.of(context).listIngredients;
    List<Widget> elements = [];
    if (_animationList.isNotEmpty) {
      for (int i = 0; i < listIngredient.length; i++) {
        Ingredient ingredient = listIngredient[i];
        for (int j = 0; j < ingredient.positions.length; j++) {
          final animation = _animationList[j];
          final position = ingredient.positions[j];
          final positionX = position.dx;
          final positionY = position.dy;
          final _ingredientWidget = Image.asset(ingredient.image, height: 40.0);

          if (i == listIngredient.length - 1) {
            double fromX = 0.0, fromY = 0.0;
            if (j < 1) {
              fromX = -_pizzaConstrains.maxWidth * (1 - animation.value);
            } else if (j < 2) {
              fromX = _pizzaConstrains.maxWidth * (1 - animation.value);
            } else if (j < 4) {
              fromY = -_pizzaConstrains.maxHeight * (1 - animation.value);
            } else {
              fromY = _pizzaConstrains.maxHeight * (1 - animation.value);
            }

            final opacity = animation.value;

            if (animation.value > 0) {
              elements.add(
                Opacity(
                  opacity: opacity,
                  child: Transform(
                      transform: Matrix4.identity()
                        ..translate(
                          fromX + _pizzaConstrains.maxWidth * positionX,
                          fromY + _pizzaConstrains.maxHeight * positionY,
                        ),
                      child: _ingredientWidget),
                ),
              );
            }
          } else {
            elements.add(
              Transform(
                transform: Matrix4.identity()
                  ..translate(
                    _pizzaConstrains.maxWidth * positionX,
                    _pizzaConstrains.maxHeight * positionY,
                  ),
                child: _ingredientWidget,
              ),
            );
          }
        }
      }
      return Stack(
        children: elements,
      );
    }
    return SizedBox.fromSize();
  }

  void _buildIngredientsAnimation() {
    _animationList.clear();
    _animationList.add(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.0, 0.8, curve: Curves.decelerate),
      ),
    );
    _animationList.add(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.2, 0.8, curve: Curves.decelerate),
      ),
    );
    _animationList.add(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.4, 1.0, curve: Curves.decelerate),
      ),
    );
    _animationList.add(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.1, 0.7, curve: Curves.decelerate),
      ),
    );
    _animationList.add(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.3, 1.0, curve: Curves.decelerate),
      ),
    );
  }

  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _animationRotationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _animationRotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = PizzaOrderProvider.of(context);
    return Stack(
      children: [
        Column(
          children: [
            Expanded(
              child: DragTarget<Ingredient>(
                onAccept: (ingredient) {
                  print('on accept');
                  _notifierFocused.value = false;
                  bloc.addIngredient(ingredient);
                  _buildIngredientsAnimation();
                  _animationController.forward(from: 0.0);
                },
                onWillAccept: (ingredient) {
                  print('onWillAccept');
                  _notifierFocused.value = true;
                  return !bloc.containsIngredient(ingredient);
                },
                onLeave: (ingredient) {
                  _notifierFocused.value = false;
                  print('on leave');
                },
                builder: (context, list, rejects) {
                  return LayoutBuilder(
                    builder: (context, constraints) {
                      _pizzaConstrains = constraints;
                      return ValueListenableBuilder<_PizzaSizeState>(
                        valueListenable: _notifierPizzaSize,
                        builder: (context, pizzaSize, _) {
                          return RotationTransition(
                            turns: CurvedAnimation(
                              curve: Curves.elasticOut,
                              parent: _animationRotationController,
                            ),
                            child: Stack(
                              children: [
                                Center(
                                  child: AnimatedContainer(
                                    duration: Duration(milliseconds: 400),
                                    height: _notifierFocused.value
                                        ? constraints.maxHeight *
                                            pizzaSize.factor
                                        : constraints.maxHeight *
                                                pizzaSize.factor -
                                            50,
                                    child: Stack(
                                      children: [
                                        DecoratedBox(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            boxShadow: [
                                              BoxShadow(
                                                blurRadius: 15.0,
                                                color: Colors.black26,
                                                offset: Offset(0.0, 3.0),
                                                spreadRadius: 5.0,
                                              ),
                                            ],
                                          ),
                                          child: Image.asset('assets/dish.png'),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child:
                                              Image.asset('assets/pizza-1.png'),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 5.0),
            ValueListenableBuilder<int>(
              valueListenable: bloc.notifierTotal,
              builder: (context, totalValue, _) {
                return Text(
                  '\$$totalValue',
                  style: TextStyle(
                    color: Colors.brown,
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                  ),
                );
                // return AnimatedSwitcher(
                //   duration: const Duration(milliseconds: 300),
                //   transitionBuilder: (child, animation) {
                //     return FadeTransition(
                //       opacity: animation,
                //       child: SlideTransition(
                //         position: animation.drive(
                //           Tween<Offset>(
                //             begin: Offset(0.0, 0.0),
                //             end: Offset(
                //               0.0,
                //               animation.value,
                //             ),
                //           ),
                //         ),
                //         child: child,
                //       ),
                //     );
                //   },
                //   child: Text(
                //     '\$$totalValue',
                //     style: TextStyle(
                //       color: Colors.brown,
                //       fontSize: 30.0,
                //       fontWeight: FontWeight.bold,
                //     ),
                //   ),
                // );
              },
            ),
            const SizedBox(height: 20.0),
            ValueListenableBuilder<_PizzaSizeState>(
                valueListenable: _notifierPizzaSize,
                builder: (context, pizzaSize, _) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      PizzaSizeButton(
                        text: 'S',
                        onTap: () {
                          _updatePizzaSize(_PizzaSizeValue.s);
                        },
                        selected: pizzaSize.value == _PizzaSizeValue.s,
                      ),
                      PizzaSizeButton(
                        text: 'M',
                        onTap: () {
                          _updatePizzaSize(_PizzaSizeValue.m);
                        },
                        selected: pizzaSize.value == _PizzaSizeValue.m,
                      ),
                      PizzaSizeButton(
                        text: 'L',
                        onTap: () {
                          _updatePizzaSize(_PizzaSizeValue.l);
                        },
                        selected: pizzaSize.value == _PizzaSizeValue.l,
                      ),
                    ],
                  );
                }),
            const SizedBox(height: 20.0),
          ],
        ),
        AnimatedBuilder(
          animation: _animationController,
          builder: (context, _) {
            return _buildIngredientsWidget();
          },
        )
      ],
    );
  }

  void _updatePizzaSize(_PizzaSizeValue value) {
    _notifierPizzaSize.value = _PizzaSizeState(value);
    _animationRotationController.forward(from: 0.0);
  }
}
