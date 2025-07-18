 import 'dart:convert';

class UserSimpleDTO {
  final String id;
  final String firstName;
  final String lastName;

  const UserSimpleDTO({
    required this.id,
    required this.firstName,
    required this.lastName
 });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
    };
  }

  factory UserSimpleDTO.fromMap(Map<String, dynamic> map) {
    return UserSimpleDTO(
      id: map['id'] as String,
      firstName: map['firstName'] as String? ?? '',
      lastName: map['lastName'] as String? ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory UserSimpleDTO.fromJson(String source) =>
      UserSimpleDTO.fromMap(json.decode(source));
}
