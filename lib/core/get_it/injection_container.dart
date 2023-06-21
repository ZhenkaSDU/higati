import 'package:get_it/get_it.dart';
import 'package:parents/logic/auth/bloc/auth_bloc.dart';
import 'package:parents/logic/auth/data/datasources/auth_datasource.dart';
import 'package:parents/logic/auth/data/repositories/auth_repository.dart';
import 'package:parents/logic/login/bloc/login_bloc.dart';
import 'package:parents/logic/login/data/datasources/login_datasource.dart';
import 'package:parents/logic/login/data/repositories/login_repository.dart';
import 'package:parents/logic/sms/bloc/sms_bloc.dart';
import 'package:parents/logic/sms/data/datasources/sms_datasource.dart';
import 'package:parents/logic/sms/data/repositories/sms_repository.dart';

var sl = GetIt.instance;

void initGetIt() async {
  sl.registerFactory<LoginBloc>(() => LoginBloc(sl()));

  sl.registerLazySingleton<LoginRepository>(() => LoginRepositoryImpl(sl()));

  sl.registerLazySingleton<LoginDataSource>(() => LoginDataSourceImpl());

  sl.registerFactory<AuthBloc>(() => AuthBloc(sl()));

  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));

  sl.registerLazySingleton<AuthDataSource>(() => AuthDataSourceImpl());

  sl.registerFactory<SmsBloc>(() => SmsBloc(sl()));

  sl.registerLazySingleton<SmsRepository>(() => SmsRepositoryImpl(sl()));

  sl.registerLazySingleton<SmsDataSource>(() => SmsDataSourceImpl());
}
