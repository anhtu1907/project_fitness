import 'package:dartz/dartz.dart';
import 'package:projectflutter/data/meal/model/meal_category.dart';
import 'package:projectflutter/data/meal/model/meal_sub_category.dart';
import 'package:projectflutter/data/meal/model/meals.dart';
import 'package:projectflutter/data/meal/model/user_meal_record.dart';
import 'package:projectflutter/data/meal/request/user_meal_request.dart';
import 'package:projectflutter/data/meal/source/meal_service.dart';
import 'package:projectflutter/domain/meal/entity/meal_category.dart';
import 'package:projectflutter/domain/meal/entity/meal_sub_category.dart';
import 'package:projectflutter/domain/meal/entity/meals.dart';
import 'package:projectflutter/domain/meal/entity/user_meals.dart';
import 'package:projectflutter/domain/meal/repository/meal_repository.dart';
import 'package:projectflutter/service_locator.dart';

class MealRepositoryImpl extends MealRepository {
  @override
  Future<Either> getAllMeal() async {
    var meals = await sl<MealService>().getAllMeal();
    return meals.fold((err) {
      return Left(err);
    }, (data) {
      List<MealsModel> models =
          (data as List).map((e) => MealsModel.fromMap(e)).toList();
      List<MealsEntity> entities = models.map((m) => m.toEntity()).toList();

      return Right(entities);
    });
  }

  @override
  Future<Either> getAllCategory() async {
    var category = await sl<MealService>().getAllCategory();
    return category.fold((err) {
      return Left(err);
    }, (data) {
      List<MealCategoryModel> models = (data
              as List) // Ép kiểu tường minh để dart biết rằng data là List trước khi run time
          .map((e) => MealCategoryModel.fromMap(e))
          .toList(); //data là một List<dynamic>, trong đó mỗi e là một Map<String, dynamic> đại diện cho 1 category.
      //Dùng MealCategoryModel.fromMap(e) để chuyển từng Map thành model (MealCategoryModel).
      List<MealCategoryEntity> entities =
          models.map((m) => m.toEntity()).toList(); // Ánh xạ tới entity

      return Right(entities);
    });
  }

  @override
  Future<Either> getMealBySubCategory(int subCategoryId) async {
    var mealByCategory =
        await sl<MealService>().getMealBySubCategory(subCategoryId);
    return mealByCategory.fold((err) {
      return Left(err);
    }, (data) {
      List<MealsModel> models =
          (data as List).map((e) => MealsModel.fromMap(e)).toList();
      List<MealsEntity> entities = models.map((m) => m.toEntity()).toList();

      return Right(entities);
    });
  }

  @override
  Future<Either> getMealById(int mealId) async {
    var mealById = await sl<MealService>().getMealById(mealId);
    return mealById.fold((err) {
      return Left(err);
    }, (data) {
      return Right(MealsModel.fromJson(data).toEntity());
    });
  }

  @override
  Future<Either> getAllRecordMeal() async {
    var userMeal = await sl<MealService>().getAllRecordMeal();
    return userMeal.fold((err) {
      return Left(err);
    }, (data) {
      List<UserMealRecord> models =
          (data as List).map((e) => UserMealRecord.fromMap(e)).toList();
      List<UserMealsEntity> entities = models.map((m) => m.toEntity()).toList();

      return Right(entities);
    });
  }

  @override
  Future<Either> saveRecordMeal(UserMealRequest req) async {
    return await sl<MealService>().saveRecordMeal(req);
  }

  @override
  Future<void> deteleRecordMeal(int recordId) async {
    return await sl<MealService>().deteleRecordMeal(recordId);
  }

  @override
  Future<void> deteleAllRecordMeal(DateTime targetDate) async {
    return await sl<MealService>().deteleAllRecordMeal(targetDate);
  }

  @override
  Future<Either> searchByMealName(String mealName) async {
    var meals = await sl<MealService>().searchByMealName(mealName);
    return meals.fold((err) {
      return Left(err);
    }, (data) {
      List<MealsModel> models =
          (data as List).map((e) => MealsModel.fromMap(e)).toList();
      List<MealsEntity> entities = models.map((m) => m.toEntity()).toList();

      return Right(entities);
    });
  }

  @override
  Future<Either> getAllSubCategory() async {
    var subCategory = await sl<MealService>().getAllSubCategory();
    return subCategory.fold((err) {
      return Left(err);
    }, (data) {
      List<MealSubCategoryModel> models =
          (data as List).map((e) => MealSubCategoryModel.fromMap(e)).toList();
      List<MealSubCategoryEntity> entities =
          models.map((m) => m.toEntity()).toList();

      return Right(entities);
    });
  }
}
