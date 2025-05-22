abstract class ExerciseStartEvent {}
class StartCountdownEvent extends ExerciseStartEvent {}
class StartExerciseEvent extends ExerciseStartEvent {}
class PauseExerciseEvent extends ExerciseStartEvent {}
class ResumeExerciseEvent extends ExerciseStartEvent {}
class FinishExerciseEvent extends ExerciseStartEvent {}