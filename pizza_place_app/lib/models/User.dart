class User {
  int? id;
  String? username;
  String? password;
  String? phoneNumber;
  DateTime? birthday;

  User({
    this.id,
    this.username,
    this.password,
    this.phoneNumber,
    this.birthday,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'] ?? null,
      password: json['password'] ?? null,
      phoneNumber: json['phone_number'] ?? null,
      birthday: json['birthday'] != null ? DateTime.parse(json['birthday']) : null,
    );
  }

  @override
  String toString() {
    return 'User{id: $id, name: $username, password: $password phoneNumber: $phoneNumber, birth: $birthday}';
  }
}