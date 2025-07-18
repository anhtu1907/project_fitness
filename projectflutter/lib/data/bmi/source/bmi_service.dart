import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:projectflutter/common/api/base_api.dart';
import 'package:projectflutter/common/api/shared_preference_service.dart';
import 'package:projectflutter/common/api/token_request_helper.dart';
import 'package:projectflutter/data/bmi/request/bmi_request.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

abstract class BmiService {
  Future<Either> saveData(BmiRequest model);
  Future<Either> updateData(double weight);
  Future<Either> saveGoal(double targetWeight);
  Future<Either> updateGoal(double targetWeight);
  Future<Either> getAllDataByUserId();
  Future<Either> getAllGoalByUserId();
  Future<bool> checkBmi();
  Future<bool> checkBmiGoal();
}

class BmiServiceImpl extends BmiService {
  @override
  Future<Either> getAllDataByUserId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = SharedPreferenceService.userId;
      final token = prefs.getString('token');
      SharedPreferenceService.token = token ?? "";
      final response = await sendRequestWithAutoRefresh((token) {
        Uri url = Uri.parse("$baseAPI/api/bmi/health/$userId");
        return http.get(
          url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );
      });

      if (response.statusCode == 404) {
        return const Left('No data to found');
      }
      prefs.setString("bmi_exist", response.body);
      List<dynamic> responseData = jsonDecode(response.body);
      return Right(responseData);
    } catch (err) {
      return Left('Error Message: $err');
    }
  }

  @override
  Future<Either> getAllGoalByUserId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = SharedPreferenceService.userId;
      final response = await sendRequestWithAutoRefresh((token) {
        Uri url = Uri.parse("$baseAPI/api/bmi/goal/$userId");
        return http.get(
          url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );
      });
      if (response.statusCode == 404) {
        return const Left('No data to found');
      }
      prefs.setString("goal_exist", response.body);
      List<dynamic> responseData = jsonDecode(response.body);

      return Right(responseData);
    } catch (err) {
      return Left('Error Message: $err');
    }
  }

  @override
  Future<Either> saveData(BmiRequest model) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = SharedPreferenceService.userId;
      final response = await sendRequestWithAutoRefresh((token) {
        Uri url = Uri.parse('$baseAPI/api/bmi/save/$userId');
        return http.post(url,
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
            body:
                json.encode({'height': model.height, 'weight': model.weight}));
      });
      if (response.statusCode == 201) {
        await prefs.setString('bmi_latest', response.body);
        return Right(response.body);
      } else {
        return Left('Save BMI failed with code ${response.statusCode}');
      }
    } catch (err) {
      return Left('Error Message: $err');
    }
  }

  @override
  Future<Either> updateData(double weight) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = SharedPreferenceService.userId;
      final response = await sendRequestWithAutoRefresh((token) {
        Uri url = Uri.parse('$baseAPI/api/bmi/update/$userId');
        return http.post(url,
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
            body: json.encode({'targetWeight': weight}));
      });
      if (response.statusCode == 201) {
        await prefs.setString('bmi_latest', response.body);
        return Right(response.body);
      } else {
        return Left('Save BMI failed with code ${response.statusCode}');
      }
    } catch (err) {
      return Left('Error Message: $err');
    }
  }

  @override
  Future<Either> saveGoal(double targetWeight) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = SharedPreferenceService.userId;
      final response = await sendRequestWithAutoRefresh((token) {
        Uri url = Uri.parse('$baseAPI/api/bmi/goal/save/$userId');
        return http.post(url,
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
            body: json.encode({'targetWeight': targetWeight}));
      });
      if (response.statusCode == 201 && response.body.isNotEmpty) {
        await prefs.setString('goal_latest', response.body);
        return Right(response.body);
      } else {
        return Left('Save BMI Goal failed with code ${response.statusCode}');
      }
    } catch (err) {
      return Left('Error Message: $err');
    }
  }

  @override
  Future<Either> updateGoal(double targetWeight) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = SharedPreferenceService.userId;
      final response = await sendRequestWithAutoRefresh((token) {
        Uri url = Uri.parse('$baseAPI/api/bmi/goal/update/$userId');
        return http.post(url,
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
            body: json.encode({'targetWeight': targetWeight}));
      });

      if (response.statusCode == 201) {
        await prefs.setString('goal_latest', response.body);
        return Right(response.body);
      } else {
        return Left('Save BMI Goal failed with code ${response.statusCode}');
      }
    } catch (err) {
      return Left('Error Message: $err');
    }
  }

  @override
  Future<bool> checkBmi() async {
    final prefs = await SharedPreferences.getInstance();
    final bmiExist = prefs.getString('bmi_exist');
    final bmiLatest = prefs.getString('bmi_latest');

    return (bmiExist != null && bmiExist.isNotEmpty) ||
        (bmiLatest != null && bmiLatest.isNotEmpty);
  }

  @override
  Future<bool> checkBmiGoal() async {
    final prefs = await SharedPreferences.getInstance();
    final bmiGoalExist = prefs.getString('goal_exist');
    final bmiGoalLatest = prefs.getString('goal_latest');
    return (bmiGoalExist != null && bmiGoalExist.isNotEmpty) ||
        (bmiGoalLatest != null && bmiGoalLatest.isNotEmpty);
  }
}
