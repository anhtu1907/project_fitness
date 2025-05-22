import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectflutter/presentation/bmi/bloc/show_bmi_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShowBmiCubit extends Cubit<ShowBmiState> {
  ShowBmiCubit() : super(BmiLoading());

  void displayBmi() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('bmi_latest');
    final data = json.decode(jsonString!);
    final double bmi = data['bmi']['bmi'];
    emit(BmiLoading());
    try {
      emit(BmiLoaded(bmi: bmi));
    } catch (err) {
      emit(LoadedBmiFailure(errorMessage: err.toString()));
    }
  }
}
