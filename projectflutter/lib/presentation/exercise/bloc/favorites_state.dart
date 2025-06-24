import 'package:projectflutter/domain/exercise/entity/favorites_entity.dart';

abstract class FavoritesState{}

class FavoritesLoading extends FavoritesState{}

class FavoritesLoaded extends FavoritesState{
  List<FavoritesEntity> entity;
  FavoritesLoaded({required this.entity});
}

class LoadFavoritesFailure extends FavoritesState{
  final String errorMessage;
  LoadFavoritesFailure({required this.errorMessage});
}