import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectflutter/common/bloc/button/button_state.dart';
import 'package:projectflutter/core/usecase/usecase.dart';
import 'package:dartz/dartz.dart';

class ButtonStateCubit extends Cubit<ButtonState> {
  ButtonStateCubit() : super(ButtonInitialState());

  Future<void> execute({
    required UseCase usecase,
    dynamic params,
  }) async {
    if (state is! ButtonLoadingState) {
      emit(ButtonLoadingState());
    }
    try {
      Either returnedData = await usecase.call(params: params);
      returnedData.fold((err) {
        emit(ButtonFailureState(errorMessage: err));
      }, (data) {
        emit(ButtonSuccessState());
      });
    } catch (err) {
      emit(ButtonFailureState(errorMessage: err.toString()));
    }
  }
}
