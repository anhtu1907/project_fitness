import 'package:dartz/dartz.dart';
import 'package:projectflutter/data/auth/request/register_request.dart';
import 'package:projectflutter/data/auth/request/signin_request.dart';

abstract class AuthRepository {
  Future<Either> signin(SigninRequest user);
  Future<Either> signup(RegisterRequest user);
  Future<Either> sendEmailResetPassword(String email);
  Future<Either> getUser();
  Future<bool> isLoggedIn();
  Future<void> logout();
  Future<Either> refreshToken();
  Future<Either> getByUsername();
  Future<Either> introspectToken();
  Future<bool> ensureValidToken();
}
