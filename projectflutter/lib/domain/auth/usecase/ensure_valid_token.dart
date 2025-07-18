
import 'package:projectflutter/core/usecase/usecase.dart';
import 'package:projectflutter/domain/auth/repository/auth_repository.dart';
import 'package:projectflutter/service_locator.dart';

class EnsureValidTokenUsecase extends UseCase<bool, void> {
  @override
  Future<bool> call({void params}) async {
    return sl<AuthRepository>().ensureValidToken();
  }
}
