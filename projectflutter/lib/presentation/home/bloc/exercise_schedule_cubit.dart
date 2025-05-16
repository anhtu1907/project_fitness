import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectflutter/domain/exercise/entity/exercise_schedule_entity.dart';
import 'package:projectflutter/domain/exercise/usecase/get_exercise_schedule.dart';
import 'package:projectflutter/notification_service.dart';
import 'package:projectflutter/presentation/home/bloc/exercise_schedule_state.dart';
import 'package:projectflutter/service_locator.dart';

class ExerciseScheduleCubit extends Cubit<ExerciseScheduleState> {
  ExerciseScheduleCubit() : super(ExerciseScheduleLoading());

  List<ExerciseScheduleEntity> _allSchedule = [];
  void displaySchedule() async {
    final result = await sl<GetExerciseScheduleUseCase>().call();
    result.fold((err) {
      emit(LoadExerciseScheduleFailure(errorMessage: err));
    }, (data) async {
      _allSchedule = List<ExerciseScheduleEntity>.from(data)
        ..sort((a, b) {
          final aTime = a.scheduleTime;
          final bTime = b.scheduleTime;
          if (aTime == null && bTime == null) return 0;
          if (aTime == null) return 1;
          if (bTime == null) return -1;
          return bTime.compareTo(aTime);
        });

      for (var schedule in _allSchedule) {
        if (schedule.scheduleTime != null && schedule.subCategory != null) {
          try {
            await NotificationService.scheduleNotificationAt(
              schedule.scheduleTime!,
              schedule.subCategory!.id,
              title: schedule.subCategory!.subCategoryName,
              body: "It's time to work out, let's get started",
            );
          } catch (e) {
            print('Error scheduling notification: $e');
          }
        }
      }
      emit(ExerciseScheduleLoaded(entity: _allSchedule));
    });
  }
}
