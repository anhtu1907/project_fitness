class RegisterRequest {
  final String username;
  final String firstname;
  final String lastname;
  final String email;
  final String password;
  final String address;
  final DateTime dob;
  final int gender;
  final String phone;

  RegisterRequest(
      {required this.username,
      required this.firstname,
      required this.lastname,
      required this.email,
      required this.password,
      required this.address,
      required this.dob,
      required this.gender,
      required this.phone});

  Map<String, dynamic> toJson() => {
    'username': username,
    'firstname': firstname,
    'lastname': lastname,
    'email': email,
    'password': password,
    'dob': dob.toIso8601String(),
    'address': address,
    'gender': gender,
    'phone': phone,
  };
}
