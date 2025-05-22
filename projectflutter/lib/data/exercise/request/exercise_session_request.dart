class ExerciseSessionRequest {
  final int exerciseId;
  final int duration;
  final int resetBatch;

  ExerciseSessionRequest(
      {required this.exerciseId,
      required this.duration,
      required this.resetBatch});
}
