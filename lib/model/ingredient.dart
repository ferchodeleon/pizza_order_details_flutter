class Ingredient {
  const Ingredient(this.image);
  final String image;

  bool compare(Ingredient ingredient) => ingredient.image == image;
}

final ingredients = const <Ingredient>[
  Ingredient('assets/chili.png'),
  Ingredient('assets/olive.png'),
  Ingredient('assets/onion.png'),
  Ingredient('assets/pea.png'),
  Ingredient('assets/pickle.png'),
  Ingredient('assets/potato.png'),
];
