class Pizza {
  int? id;
  String? name;
  String? description;
  double? price;
  String? image;

  Pizza({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.image
  });

  factory Pizza.fromJson(Map<String, dynamic> json) {
    return Pizza(
      id: json['id'],
      name: json['name'] ?? null,
      description: json['description'] ?? null,
      price: json['price']?.toDouble() ?? null,
      image: json['image'] ?? null,
    );
  }

  @override
  String toString() {
    return 'Pizza{id: $id, name: $name, description: $description, price: $price, image: $image}';
  }
}