part of 'login_bloc.dart';

abstract class LoginEvent {}

class GetSessionId extends LoginEvent {
  final String phone;

  GetSessionId(this.phone);
}