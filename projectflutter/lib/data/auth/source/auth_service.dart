import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:projectflutter/common/api/base_api.dart';
import 'package:projectflutter/common/api/shared_preference_service.dart';
import 'package:projectflutter/data/auth/request/register_request.dart';
import 'package:projectflutter/data/auth/request/signin_request.dart';
import 'package:http/http.dart' as http;
import 'package:projectflutter/data/bmi/model/bmi.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AuthService {
  Future<Either> signin(SigninRequest user);
  Future<Either> signup(RegisterRequest user);
  Future<Either> sendEmailResetPassword(String email);
  Future<Either> getUser();
  Future<bool> isLoggedIn();
  Future<Either> verfiy(String pinCode);
  Future<void> logout();
}

class AuthServiceImpl extends AuthService {
  @override
  Future<Either> signin(SigninRequest user) async {
    try {
      Uri url = Uri.parse("$baseAPI/api/auth/login");
      final response = await http
          .post(url,
              headers: {'Content-Type': 'application/json'},
              body:
                  json.encode({'email': user.email, 'password': user.password}))
          .timeout(Duration(seconds: 5), onTimeout: () {
        throw Exception('Timeout kết nối');
      });
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final prefs = await SharedPreferences.getInstance();
        final String token = responseData['token'];

        final int userId = responseData['id'];
        final String firstname = responseData['firstname'];
        if (responseData['bmiid'] != null) {
          final BmiModel bmi = BmiModel.fromMap(responseData['bmiid']);
          await prefs.setString('bmi_exist', bmi.toJson());
        } else {
          await prefs.remove('bmi_exist');
        }

        await prefs.setString('token', token);
        await prefs.setString('firstname', firstname);
        SharedPreferenceService.userId = userId;
        await Future.delayed(const Duration(milliseconds: 300));
        return const Right('Sign in was successfully');
      } else if (response.statusCode == 401) {
        return const Left('Email not found');
      } else if (response.statusCode == 400) {
        return const Left('Email or Password is wrong');
      } else {
        return Left('Server error: ${response.statusCode}');
      }
    } catch (err) {
      return Left('Error Message: $err');
    }
  }

  @override
  Future<Either> signup(RegisterRequest user) async {
    try {
      Uri url = Uri.parse('$baseAPI/api/auth/register');
      final response = await http.post(url,
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'firstname': user.firstname,
            'lastname': user.lastname,
            'email': user.email,
            'password': user.password,
            'dob': user.dob.toIso8601String(),
            'phone': user.phone,
            'gender': user.gender
          }));
      return Right(response.body);
    } catch (err) {
      return Left('Error Message: $err');
    }
  }

  @override
  Future<Either> sendEmailResetPassword(String email) {
    // TODO: implement sendEmailResetPassword
    throw UnimplementedError();
  }

  @override
  Future<Either> getUser() async {
    try {
      final userId = SharedPreferenceService.userId;
      Uri url = Uri.parse('$baseAPI/api/auth/getUser/$userId');
      final response = await http.get(url);
      if (response.statusCode == 404) {
        return const Left('User not found');
      }
      return Right(response.body);
    } catch (err) {
      return Left('Error Message: $err');
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    return token != null && token.isNotEmpty;
  }

  @override
  Future<Either> verfiy(String pinCode) {
    // TODO: implement verfiy
    throw UnimplementedError();
  }

  @override
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('userId');
    await prefs.remove('bmi_exist');
    await prefs.remove('bmi_latest');
  }
}
