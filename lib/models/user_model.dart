class User {
  final int? id;
  final String fullName;
  final String email;
  final String password;

  User({
    this.id,
    required this.fullName,
    required this.email,
    required this.password,
  });

  // Convert a User into a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'password': password,
    };
  }

  // Create a User from a Map
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      fullName: map['fullName'],
      email: map['email'],
      password: map['password'],
    );
  }
}
