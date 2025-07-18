import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:projectflutter/common/api/base_api.dart';
import 'package:projectflutter/common/api/shared_preference_service.dart';
import 'package:projectflutter/common/api/token_request_helper.dart';
import 'package:projectflutter/data/exercise/request/exercise_favorite_request.dart';
import 'package:projectflutter/data/exercise/request/exercise_schedule_request.dart';
import 'package:projectflutter/data/exercise/request/exercise_session_batch_request.dart';
import 'package:projectflutter/data/exercise/request/exercise_session_request.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class ExerciseService {
  // Exercise
  Future<int?> getResetBatchBySubCategory(int subCategoryId);
  Future<Either> getExerciseBySubCategory(int subCategoryId);
  Future<Either> getExerciseById(int exerciseId);
  Future<Either> getAllSubCategory();
  Future<Either> startMultipleExercises(ExerciseSessionBatchRequest req);
  Future<Either> getAllExerciseProgressByUserId();
  Future<Either> getAllExerciseSessionByUserId();
  Future<Either> getAllExerciseResultByUserId();
  Future<Either> getAllExercise();
  Future<Either> getAllCategory();
  Future<Either> getAllExerciseScheduleByUserId();
  Future<Either> scheduleExercise(ExerciseScheduleRequest req);
  Future<void> deleteExerciseSchdedule(int scheduleId);
  Future<void> deleteAllExerciseScheduleByTime();
  // Favorite
  Future<Either> getAllFavorite();
  Future<Either> getAllExerciseFavorite(int favoriteId);
  Future<Either> addNewFavoriteByUserId(String favoriteName);
  Future<Either> addExerciseFavoriteByUserId(ExerciseFavoriteRequest req);
  Future<void> removeFavorite(int favoriteId);
  Future<void> removeExerciseFavorite(int subCategoryId);
  // SubCategory - Program
  Future<Either> getAllSubCategoryProgram();

  // Exercise Mode
  Future<Either> getAllExerciseMode();
  // Search
  Future<Either> searchBySubCategoryName(String subCategoryName);
// Equipment
  Future<Either> getAllEquipmentBySubCategoryId(int subCategoryId);
  Future<Either> getAllEquipment();
}

