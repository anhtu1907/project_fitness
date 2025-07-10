import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectflutter/domain/exercise/usecase/get_all_equipment.dart';
import 'package:projectflutter/domain/exercise/usecase/get_equipment_by_sub_id.dart';
import 'package:projectflutter/domain/exercise/usecase/get_exercise_equipment.dart';
import 'package:projectflutter/presentation/exercise/bloc/exercise_equipment_state.dart';
import 'package:projectflutter/service_locator.dart';

class ExerciseEquipmentCubit extends Cubit<ExerciseEquipmentState>{
  ExerciseEquipmentCubit() : super(ExerciseEquipmentLoading());
  Future<void> listAllEquipmentBySubId(int subCategoryId) async{
    final result = await sl<GetEquipmentBySubIdUseCase>().call(params: subCategoryId);
    result.fold((error){
      emit(LoadExerciseEquipmentFailure(errorMessage: error));
    }, (data){
      emit(ExerciseEquipmentLoaded(entity: data ?? []));
    });
  }

  Future<void> listExerciseEquipment() async{
    final result = await sl<GetAllEquipmentUseCase>().call();
    result.fold((error){
      emit(LoadExerciseEquipmentFailure(errorMessage: error));
    }, (data){
      emit(ExerciseEquipmentLoaded(entity: data ?? []));
    });
  }
}