import 'package:dio/dio.dart';

abstract class AuthDataSource {
  Future<Response> getSessionId(String phone, String fullName);
}

class AuthDataSourceImpl implements AuthDataSource {
  Dio dio = Dio();

  @override
  Future<Response> getSessionId(String phone, String fullName) async {
    Response response = await dio.post(
        'https://hegati-app.com/Api/service/enduser/register',
        data: {"phone": phone, "full_name": fullName});
    return response;
  }
}