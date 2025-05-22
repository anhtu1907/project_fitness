import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectflutter/presentation/exercise/bloc/exercise_start_event.dart';
import 'package:projectflutter/presentation/exercise/bloc/exercise_start_state.dart';

class ExerciseStartBloc extends Bloc<ExerciseStartEvent, ExerciseStartState> {
  ExerciseStartBloc() : super(CountdownState(5));
}
