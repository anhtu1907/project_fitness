import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectflutter/presentation/run/bloc/button_run_state.dart';

class ButtonRunCubit extends Cubit<ButtonRunState> {
  ButtonRunCubit() : super(ButtonInitialize());

  void startTracking() {
    emit(StopTrackingButton());
  }

  void stopTracking() {
    emit(StartTrackingButton());
  }
}
