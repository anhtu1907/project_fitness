import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectflutter/domain/bmi/usecase/get_all_data_by_user.dart';
import 'package:projectflutter/presentation/bmi/bloc/health_state.dart';
import 'package:projectflutter/service_locator.dart';

class HealthCubit extends Cubit<HealthState>{
  HealthCubit() : super(HealthLoading());

  void getDataHealth() async{
    emit(HealthLoading());
      final result = await sl<GetAllDataByUserUseCase>().call();
      result.fold((err){
        emit(LoadedHealthFailure(errorMessage: err));
      }, (data){
        emit(HealthLoaded(bmi: data));
      });
  }
}