class Address {
  int? id;
  int? user_id;
  String? address;

  Address({
    this.id,
    this.user_id,
    this.address
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
        id: json['id'],
        user_id: json['user_id'],
        address: json['address'] ?? null
    );
  }

  @override
  String toString() {
    return 'Address{id: $id, user_id: $user_id, address: $address}';
  }
}