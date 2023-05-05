class OrderItem {
  int? id;
  int? order_id;
  int? product_id;
  int? pizza_details_id;
  int? quantity;

  OrderItem({
    this.id,
    this.order_id,
    this.product_id,
    this.pizza_details_id,
    this.quantity
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'],
      order_id: json['order_id'],
      product_id: json['product_id'],
      pizza_details_id: json['pizza_details_id'],
      quantity: json['quantity']
    );
  }

  @override
  String toString() {
    return 'OrderItem{id: $id, order_id: $order_id, product_id: $product_id, pizza_details_id: $pizza_details_id}';
  }
}