import 'package:projectflutter/data/auth/model/user_simple_dto.dart';

class FavoritesEntity {
  final int id;
  final String favoriteName;
  final UserSimpleDTO? user;

  const FavoritesEntity(
      {required this.id, required this.favoriteName, required this.user});
}
