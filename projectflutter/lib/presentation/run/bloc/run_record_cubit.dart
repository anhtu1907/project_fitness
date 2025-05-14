import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectflutter/domain/run/usecase/get_record_run_by_user.dart';
import 'package:projectflutter/presentation/run/bloc/run_record_state.dart';
import 'package:projectflutter/service_locator.dart';

class RunRecordCubit extends Cubit<RunRecordState> {
  RunRecordCubit() : super(RunRecordLoading());

  void listRunByUserId() async {
    final result = await sl<GetRecordRunByUserUseCase>().call();
    result.fold((err) {
      emit(LoadRunRecordFailure(errorMessage: err));
    }, (data) {
      emit(RunRecordLoaded(listRun: data));
    });
  }
}
