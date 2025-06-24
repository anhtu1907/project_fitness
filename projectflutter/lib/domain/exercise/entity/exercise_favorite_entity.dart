import 'package:projectflutter/data/auth/model/user.dart';
import 'package:projectflutter/data/exercise/model/exercise_sub_category_model.dart';
import 'package:projectflutter/data/exercise/model/favorites_model.dart';

class ExerciseFavoriteEntity {
  final int id;
  final FavoritesModel? favorite;
  final ExerciseSubCategoryModel? subCategory;
  final UserModel? user;

  const ExerciseFavoriteEntity(
      {required this.id,
      required this.favorite,
      required this.subCategory,
      required this.user});
}
