class User {
  int? id;
  int? role_id;
  String? username;
  String? password;
  String? phone_number;
  String? birthday;

  User({
    this.id,
    this.role_id,
    this.username,
    this.password,
    this.phone_number,
    this.birthday,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      role_id: json['role_id'],
      username: json['username'] ?? null,
      password: json['password'] ?? null,
      phone_number: json['phone_number'] ?? null,
      birthday: json['birthday'] ?? null
    );
  }

  @override
  String toString() {
    return 'User{id: $id, role_id: ${role_id}, name: $username, password: $password phone_number: $phone_number, birth: $birthday}';
  }
}