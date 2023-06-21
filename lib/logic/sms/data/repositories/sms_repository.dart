import 'package:dio/dio.dart';
import 'package:parents/logic/sms/data/datasources/sms_datasource.dart';

abstract class SmsRepository {
  Future<Response> getRes(String sessionId, String smsCode);
}

class SmsRepositoryImpl implements SmsRepository {
  final SmsDataSource smsDataSource;

  SmsRepositoryImpl(this.smsDataSource);

  @override
  Future<Response> getRes(String sessionId, String smsCode) async {
    Response response = await smsDataSource.getRes(sessionId,smsCode);
    return response;
  }
}