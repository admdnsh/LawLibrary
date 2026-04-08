class User {
  final String username;
  final String password; // Encrypted password
  final bool isAdmin;
  final String role; // 'admin' or 'officer'
  final String? createdAt;

  User({
    required this.username,
    required this.password,
    this.isAdmin = false,
    this.role = 'officer',
    this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    final role = (json['Role'] ?? json['role'] ?? 'officer') as String;
    return User(
      username: json['Username'] ?? '',
      password: json['Password'] ?? '',
      isAdmin: json['isAdmin'] == 1 || role == 'admin',
      role: role,
      createdAt: json['CreatedAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Username': username,
      'Password': password,
      'isAdmin': isAdmin ? 1 : 0,
      'role': role,
    };
  }
}