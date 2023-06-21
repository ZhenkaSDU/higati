import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:parents/logic/sms/data/repositories/sms_repository.dart';

part 'sms_event.dart';
part 'sms_state.dart';

class SmsBloc extends Bloc<SmsEvent, SmsState> {
  final SmsRepository smsRepository;
  SmsBloc(this.smsRepository) : super(SmsInitial()) {
    on<GetRes>((event, emit) async {
      emit(SmsLoading());
      try {
        final Response response =
            await smsRepository.getRes(event.sessionId,event.smsCode);
        emit(SmsSuccess(response));
      } on DioError catch (e) {
        emit(SmsFailure(e.message));
      }
    });
  }
}