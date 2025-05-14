import 'package:dartz/dartz.dart';
import 'package:projectflutter/core/usecase/usecase.dart';
import 'package:projectflutter/data/auth/model/register_request.dart';
import 'package:projectflutter/domain/auth/repository/auth_repository.dart';
import 'package:projectflutter/service_locator.dart';

class SignupUsecase extends UseCase<Either, RegisterRequest> {
  @override
  Future<Either> call({RegisterRequest? params}) async {
    return sl<AuthRepository>().signup(params!);
  }
}
