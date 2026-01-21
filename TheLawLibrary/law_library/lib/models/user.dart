class User {
  final String username;
  final String password; // Encrypted password
  final bool isAdmin;

  User({
    required this.username,
    required this.password,
    this.isAdmin = false,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['Username'] ?? '',
      password: json['Password'] ?? '',
      isAdmin: json['isAdmin'] == 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Username': username,
      'Password': password,
      'isAdmin': isAdmin ? 1 : 0,
    };
  }
}