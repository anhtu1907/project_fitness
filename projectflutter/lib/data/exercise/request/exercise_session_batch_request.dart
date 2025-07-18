import 'package:projectflutter/data/exercise/request/exercise_session_request.dart';

class ExerciseSessionBatchRequest {
  final String userId;
  final int subCategoryId;
  final int resetBatch;
  final List<ExerciseSessionRequest> sessions;

  ExerciseSessionBatchRequest({
    required this.userId,
    required this.subCategoryId,
    required this.resetBatch,
    required this.sessions,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'subCategoryId': subCategoryId,
      'resetBatch': resetBatch,
      'sessions': sessions.map((e) => e.toJson()).toList(),
    };
  }
}