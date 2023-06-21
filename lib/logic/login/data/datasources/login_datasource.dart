import 'package:dio/dio.dart';

abstract class LoginDataSource {
  Future<Response> getSessionId(String phone);
}

class LoginDataSourceImpl implements LoginDataSource {
  Dio dio = Dio();

  @override
  Future<Response> getSessionId(String phone) async {
    Response response = await dio.post(
        'https://hegati-app.com/Api/service/enduser/login',
        data: {"phone": phone});
    return response;
  }
}