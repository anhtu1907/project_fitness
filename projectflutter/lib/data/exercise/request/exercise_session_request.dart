class ExerciseSessionRequest {
  final int exerciseId;
  final int duration;
  final int subCategoryId;
  final int resetBatch;

  ExerciseSessionRequest(
      {required this.exerciseId,
      required this.duration,
      required this.subCategoryId,
      required this.resetBatch});
  Map<String, dynamic> toJson() {
    return {
      'exerciseId': exerciseId,
      'duration': duration,
      'subCategoryId': subCategoryId,
      'resetBatch': resetBatch,
    };
  }
}
