part of 'sms_bloc.dart';

abstract class SmsEvent {}

class GetRes extends SmsEvent {
  final String sessionId;
  final String smsCode;

  GetRes(this.sessionId,this.smsCode);
}