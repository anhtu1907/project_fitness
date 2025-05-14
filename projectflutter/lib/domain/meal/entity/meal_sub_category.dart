import 'package:projectflutter/data/meal/model/meal_category.dart';

class MealSubCategoryEntity {
  final int id;
  final String subCategoryName;
  final String subCategoryImage;
  final String description;
  final MealCategoryModel? category;

  MealSubCategoryEntity(
      {required this.id,
      required this.subCategoryName,
      required this.subCategoryImage,
      required this.description,
      required this.category});
}
