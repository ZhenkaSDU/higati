import 'package:dio/dio.dart';
import 'package:parents/logic/login/data/datasources/login_datasource.dart';

abstract class LoginRepository {
  Future<Response> getSessionId(String phone);
}

class LoginRepositoryImpl implements LoginRepository {
  final LoginDataSource loginDataSource;

  LoginRepositoryImpl(this.loginDataSource);

  @override
  Future<Response> getSessionId(String phone) async {
    Response response = await loginDataSource.getSessionId(phone);
    return response;
  }
}