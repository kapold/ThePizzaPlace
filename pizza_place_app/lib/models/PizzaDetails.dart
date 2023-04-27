class PizzaDetails {
  int? id;
  String? size;
  String? dough;
  double? cheese;

  PizzaDetails({
    required this.id,
    required this.size,
    required this.dough,
    required this.cheese
  });

  factory PizzaDetails.fromJson(Map<String, dynamic> json) {
    return PizzaDetails(
      id: json['id'],
      size: json['size'] ?? null,
      dough: json['dough'] ?? null,
      cheese: json['cheese'] ?? null,
    );
  }

  @override
  String toString() {
    return 'PizzaDetails{id: $id, name: $size, description: $dough, price: $cheese}';
  }
}