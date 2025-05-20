import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:projectflutter/common/api/base_api.dart';
import 'package:projectflutter/data/bmi/model/bmi_request.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

abstract class BmiService {
  Future<Either> saveData(BmiRequest model);
  Future<bool> checkBmi();
}

class BmiServiceImpl extends BmiService {
  @override
  Future<Either> saveData(BmiRequest model) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('id');
      Uri url = Uri.parse('$baseAPI/api/bmi/save/$userId');
      final response = await http.post(url,
          headers: {'Content-Type': 'application/json'},
          body: json.encode({'height': model.height, 'weight': model.weight}));
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
  Future<bool> checkBmi() async {
    final prefs = await SharedPreferences.getInstance();
    final bmiExist = prefs.getString('bmi_exist');
    final bmiLatest = prefs.getString('bmi_latest');
    return (bmiExist != null && bmiExist.isNotEmpty) ||
        (bmiLatest != null && bmiLatest.isNotEmpty);
  }
}
