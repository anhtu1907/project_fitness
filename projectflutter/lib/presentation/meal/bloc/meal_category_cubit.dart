import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectflutter/domain/meal/usecase/get_all_category.dart';
import 'package:projectflutter/presentation/meal/bloc/meal_category_state.dart';
import 'package:projectflutter/service_locator.dart';

class CategoryCubit extends Cubit<CategoryState> {
  CategoryCubit() : super(CategoryLoading());

  Future<void> listCategory() async {
    final result = await sl<GetAllCategoryUseCase>().call();
    result.fold((err) {
      emit(LoadCategoryFailure(errorMessage: err));
    }, (data) {
      emit(CategoryLoaded(entity: data));
    });
  }
}
