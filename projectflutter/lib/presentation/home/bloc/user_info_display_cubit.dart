import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectflutter/domain/auth/usecase/get_user_usecase.dart';
import 'package:projectflutter/domain/auth/usecase/logout_usecase.dart';
import 'package:projectflutter/presentation/home/bloc/user_info_display_state.dart';
import 'package:projectflutter/service_locator.dart';

class UserInfoDisplayCubit extends Cubit<UserInfoDisplayState> {
  UserInfoDisplayCubit() : super(UserInfoLoading());

  void displayUserInfo() async {
    var response = await sl<GetUserUsecase>().call();
    response.fold((err) {
      emit(LoadUserInfoFailure(errorMesssage: err));
    }, (data) {
      emit(UserInfoLoaded(user: data));
    });
  }

  void logout() async {
    await sl<LogoutUsecase>().call();
  }
}
