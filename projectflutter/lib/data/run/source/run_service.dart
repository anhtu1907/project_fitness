import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:projectflutter/common/api/base_api.dart';
import 'package:projectflutter/common/api/shared_preference_service.dart';
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
      final userId = SharedPreferenceService.userId;
      Uri url = Uri.parse("$baseAPI/api/run/record/$userId");
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