class ExerciseServiceImpl extends ExerciseService {
  // Exercises
  @override
  Future<int?> getResetBatchBySubCategory(int subCategoryId) async {
    try {
      final userId = SharedPreferenceService.userId;

      final response = await sendRequestWithAutoRefresh((token) {
        Uri url = Uri.parse(
            '$baseAPI/api/exercise/reset-batch?userId=$userId&subCategoryId=$subCategoryId');
        return http.get(
          url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );
      });
      if (response.statusCode == 200) {
        final batch = int.parse(response.body);

        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt("reset_batch_subCategory_$subCategoryId", batch);

        return batch;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<Either> getAllSubCategory() async {
    try {
      final response = await sendRequestWithAutoRefresh((token) {
        Uri url = Uri.parse("$baseAPI/api/exercise/category/sub");
        return http.get(
          url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );
      });

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
      final response = await sendRequestWithAutoRefresh((token) {
        Uri url =
            Uri.parse("$baseAPI/api/exercise/category/sub/$subCategoryId");
        return http.get(
          url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );
      });
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
      final response = await sendRequestWithAutoRefresh((token) {
        Uri url = Uri.parse("$baseAPI/api/exercise/$exerciseId");
        return http.get(
          url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );
      });
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
      final response = await sendRequestWithAutoRefresh((token) {
        Uri url = Uri.parse("$baseAPI/api/exercise");
        return http.get(
          url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );
      });
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
      final response = await sendRequestWithAutoRefresh((token) {
        Uri url = Uri.parse("$baseAPI/api/exercise/category");
        return http.get(
          url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );
      });
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
      final response = await sendRequestWithAutoRefresh((token) {
        Uri url = Uri.parse("$baseAPI/api/exercise/progress/$userId");
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
      final response = await sendRequestWithAutoRefresh((token) {
        Uri url = Uri.parse("$baseAPI/api/exercise/user/$userId");
        return http.get(
          url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );
      });
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
      final response = await sendRequestWithAutoRefresh((token) {
        Uri url = Uri.parse("$baseAPI/api/session/$userId");
        return http.get(
          url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );
      });
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
  Future<Either> startMultipleExercises(ExerciseSessionBatchRequest req) async {
    try {
      final response = await sendRequestWithAutoRefresh((token) {
        Uri url = Uri.parse("$baseAPI/api/exercise/start-session");
        return http.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: json.encode(req.toJson()),
        );
      });
      return Right(response.body);
    } catch (err) {
      return Left('Error Message: $err');
    }
  }

  @override
  Future<Either> getAllExerciseScheduleByUserId() async {
    try {
      final userId = SharedPreferenceService.userId;
      final response = await sendRequestWithAutoRefresh((token) {
        Uri url = Uri.parse("$baseAPI/api/exercise/schedule/$userId");
        return http.get(
          url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );
      });
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
      final response = await sendRequestWithAutoRefresh((token) {
        Uri url = Uri.parse("$baseAPI/api/exercise/schedule/save");
        return http.post(url,
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
            body: json.encode({
              'user': userId,
              'subCategory': req.subCategory,
              "scheduleTime": req.scheduleTime.toIso8601String()
            }));
      });
      return Right(response.body);
    } catch (err) {
      return Left('Error Message: $err');
    }
  }

  @override
  Future<void> deleteExerciseSchdedule(int scheduleId) async {
    final response = await sendRequestWithAutoRefresh((token) {
      Uri url = Uri.parse("$baseAPI/api/exercise/schedule/$scheduleId");
      return http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
    });
    if (response.statusCode == 204) {
      print("Record deleted successfully.");
    } else {
      print("Failed to delete record. Status code: ${response.statusCode}");
    }
  }

  @override
  Future<void> deleteAllExerciseScheduleByTime() async {
    final response = await sendRequestWithAutoRefresh((token) {
      Uri url = Uri.parse("$baseAPI/api/exercise/schedule/delete/time");
      return http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
    });
    if (response.statusCode == 204) {
      print("Record deleted successfully.");
    } else {
      print("Failed to delete record. Status code: ${response.statusCode}");
    }
  }

  // Favorite
  @override
  Future<Either> getAllFavorite() async {
    try {
      final userId = SharedPreferenceService.userId;
      final response = await sendRequestWithAutoRefresh((token) {
        Uri url = Uri.parse("$baseAPI/api/exercise/favorite/all/$userId");
        return http.get(
          url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );
      });
      List<dynamic> responseData = json.decode(response.body);
      List<String> favoriteIdList = responseData
          .map<String>((favorite) => (favorite['id'] as int).toString())
          .toList();
      SharedPreferenceService.favoriteIds = favoriteIdList;
      return Right(responseData);
    } catch (err) {
      return Left('Error: $err');
    }
  }

  @override
  Future<Either> getAllExerciseFavorite(int favoriteId) async {
    try {
      final userId = SharedPreferenceService.userId;
      final response = await sendRequestWithAutoRefresh((token) {
        Uri url = Uri.parse(
            "$baseAPI/api/exercise/favorite/exercise/all/$userId/$favoriteId");
        return http.get(
          url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );
      });
      List<dynamic> responseData = json.decode(response.body);
      return Right(responseData);
    } catch (err) {
      return Left('Error: $err');
    }
  }

  @override
  Future<Either> addNewFavoriteByUserId(String favoriteName) async {
    try {
      final userId = SharedPreferenceService.userId;
      final response = await sendRequestWithAutoRefresh((token) {
        Uri url = Uri.parse("$baseAPI/api/exercise/favorite/new/$userId");
        return http.post(url,
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
            body: favoriteName);
      });
      return Right(response.body);
    } catch (err) {
      return Left('Error: $err');
    }
  }

  @override
  Future<Either> addExerciseFavoriteByUserId(
      ExerciseFavoriteRequest req) async {
    try {
      final userId = SharedPreferenceService.userId;
      final response = await sendRequestWithAutoRefresh((token) {
        Uri url =
            Uri.parse("$baseAPI/api/exercise/favorite/add/exercise/$userId");
        return http.post(url,
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
            body: json.encode(
                {'subCategory': req.subCategory, 'favorite': req.favorite}));
      });
      return Right(response.body);
    } catch (err) {
      return Left('Error: $err');
    }
  }

  @override
  Future<void> removeFavorite(int favoriteId) async {
    final response = await sendRequestWithAutoRefresh((token) {
      Uri url = Uri.parse("$baseAPI/api/exercise/favorite/delete/$favoriteId");
      return http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
    });
    if (response.statusCode == 204) {
      print("Favorite deleted successfully.");
    } else {
      print("Failed to delete record. Status code: ${response.statusCode}");
    }
  }

  @override
  Future<void> removeExerciseFavorite(int subCategoryId) async {
    final response = await sendRequestWithAutoRefresh((token) {
      Uri url = Uri.parse(
          "$baseAPI/api/exercise/favorite/delete/exercise/$subCategoryId");
      return http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
    });
    if (response.statusCode == 204) {
      print("Exercise Favorite deleted successfully.");
    } else {
      print("Failed to delete record. Status code: ${response.statusCode}");
    }
  }

// SubCategory - Program
  @override
  Future<Either> getAllSubCategoryProgram() async {
    try {
      final response = await sendRequestWithAutoRefresh((token) {
        Uri url = Uri.parse("$baseAPI/api/exercise/sub/category/program");
        return http.get(
          url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );
      });
      if (response.statusCode == 404) {
        return const Left('No sub category program');
      }
      List<dynamic> responseData = jsonDecode(response.body);
      return Right(responseData);
    } catch (err) {
      return Left('Error Mesage: $err');
    }
  }

  // Exercise Mode
  @override
  Future<Either> getAllExerciseMode() async {
    try {
      final response = await sendRequestWithAutoRefresh((token) {
        Uri url = Uri.parse("$baseAPI/api/exercise/mode/all");
        return http.get(
          url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );
      });
      if (response.statusCode == 404) {
        return const Left('No exercise mode');
      }
      List<dynamic> responseData = jsonDecode(response.body);
      return Right(responseData);
    } catch (err) {
      return Left('Error Mesage: $err');
    }
  }

  @override
  Future<Either> searchBySubCategoryName(String subCategoryName) async {
    try {
      final response = await sendRequestWithAutoRefresh((token) {
        Uri url = Uri.parse(
            "$baseAPI/api/exercise/search?subCategoryName=$subCategoryName");
        return http.get(
          url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );
      });
      if (response.statusCode == 404) {
        return Left('No sub category by $subCategoryName');
      }
      List<dynamic> responseData = jsonDecode(response.body);
      return Right(responseData);
    } catch (err) {
      return Left('No Data : $err');
    }
  }

  // Equipments
  @override
  Future<Either> getAllEquipmentBySubCategoryId(int subCategoryId) async {
    try {
      final response = await sendRequestWithAutoRefresh((token) {
        Uri url = Uri.parse("$baseAPI/api/exercise/equipment/$subCategoryId");
        return http.get(
          url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );
      });
      List<dynamic> responseData = jsonDecode(response.body);
      return Right(responseData);
    } catch (err) {
      return Left('No Data : $err');
    }
  }

  @override
  Future<Either> getAllEquipment() async {
    try {
      final response = await sendRequestWithAutoRefresh((token) {
        Uri url = Uri.parse("$baseAPI/api/exercise/equipment/all");
        return http.get(
          url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );
      });
      List<dynamic> responseData = jsonDecode(response.body);
      return Right(responseData);
    } catch (err) {
      return Left('No Data : $err');
    }
  }
}
