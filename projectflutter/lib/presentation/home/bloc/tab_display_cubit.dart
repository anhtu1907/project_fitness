import 'package:flutter_bloc/flutter_bloc.dart';

class TabDisplayCubit extends Cubit<int> {
  TabDisplayCubit() : super(2);

  void changeTab(int index) {
    emit(index);
  }
}
