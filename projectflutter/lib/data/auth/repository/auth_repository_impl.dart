import 'package:dartz/dartz.dart';
import 'package:projectflutter/data/auth/request/register_request.dart';
import 'package:projectflutter/data/auth/request/signin_request.dart';
import 'package:projectflutter/data/auth/model/user.dart';
import 'package:projectflutter/data/auth/source/auth_service.dart';
import 'package:projectflutter/domain/auth/repository/auth_repository.dart';
import 'package:projectflutter/service_locator.dart';

class AuthRepositoryImpl extends AuthRepository {
  @override
  Future<Either> signin(SigninRequest user) async {
    return await sl<AuthService>().signin(user);
  }

  @override
  Future<Either> signup(RegisterRequest user) async {
    return await sl<AuthService>().signup(user);
  }

  @override
  Future<Either> sendEmailResetPassword(String email) async {
    return await sl<AuthService>().sendEmailResetPassword(email);
  }

  @override
  Future<Either> getUser() async {
    var user = await sl<AuthService>().getUser();
    return user.fold((error) {
      return Left(error);
    }, (data) {
      return Right(UserModel.fromJson(data)
          .toEntity()); // Chuyển đổi dữ liệu từ map thành đối tượng UserModel(id:...,firstname:...)
    }); // toEntity giúp tách biệt tầng data và domain để code dễ bảo trì, dễ test
  }

  @override
  Future<bool> isLoggedIn() async {
    return await sl<AuthService>().isLoggedIn();
  }

  @override
  Future<Either> verfiy(String pinCode) async {
    return await sl<AuthService>().verfiy(pinCode);
  }

  @override
  Future<void> logout() async {
    await sl<AuthService>().logout();
  }
}
