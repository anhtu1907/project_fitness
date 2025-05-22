abstract class ExerciseStartState {}

class CountdownState extends ExerciseStartState {
  final int secondsRemaining;
  CountdownState(this.secondsRemaining);
}
