import 'dart:convert';

import 'package:projectflutter/data/auth/model/user.dart';
import 'package:projectflutter/data/auth/model/user_simple_dto.dart';
import 'package:projectflutter/domain/exercise/entity/favorites_entity.dart';

class FavoritesModel {
  final int id;
  final String favoriteName;
  final UserSimpleDTO? user;

  const FavoritesModel(
      {required this.id, required this.favoriteName, required this.user});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'favoriteName': favoriteName,
      'user': user
    };
  }

  factory FavoritesModel.fromMap(Map<String, dynamic> map) {
    return FavoritesModel(
        id: map['id'] as int,
        favoriteName: map['favoriteName'] as String,
        user: map['user'] != null
            ? UserSimpleDTO.fromMap(map['user'] as Map<String, dynamic>)
            : null);
  }

  String toJson() => json.encode(toMap());

  factory FavoritesModel.fromJson(String source) =>
      FavoritesModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

extension FavoriteXModel on FavoritesModel{
  FavoritesEntity toEntity() {
    return FavoritesEntity(id: id, favoriteName: favoriteName, user: user);
  }
}
