class User {
  final String id;
  final String userName;
  final String? firstName;
  final String lastName;
  final String email;
  final String role;

  User({
    required this.id,
    required this.userName,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.role,
  });

  User.fromJson(Map<String, dynamic> json)
      : this(
          role: json["role"] as String,
          id: json["_id"],
          userName: json["userName"] as String,
          email: json["email"] as String,
          firstName: json["firstName"] as String,
          lastName: json["lastName"] as String,
        );

  User.fromJson2(Map<String, dynamic> json)
      : this(
          role: " ",
          id: json["_id"],
          userName: json["userName"] as String,
          email: " ",
          firstName: " ",
          lastName: " ",
        );
}
