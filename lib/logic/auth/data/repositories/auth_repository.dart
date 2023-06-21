import 'package:dio/dio.dart';
import 'package:parents/logic/auth/data/datasources/auth_datasource.dart';

abstract class AuthRepository {
  Future<Response> getSessionId(String phone, String fullName);
}

class AuthRepositoryImpl implements AuthRepository {
  final AuthDataSource authDataSource;

  AuthRepositoryImpl(this.authDataSource);

  @override
  Future<Response> getSessionId(String phone, String fullName) async {
    Response response = await authDataSource.getSessionId(phone, fullName);
    return response;
  }
}