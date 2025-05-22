import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:projectflutter/common/api/base_api.dart';
import 'package:projectflutter/common/api/shared_preference_service.dart';
import 'package:projectflutter/data/exercise/request/exercise_schedule_request.dart';
import 'package:projectflutter/data/exercise/request/exercise_session_request.dart';

abstract class ExerciseService {
  Future<Either> getExerciseBySubCategory(int subCategoryId);
  Future<Either> getExerciseById(int exerciseId);
  Future<Either> getAllSubCategory();
  Future<Either> startExercise(ExerciseSessionRequest req);
  Future<Either> getAllExerciseProgressByUserId();
  Future<Either> getAllExerciseSessionByUserId();
  Future<Either> getAllExerciseResultByUserId();
  Future<Either> getAllExercise();
  Future<Either> getAllCategory();
  Future<Either> getAllExerciseScheduleByUserId();
  Future<Either> scheduleExercise(ExerciseScheduleRequest req);
  Future<void> deleteExerciseSchdedule(int scheduleId);
  Future<void> deleteAllExerciseScheduleByTime();
}

class ExerciseServiceImpl extends ExerciseService {

  @override
  Future<Either> getAllSubCategory() async {
    try {
      Uri url = Uri.parse("$baseAPI/api/exercise/category/sub");
      final response = await http.get(url);
      if (response.statusCode == 404) {
        return const Left('Category not found');
      }

      List<dynamic> responseData = jsonDecode(response.body);
      return Right(responseData);
    } catch (err) {
      return Left('Error Message: $err');
    }
  }

  @override
  Future<Either> getExerciseBySubCategory(int subCategoryId) async {
    try {
      final Uri url =
          Uri.parse("$baseAPI/api/exercise/category/sub/$subCategoryId");
      final response = await http.get(url);
      if (response.statusCode == 404) {
        return const Left('Exercise by category not found');
      }

      List<dynamic> responseData = jsonDecode(response.body);
      return Right(responseData);
    } catch (err) {
      return Left('Error Message: $err');
    }
  }

  @override
  Future<Either> getExerciseById(int exerciseId) async {
    try {
      Uri url = Uri.parse("$baseAPI/api/exercise/$exerciseId");
      final response = await http.get(url);
      if (response.statusCode == 404) {
        return const Left('Exercise not found');
      }
      return Right(response.body);
    } catch (err) {
      return Left('Error Message: $err');
    }
  }

  // Progress Workout
  @override
  Future<Either> getAllExercise() async {
    try {
      Uri url = Uri.parse("$baseAPI/api/exercise");
      final response = await http.get(url);
      if (response.statusCode == 404) {
        return const Left('No data');
      }
      List<dynamic> responseData = jsonDecode(response.body);
      return Right(responseData);
    } catch (err) {
      return Left('Error Message: $err');
    }
  }

  @override
  Future<Either> getAllCategory() async {
    try {
      Uri url = Uri.parse("$baseAPI/api/exercise/category");
      final response = await http.get(url);
      if (response.statusCode == 404) {
        return const Left('No data');
      }
      List<dynamic> responseData = jsonDecode(response.body);
      return Right(responseData);
    } catch (err) {
      return Left('Error Message: $err');
    }
  }

  @override
  Future<Either> getAllExerciseProgressByUserId() async {
    try {
      final userId = SharedPreferenceService.userId;
      Uri url = Uri.parse("$baseAPI/api/exercise/progress/$userId");
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

  @override
  Future<Either> getAllExerciseResultByUserId() async {
    try {
      final userId = SharedPreferenceService.userId;
      Uri url = Uri.parse("$baseAPI/api/exercise/user/$userId");
      final response = await http.get(url);
      if (response.statusCode == 404) {
        return const Left('No result for user');
      }
      List<dynamic> responseData = jsonDecode(response.body);
      return Right(responseData);
    } catch (err) {
      return Left('Error Message: $err');
    }
  }

  @override
  Future<Either> getAllExerciseSessionByUserId() async {
    try {
      final userId = SharedPreferenceService.userId;
      Uri url = Uri.parse("$baseAPI/api/session/$userId");
      final response = await http.get(url);
      if (response.statusCode == 404) {
        return const Left('No session by user');
      }
      List<dynamic> responseData = jsonDecode(response.body);
      return Right(responseData);
    } catch (err) {
      return Left('Error Message: $err');
    }
  }

  @override
  Future<Either> startExercise(ExerciseSessionRequest req) async {
    try {
      final userId = SharedPreferenceService.userId;
      Uri url = Uri.parse("$baseAPI/api/exercise/start-session");
      final response = await http.post(url,
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'userId': userId,
            'exerciseId': req.exerciseId,
            "duration": req.duration,
            "resetBatch": req.resetBatch
          }));
      return Right(response.body);
    } catch (err) {
      return Left('Error Message: $err');
    }
  }

  @override
  Future<Either> getAllExerciseScheduleByUserId() async {
    try {
      final userId = SharedPreferenceService.userId;
      Uri url = Uri.parse("$baseAPI/api/exercise/schedule/$userId");
      final response = await http.get(url);
      if (response.statusCode == 404) {
        return const Left('No schedule by user');
      }
      List<dynamic> responseData = jsonDecode(response.body);
      return Right(responseData);
    } catch (err) {
      return Left('Error Mesage: $err');
    }
  }

  @override
  Future<Either> scheduleExercise(ExerciseScheduleRequest req) async {
    try {
      final userId = SharedPreferenceService.userId;
      Uri url = Uri.parse("$baseAPI/api/exercise/schedule/save");
      final response = await http.post(url,
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'user': userId,
            'subCategory': req.subCategory,
            "scheduleTime": req.scheduleTime.toIso8601String()
          }));
      return Right(response.body);
    } catch (err) {
      return Left('Error Message: $err');
    }
  }

  @override
  Future<void> deleteExerciseSchdedule(int scheduleId) async {
    Uri url = Uri.parse("$baseAPI/api/exercise/schedule/$scheduleId");
    final response = await http.delete(url);
    if (response.statusCode == 204) {
      print("Record deleted successfully.");
    } else {
      print("Failed to delete record. Status code: ${response.statusCode}");
    }
  }

  @override
  Future<void> deleteAllExerciseScheduleByTime() async {
    Uri url = Uri.parse("$baseAPI/api/exercise/schedule/detele/time");
    final response = await http.delete(url);
    if (response.statusCode == 204) {
      print("Record deleted successfully.");
    } else {
      print("Failed to delete record. Status code: ${response.statusCode}");
    }
  }
}
