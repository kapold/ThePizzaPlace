class Pizza {
  int? id;
  String? name;
  String? description;
  double? price;
  String? image;

  Pizza({
    this.id,
    this.name,
    this.description,
    this.price,
    this.image
  });

  factory Pizza.fromJson(Map<String, dynamic> json) {
    return Pizza(
      id: json['id'],
      name: json['name'] ?? null,
      description: json['description'] ?? null,
      price: double.parse(json['price'].toString()),
      image: json['image'] ?? null,
    );
  }

  @override
  String toString() {
    return 'Pizza{id: $id, name: $name, description: $description, price: $price, image: $image}';
  }
}