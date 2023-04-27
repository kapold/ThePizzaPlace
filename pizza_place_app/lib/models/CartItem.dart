class CartItem {
  int? id;
  int? pizza_id;
  int? quantity;
  String? name;
  String? size;
  String? dough;
  String? cheese;
  double? price;
  String? image;

  CartItem({
    this.id,
    this.pizza_id,
    this.quantity,
    this.name,
    this.size,
    this.dough,
    this.cheese,
    this.price,
    this.image
  });

  @override
  String toString() {
    return 'CartItem(id: $id, pizza_id: $pizza_id, quantity: $quantity, '
        'name: $name, size: $size, dough: $dough, cheese: $cheese, '
        'price: $price, image: $image)';
  }
}