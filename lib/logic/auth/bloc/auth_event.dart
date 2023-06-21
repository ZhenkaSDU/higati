part of 'auth_bloc.dart';

abstract class AuthEvent {}

class GetSessionId extends AuthEvent {
  final String phone;
  final String fullName;

  GetSessionId(this.phone, this.fullName);
}