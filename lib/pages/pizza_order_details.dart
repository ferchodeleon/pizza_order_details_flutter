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
                    flex: 2,
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
            child: PizzaCartButton(),
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

class _PizzaDetailsState extends State<PizzaDetails> {
  final _listIngredients = <Ingredient>[];
  bool _focused = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
            child: DragTarget<Ingredient>(
          onAccept: (ingredient) {
            setState(() {
              _focused = false;
            });
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
            return LayoutBuilder(builder: (context, constraints) {
              return Center(
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 400),
                  height: _focused
                      ? constraints.maxHeight
                      : constraints.maxHeight - 50,
                  child: Stack(
                    children: [
                      Image.asset('assets/dish.png'),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Image.asset('assets/pizza-1.png'),
                      )
                    ],
                  ),
                ),
              );
            });
          },
        )),
        const SizedBox(height: 5.0),
        Text(
          '\$15',
          style: TextStyle(
            color: Colors.brown,
            fontSize: 30.0,
            fontWeight: FontWeight.bold,
          ),
        )
      ],
    );
  }
}

class PizzaCartButton extends StatelessWidget {
  const PizzaCartButton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
      ),
      child: Icon(
        Icons.add_shopping_cart_sharp,
        color: Colors.brown,
        size: 35.0,
      ),
    );
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
          child: child,
        ),
      ),
    );
  }
}
