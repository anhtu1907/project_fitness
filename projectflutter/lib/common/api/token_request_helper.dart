
import 'package:http/http.dart' as http;
import 'package:projectflutter/data/auth/source/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<http.Response> sendRequestWithAutoRefresh(
    Future<http.Response> Function(String token) requestFn,
    ) async {
  final prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('token');

  if (token == null || token.isEmpty) {
    throw Exception('No token available');
  }

  http.Response response = await requestFn(token);

  if (response.statusCode == 401) {
    final refreshed = await AuthServiceImpl().refreshToken();
    if (refreshed.isRight()) {
      token = refreshed.getOrElse(() => "");
      response = await requestFn(token!); // Retry
    }
  }

  return response;
}