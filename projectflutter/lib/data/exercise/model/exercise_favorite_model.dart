import 'dart:convert';

import 'package:projectflutter/data/auth/model/user_simple_dto.dart';
import 'package:projectflutter/data/exercise/model/exercise_sub_category_model.dart';
import 'package:projectflutter/data/exercise/model/favorites_model.dart';
import 'package:projectflutter/domain/exercise/entity/exercise_favorite_entity.dart';

class ExerciseFavoriteModel {
  final int id;
  final FavoritesModel? favorite;
  final ExerciseSubCategoryModel? subCategory;
  final UserSimpleDTO? user;

  const ExerciseFavoriteModel({
    required this.id,
    required this.favorite,
    required this.subCategory,
    required this.user,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'favorite': favorite,
      'subCategory': subCategory,
      'user': user,
    };
  }

  factory ExerciseFavoriteModel.fromMap(Map<String, dynamic> map) {
    return ExerciseFavoriteModel(
        id: map['id'] as int,
        favorite: map['favorite'] != null
            ? FavoritesModel.fromMap(map['favorite'] as Map<String, dynamic>)
            : null,
        subCategory: map['subCategory'] != null
            ? ExerciseSubCategoryModel.fromMap(map['subCategory'] as Map<String, dynamic>)
            : null,
        user: map['user'] != null
            ? UserSimpleDTO.fromMap(map['user'] as Map<String, dynamic>)
            : null);
  }
  String toJson() => json.encode(toMap());

  factory ExerciseFavoriteModel.fromJson(String source) =>
      ExerciseFavoriteModel.fromMap(
          json.decode(source) as Map<String, dynamic>);
}

extension ExerciseFavoriteXModel on ExerciseFavoriteModel {
  ExerciseFavoriteEntity toEntity() {
    return ExerciseFavoriteEntity(
        id: id, favorite: favorite, subCategory: subCategory, user: user);
  }
}
