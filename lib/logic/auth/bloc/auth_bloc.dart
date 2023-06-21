import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:parents/logic/auth/data/repositories/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;
  AuthBloc(this.authRepository) : super(AuthInitial()) {
    on<GetSessionId>((event, emit) async {
      emit(AuthLoading());
      try {
        final Response response =
            await authRepository.getSessionId(event.phone, event.fullName);
        emit(AuthSuccess(response));
      } on DioError catch (e) {
        emit(AuthFailure(e.message));
      }
    });
  }
}