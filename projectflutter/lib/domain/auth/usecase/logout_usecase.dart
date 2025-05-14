import 'package:projectflutter/core/usecase/usecase.dart';
import 'package:projectflutter/domain/auth/repository/auth_repository.dart';
import 'package:projectflutter/service_locator.dart';

class LogoutUsecase extends UseCase<void, void> {
  @override
  Future<void> call({params}) async {
    await sl<AuthRepository>().logout();
  }
}
