part of 'sms_bloc.dart';

abstract class SmsState {}

class SmsInitial extends SmsState {}

class SmsLoading extends SmsState {}

class SmsSuccess extends SmsState {
  final Response response;

  SmsSuccess(this.response);
}

class SmsFailure extends SmsState {
  final String message;

  SmsFailure(this.message);
}