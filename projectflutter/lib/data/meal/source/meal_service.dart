import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:projectflutter/common/api/base_api.dart';
import 'package:projectflutter/common/api/shared_preference_service.dart';
import 'package:projectflutter/common/api/token_request_helper.dart';
import 'package:projectflutter/data/meal/request/user_meal_request.dart';

abstract class MealService {
  Future<Either> getAllMeal();
  Future<Either> getAllCategory();
  Future<Either> getAllSubCategory();
  Future<Either> getAllRecordMeal();
  Future<Either> getMealBySubCategory(int subCategoryId);
  Future<Either> getMealById(int mealId);
  Future<Either> saveRecordMeal(UserMealRequest req);
  Future<void> deteleRecordMeal(int recordId);
  Future<void> deteleAllRecordMeal(DateTime targetDate);
  Future<Either> searchByMealName(String mealName);
}

class MealServiceImpl extends MealService {
  @override
  Future<Either> getAllCategory() async {
    try {
      final response = await sendRequestWithAutoRefresh((token) {
        Uri url = Uri.parse("$baseAPI/api/meal/category");
        return http.get(
          url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );
      });
      if (response.statusCode == 404) {
        return const Left(
          'Category not found',
        );
      }
      List<dynamic> responseData =
          jsonDecode(response.body); // Decode thành List
      return Right(responseData); // Return về List
    } catch (err) {
      return Left('Error Message: $err');
    }
  }

  @override
  Future<Either> getAllMeal() async {
    try {
      final response = await sendRequestWithAutoRefresh((token) {
        Uri url = Uri.parse("$baseAPI/api/meal");
        return http.get(
          url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );
      });
      if (response.statusCode == 404) {
        return const Left('Meals not found');
      }
      List<dynamic> responseData = jsonDecode(response.body);
      return Right(responseData);
    } catch (err) {
      return Left('Error Message: $err');
    }
  }

  @override
  Future<Either> getAllSubCategory() async {
    try {
      final response = await sendRequestWithAutoRefresh((token) {
        Uri url = Uri.parse("$baseAPI/api/meal/category/sub");
        return http.get(
          url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );
      });
      if (response.statusCode == 404) {
        return const Left('Sub Category not found');
      }
      List<dynamic> responseData = jsonDecode(response.body);
      return Right(responseData);
    } catch (err) {
      return Left('Error Message: $err');
    }
  }

  @override
  Future<Either> getMealBySubCategory(int subCategoryId) async {
    try {
      final response = await sendRequestWithAutoRefresh((token) {
        Uri url = Uri.parse("$baseAPI/api/meal/category/sub/$subCategoryId");
        return http.get(
          url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );
      });
      if (response.statusCode == 404) {
        return const Left('Meal by category not found');
      }
      List<dynamic> responseData = jsonDecode(response.body);
      return Right(responseData);
    } catch (err) {
      return Left('Error Message: $err');
    }
  }

  @override
  Future<Either> getMealById(int mealId) async {
    try {
      final response = await sendRequestWithAutoRefresh((token) {
        Uri url = Uri.parse("$baseAPI/api/meal/$mealId");
        return http.get(
          url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );
      });
      if (response.statusCode == 404) {
        return const Left('Meal not found');
      }
      return Right(response.body);
    } catch (err) {
      return Left('Error Message: $err');
    }
  }

  @override
  Future<Either> getAllRecordMeal() async {
    try {
      final userId = SharedPreferenceService.userId;
      final response = await sendRequestWithAutoRefresh((token) {
        Uri url = Uri.parse("$baseAPI/api/meal/record/$userId");
        return http.get(
          url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );
      });
      if (response.statusCode == 404) {
        return const Left('No record for user');
      }
      List<dynamic> responseData = jsonDecode(response.body);

      return Right(responseData);
    } catch (err) {
      return const Left('No Data');
    }
  }

  @override
  Future<Either> saveRecordMeal(UserMealRequest req) async {
    try {
      final userId = SharedPreferenceService.userId;
      final response = await sendRequestWithAutoRefresh((token) {
        Uri url = Uri.parse("$baseAPI/api/meal/save/record");
        return http.post(url,
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
            body: json.encode({
              'user': userId,
              'meal': req.meal,
              'created': req.created.toIso8601String()
            }));
      });
      return Right(response.body);
    } catch (err) {
      return Left('Error Message: $err');
    }
  }

  @override
  Future<void> deteleRecordMeal(int recordId) async {
    final response = await sendRequestWithAutoRefresh((token) {
      Uri url = Uri.parse("$baseAPI/api/meal/record/$recordId");
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
  Future<void> deteleAllRecordMeal(DateTime targetDate) async {
    final userId = SharedPreferenceService.userId;
    final formattedDate = targetDate.toIso8601String().split('T').first;
    final response = await sendRequestWithAutoRefresh((token) {
      Uri url =
          Uri.parse("$baseAPI/api/meal/record/$userId/all/$formattedDate");
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
  Future<Either> searchByMealName(String mealName) async {
    try {
      final response = await sendRequestWithAutoRefresh((token) {
        Uri url = Uri.parse("$baseAPI/api/meal/search?mealName=$mealName");
        return http.get(
          url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );
      });
      if (response.statusCode == 404) {
        return Left('No meal by $mealName');
      }
      List<dynamic> responseData = jsonDecode(response.body);
      return Right(responseData);
    } catch (err) {
      return Left('No Data : $err');
    }
  }
}
