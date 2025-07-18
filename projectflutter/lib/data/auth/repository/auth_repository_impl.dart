import 'dart:convert';

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
  Future<bool> isLoggedIn() async {
    return await sl<AuthService>().isLoggedIn();
  }


  @override
  Future<void> logout() async {
    await sl<AuthService>().logout();
  }

  @override
  Future<Either> refreshToken() async {
    return sl<AuthService>().refreshToken();
  }

  @override
  Future<Either> getByUsername() async {
    var user = await sl<AuthService>().getByUsername();
    return user.fold(
          (error) => Left(error),
          (data) {

        final decoded = json.decode(data);
        final userMap = decoded['data'];
        final userEntity = UserModel.fromMap(userMap).toEntity();
        return Right(userEntity);
      },
    );
  }

  @override
  Future<Either> getUser() async {
    var user = await sl<AuthService>().getUser();
    return user.fold(
          (error) => Left(error),
          (data) {
        final decoded = json.decode(data);
        final userMap = decoded['data'];
        final userEntity = UserModel.fromMap(userMap).toEntity();
        return Right(userEntity);
      },
    );
  }

  @override
  Future<bool> ensureValidToken() async {
    return await sl<AuthService>().ensureValidToken();
  }

  @override
  Future<Either> introspectToken() {
    // TODO: implement introspectToken
    throw UnimplementedError();
  }
}
