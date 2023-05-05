import 'OrderItem.dart';

class Order {
  int? id;
  int? user_id;
  int? delivery_id;
  String? created_at;
  String? status;
  List<OrderItem>? items;

  Order({
    this.id,
    this.user_id,
    this.delivery_id,
    this.created_at,
    this.status,
    this.items
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      user_id: json['user_id'],
      delivery_id: json['delivery_id'],
      created_at: json['created_at'],
      status: json['status']
    );
  }

  @override
  String toString() {
    return 'Order{id: $id, user_id: $user_id, delivery_id: $delivery_id, created_at: $created_at, status: $status, items.count = ${items?.length}';
  }
}