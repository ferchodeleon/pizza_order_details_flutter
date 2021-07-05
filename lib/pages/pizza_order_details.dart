import 'package:flutter/material.dart';
import 'package:pizza_order/model/ingredient.dart';

class PizzaOrderDetails extends StatelessWidget {
  const PizzaOrderDetails({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const _pizzaSizeButton = 55.0;
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
            left: MediaQuery.of(context).size.width / 2 - _pizzaSizeButton / 2,
            child: PizzaCartButton(
              onTap: () {
                print('cart');
              },
            ),
          )
        ],
      ),
    );
  }
}

class PizzaDetails extends StatefulWidget {
  const PizzaDetails({Key key}) : super(key: key);

  @override
  _PizzaDetailsState createState() => _PizzaDetailsState();
}

class _PizzaDetailsState extends State<PizzaDetails>
    with SingleTickerProviderStateMixin {
  final _listIngredients = <Ingredient>[];
  bool _focused = false;
  int _pizzaPrice = 15;
  AnimationController _animationController;
  List<Animation> _animationList = <Animation>[];
  BoxConstraints _pizzaConstrains;

  Widget _buildIngredientsWidget() {
    List<Widget> elements = [];
    if (_animationList.isNotEmpty) {
      for (int i = 0; i < _listIngredients.length; i++) {
        Ingredient ingredient = _listIngredients[i];
        for (int j = 0; j < ingredient.positions.length; j++) {
          final animation = _animationList[j];
          final position = ingredient.positions[j];
          final positionX = position.dx;
          final positionY = position.dy;
          final _ingredientWidget = Image.asset(ingredient.image, height: 40.0);

          if (i == _listIngredients.length - 1) {
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
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            Expanded(
              child: DragTarget<Ingredient>(
                onAccept: (ingredient) {
                  setState(() {
                    _focused = false;
                    _pizzaPrice++;
                  });
                  _buildIngredientsAnimation();
                  _animationController.forward(from: 0.0);
                  print('on accept');
                },
                onWillAccept: (ingredient) {
                  print('will accept');
                  setState(() {
                    _focused = true;
                  });
                  for (Ingredient i in _listIngredients) {
                    if (i.compare(ingredient)) {
                      return false;
                    }
                  }
                  _listIngredients.add(ingredient);
                  return true;
                },
                onLeave: (ingredient) {
                  setState(() {
                    _focused = false;
                  });
                  print('on leave');
                },
                builder: (context, list, rejects) {
                  return LayoutBuilder(
                    builder: (context, constraints) {
                      _pizzaConstrains = constraints;
                      return Center(
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 400),
                          height: _focused
                              ? constraints.maxHeight
                              : constraints.maxHeight - 50,
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
                                child: Image.asset('assets/pizza-1.png'),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 5.0),
            Text(
              '\$${_pizzaPrice.toString()}',
              style: TextStyle(
                color: Colors.brown,
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
              ),
            )
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
}

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
        ));
  }
}

class PizzaIngredients extends StatelessWidget {
  const PizzaIngredients({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: ingredients.length,
      itemBuilder: (context, index) {
        final ingredient = ingredients[index];
        return PizzaIngredientsItem(ingredient: ingredient);
      },
    );
  }
}

class PizzaIngredientsItem extends StatelessWidget {
  const PizzaIngredientsItem({Key key, this.ingredient}) : super(key: key);

  final Ingredient ingredient;

  @override
  Widget build(BuildContext context) {
    final child = Container(
      height: 60.0,
      width: 60.0,
      decoration: BoxDecoration(
        color: Color(0xFFF5EED3),
        shape: BoxShape.circle,
      ),
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: Image.asset(
          ingredient.image,
          fit: BoxFit.contain,
        ),
      ),
    );
    return Center(
      child: Draggable(
        feedback: child,
        data: ingredient,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              child,
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
