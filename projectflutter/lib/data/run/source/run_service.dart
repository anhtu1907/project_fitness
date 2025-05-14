import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

abstract class RunService {
  Future<void> stratTracking();
  Future<void> stopTracking();
  Future<Either> getRecordRunByUserId();
}

class RunServiceImpl extends RunService {
  @override
  Future<void> stratTracking() {
    // TODO: implement stratTracking
    throw UnimplementedError();
  }

  @override
  Future<void> stopTracking() {
    // TODO: implement stopTracking
    throw UnimplementedError();
  }

  @override
  Future<Either> getRecordRunByUserId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('id');
      Uri url = Uri.parse("http://10.0.2.2:8080/api/run/record/$userId");
      final response = await http.get(url);
      if (response.statusCode == 404) {
        return const Left('No data to found');
      }
      List<dynamic> responseData = jsonDecode(response.body);
      return Right(responseData);
    } catch (err) {
      return Left('Error Message: $err');
    }
  }
}
