class User {
  int id;
  String username;
  String password;
  String phoneNumber;
  DateTime birthday;

  User({
    required this.id,
    required this.username,
    required this.password,
    required this.phoneNumber,
    required this.birthday,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'] ?? '',
      password: json['password'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
      birthday: DateTime.parse(json['birthday']),
    );
  }

  @override
  String toString() {
    return 'User{id: $id, name: $username, password: $password phoneNumber: $phoneNumber, birth: $birthday}';
  }
}