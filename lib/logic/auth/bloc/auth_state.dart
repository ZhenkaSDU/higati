part of 'auth_bloc.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final Response response;

  AuthSuccess(this.response);
}

class AuthFailure extends AuthState {
  final String message;

  AuthFailure(this.message);
}