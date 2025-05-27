import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectflutter/domain/bmi/usecase/get_all_goal_by_user.dart';
import 'package:projectflutter/presentation/bmi/bloc/health_goal_state.dart';
import 'package:projectflutter/service_locator.dart';
class HealthGoalCubit extends Cubit<HealthGoalState>{
  HealthGoalCubit() : super(HealthGoalLoading());

  void getHealGoal() async{
    final result = await sl<GetAllGoalByUserUseCase>().call();
    result.fold((err){
      emit(LoadedHealthGoalFailure(errorMessage: err));
    }, (data){
      emit(HealthGoalLoaded(goal: data));
    });
  }
}