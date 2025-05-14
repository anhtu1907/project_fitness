import 'package:projectflutter/core/usecase/usecase.dart';
import 'package:projectflutter/domain/auth/repository/auth_repository.dart';
import 'package:projectflutter/service_locator.dart';

class IsLoggedUsecase extends UseCase<bool, dynamic> {
  @override
  Future<bool> call({params}) async {
    return await sl<AuthRepository>().isLoggedIn();
  }
}
