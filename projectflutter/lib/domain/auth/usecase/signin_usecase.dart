import 'package:dartz/dartz.dart';
import 'package:projectflutter/core/usecase/usecase.dart';
import 'package:projectflutter/data/auth/model/signin_request.dart';
import 'package:projectflutter/domain/auth/repository/auth_repository.dart';
import 'package:projectflutter/service_locator.dart';

class SigninUseCase extends UseCase<Either, SigninRequest> {
  @override
  Future<Either> call({SigninRequest? params}) async {
    return await sl<AuthRepository>().signin(params!);
  }
}
