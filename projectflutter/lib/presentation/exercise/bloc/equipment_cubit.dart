import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectflutter/domain/exercise/usecase/get_all_equipment.dart';
import 'package:projectflutter/presentation/exercise/bloc/equipment_state.dart';
import 'package:projectflutter/service_locator.dart';

class EquipmentCubit extends Cubit<EquipmentState> {
  EquipmentCubit() : super(EquipmentLoading());

  void listEquipment() async {
    var result = await sl<GetAllEquipmentUseCase>().call();

    result.fold((err) {
      emit(LoadEquipmentFailure(errorMessage: err));
    }, (data) {
      emit(EquipmentLoaded(entity: data));
    });
  }
}
