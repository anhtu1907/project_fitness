class RegisterRequest {
  final String firstname;
  final String lastname;
  final String email;
  final String password;
  final DateTime dob;
  final int gender;
  final String phone;

  RegisterRequest(
      {required this.firstname,
      required this.lastname,
      required this.email,
      required this.password,
      required this.dob,
      required this.gender,
      required this.phone});
}
