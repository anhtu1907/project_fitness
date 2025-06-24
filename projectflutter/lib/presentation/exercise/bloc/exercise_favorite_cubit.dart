import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectflutter/domain/exercise/usecase/get_exercise_favorite.dart';
import 'package:projectflutter/presentation/exercise/bloc/exercise_favorite_state.dart';
import 'package:projectflutter/service_locator.dart';

class ExerciseFavoriteCubit extends Cubit<ExerciseFavoriteState>{
  ExerciseFavoriteCubit() : super(ExerciseFavoriteLoading());
  Future<void> listExerciseFavorite(int favoriteId) async{
    final result = await sl<GetExerciseFavoriteUseCase>().call(params: favoriteId);
    result.fold((error){
      emit(LoadExerciseFavoriteFailure(errorMessage: error));
    }, (data){
      emit(ExerciseFavoriteLoaded(entity: data ?? []));
    });
  }
}