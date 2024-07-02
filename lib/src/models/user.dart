class User {
  final String id;
  final String fname;
  final String lname;
  final String department;
  final String phonenumber;
  final String token;
  final String email;
  final String password;
  final String role;
  final String? resetPasswordToken; // Nullable field for reset token
  final DateTime? resetPasswordExpires; // Nullable field for token expiration

  User({
    required this.id,
    required this.fname,
    required this.lname,
    required this.department,
    required this.phonenumber,
    required this.token,
    required this.email,
    required this.password,
    required this.role,
    this.resetPasswordToken, // Initialize as null
    this.resetPasswordExpires, // Initialize as null
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] ?? '',
      fname: json['fname'] ?? '',
      lname: json['lname'] ?? '',
      department: json['department'] ?? '',
      phonenumber: json['phonenumber'] ?? '',
      token: json['token'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      role: json['role'] ?? '',
      resetPasswordToken: json['resetPasswordToken'], // Parse nullable field
      resetPasswordExpires: json['resetPasswordExpires'] != null
          ? DateTime.parse(json['resetPasswordExpires'])
          : null, // Parse nullable field
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fname': fname,
      'lname': lname,
      'department': department,
      'phonenumber': phonenumber,
      'token': token,
      'email': email,
      'password': password,
      'role': role,
      'resetPasswordToken': resetPasswordToken, // Include nullable field
      'resetPasswordExpires':
          resetPasswordExpires?.toIso8601String(), // Include nullable field
    };
  }
}
