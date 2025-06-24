import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectflutter/domain/exercise/usecase/get_favorites.dart';
import 'package:projectflutter/presentation/exercise/bloc/favorites_state.dart';
import 'package:projectflutter/service_locator.dart';

class FavoritesCubit extends Cubit<FavoritesState>{
  FavoritesCubit() : super(FavoritesLoading());

  Future<void> listFavorite() async{
    final result = await sl<GetFavoritesUseCase>().call();
    result.fold((error){
      emit(LoadFavoritesFailure(errorMessage: error));
    }, (data){
        emit(FavoritesLoaded(entity: data ?? []));
    });
  }

}