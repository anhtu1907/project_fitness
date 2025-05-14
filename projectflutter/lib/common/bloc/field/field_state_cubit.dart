import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectflutter/common/bloc/field/field_state.dart';

class FieldStateCubit extends Cubit<FieldState> {
  FieldStateCubit() : super(HideTextState());

  void toggleVisibility() {
    if (state is HideTextState) {
      emit(ShowTextState());
    } else {
      emit(HideTextState());
    }
  }
}
