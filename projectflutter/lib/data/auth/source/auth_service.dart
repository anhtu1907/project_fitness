import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:projectflutter/common/api/base_api.dart';
import 'package:projectflutter/common/api/shared_preference_service.dart';
import 'package:projectflutter/common/api/token_request_helper.dart';
import 'package:projectflutter/data/auth/model/user_simple_dto.dart';
import 'package:projectflutter/data/auth/request/register_request.dart';
import 'package:projectflutter/data/auth/request/signin_request.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

abstract class AuthService {
  Future<Either> signin(SigninRequest user);
  Future<Either> signup(RegisterRequest user);
  Future<Either> sendEmailResetPassword(String email);
  Future<Either> getUser();
  Future<bool> isLoggedIn();
  Future<void> logout();
  Future<Either> refreshToken();
  Future<Either> getByUsername();
  Future<Either> introspectToken();
  Future<bool> ensureValidToken();
}

class AuthServiceImpl extends AuthService {
  @override
  Future<Either> signin(SigninRequest user) async {
    try {
      Uri url = Uri.parse("$baseAPI/auth/login");
      final response = await http
          .post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'X-Device-Type': 'mobile',
        },
        body: json.encode({
          'username': user.username,
          'password': user.password,
        }),
      )
          .timeout(const Duration(seconds: 5), onTimeout: () {
        throw Exception('Timeout');
      });
      final Map<String, dynamic> body = json.decode(response.body);
      if (body['success'] == true) {
        final Map<String, dynamic> result = body['data'];
        final bool isAuthenticated = result['authenticated'] ?? false;

        if (isAuthenticated) {
          final prefs = await SharedPreferences.getInstance();
          final token = result['token'];
          final refreshToken = result['refreshToken'];
          await prefs.setString('token', token);
          await prefs.setString('refresh_token', refreshToken);
          await prefs.setString('username', user.username!);
          return Right(result);
        } else {
          return const Left('"Account is not verified');
        }
      } else {
        try {
          final errorMessage = body['errors']?['Exception'] ?? 'Unknown error';
          return Left(errorMessage);
        } catch (e) {
          return Left('Error parsing response: $e');
        }
      }

    } catch (err) {
      return Left('Exception: $err');
    }
  }

  @override
  Future<Either> signup(RegisterRequest user) async {
    try {
      Uri url = Uri.parse('$baseAPI/identity/user/create');
      final response = await http.post(url,
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'username': user.username,
            'firstName': user.firstname,
            'lastName': user.lastname,
            'email': user.email,
            'password': user.password,
            'dob': user.dob.toIso8601String().split('T').first,
            'phone': user.phone,
            'gender': user.gender,
            'address': user.address
          }));
      final Map<String, dynamic> body = json.decode(response.body);
      if ((response.statusCode == 200 || response.statusCode == 201) &&
          body['success'] == true) {
        final data = body['data'];
        return Right(UserSimpleDTO.fromMap({
          'id': data['id'],
          'firstName': data['firstName'],
          'lastName': data['lastName'],
        }));
      }
      final errors = body['errors'] as Map<String, dynamic>;
      final errorMessage = errors.entries.map((e) => '${e.value}').join('\n');
      return Left(errorMessage);
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
  Future<Either> getByUsername() async {
    final prefs = await SharedPreferences.getInstance();

    final username = prefs.getString('username');
    try {
      final response = await sendRequestWithAutoRefresh((token) {
        Uri url = Uri.parse('$baseAPI/identity/user/username/$username');
        return http.get(
          url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );
      });
      final body = json.decode(response.body);
      final result = body['data'];
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('firstname', result['firstName']);
      SharedPreferenceService.userId = result['id'];
      return Right(response.body);
    } catch (err) {
      return Left('Error Message: $err');
    }
  }

  @override
  Future<Either> getUser() async {
    final userId = SharedPreferenceService.userId;

    try {
      final response = await sendRequestWithAutoRefresh((token) {
        Uri url = Uri.parse('$baseAPI/identity/user/id/$userId');
        return http.get(
          url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );
      });

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
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    try {
      final refreshToken = prefs.getString('refresh_token');
      if (refreshToken != null) {
        await http.post(
          Uri.parse('$baseAPI/auth/logout'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({'refreshToken': refreshToken}),
        );
      }
    } catch (e) {
      print("API logout failed: $e");
    }
    await prefs.clear();
  }

  @override
  Future<Either> refreshToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final refreshToken = prefs.getString('refresh_token');
      if (refreshToken == null) {
        return const Left("No refresh token found");
      }

      final url = Uri.parse('$baseAPI/auth/refresh-token');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'refreshToken': refreshToken}),
      );

      if (response.statusCode == 200) {
        final body = json.decode(response.body);
        final result = body['data'];

        final newAccessToken = result['token'];
        final newRefreshToken = result['refreshToken'];

        SharedPreferenceService.token = newAccessToken;
        await prefs.setString('token', newAccessToken);
        if (newRefreshToken != null) {
          await prefs.setString('refresh_token', newRefreshToken);
        }

        return Right(newAccessToken);
      } else {
        return Left('Failed to refresh token: ${response.statusCode}');
      }
    } catch (e) {
      return Left('Exception: $e');
    }
  }

  @override
  Future<Either> introspectToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('token');

      if (accessToken == null || accessToken.isEmpty) {
        return const Left("Token not found");
      }

      Uri url = Uri.parse('$baseAPI/auth/introspect');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'token': accessToken}),
      );

      if (response.statusCode == 200) {
        final body = json.decode(response.body);
        final result = body['data'];
        return Right(result['valid'] == true);
      } else {
        return Left('Failed to introspect: ${response.statusCode}');
      }
    } catch (e) {
      return Left('Exception: $e');
    }
  }

  @override
  Future<bool> ensureValidToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null || token.isEmpty) {
      // await logout();
      return false;
    }
    SharedPreferenceService.token = token;
    final introspect = await introspectToken();
    if (introspect.isLeft() || introspect.getOrElse(() => false) == false) {
      final refresh = await refreshToken();
      return refresh.isRight();
    }

    return true;
  }
}
