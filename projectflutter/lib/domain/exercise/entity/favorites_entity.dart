import 'package:projectflutter/data/auth/model/user.dart';

class FavoritesEntity {
  final int id;
  final String favoriteName;
  final UserModel? user;

  const FavoritesEntity(
      {required this.id, required this.favoriteName, required this.user});
}
