import 'package:dio/dio.dart';

abstract class SmsDataSource {
  Future<Response> getRes(String sessionId, String smsCode);
}

class SmsDataSourceImpl implements SmsDataSource {
  Dio dio = Dio();

  @override
  Future<Response> getRes(String sessionId, String smsCode) async {
    Response response = await dio.post(
        'https://hegati-app.com/Api/service/enduser/verify_sms',
        data: {"session_id": sessionId, "sms_code" : smsCode});
    return response;
  }
}