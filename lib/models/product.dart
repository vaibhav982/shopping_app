class Product {
  final int? id;
  final String name;
  final int price;

  Product({this.id, required this.name, required this.price});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ??
          DateTime.now().millisecondsSinceEpoch, // Generate unique ID if null
      name: json['name'],
      price: json['price'],
    );
  }
}
