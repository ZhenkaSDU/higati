import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:parents/logic/login/data/repositories/login_repository.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginRepository loginRepository;
  LoginBloc(this.loginRepository) : super(LoginInitial()) {
    on<GetSessionId>((event, emit) async {
      emit(LoginLoading());
      try {
        final Response response =
            await loginRepository.getSessionId(event.phone);
        emit(LoginSuccess(response));
      } on DioError catch (e) {
        emit(LoginFailure(e.message));
      }
    });
  }
}