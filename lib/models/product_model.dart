class Product {
  final String name;
  final String category;
  final int quantity;

  Product(this.name, this.category, this.quantity);

  static List<Product> products = [
    Product('Apple', 'Fruit', 10),
    Product('Banana', 'Fruit', 5),
    Product('Orange', 'Fruit', 3),
    Product('Carrot', 'Vegetable', 7),
    Product('Potato', 'Vegetable', 2),
    Product('Tomato', 'Vegetable', 4),
    Product('Milk', 'Dairy', 1),
    Product('Cheese', 'Dairy', 2),
    Product('Yogurt', 'Dairy', 3),
  ];
}
