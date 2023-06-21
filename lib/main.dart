import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:parents/features/login/login_screen.dart';
import 'package:parents/logic/auth/bloc/auth_bloc.dart';
import 'package:parents/logic/login/bloc/login_bloc.dart';
import 'package:parents/logic/sms/bloc/sms_bloc.dart';
import 'bloc_observer/app_bloc_observer.dart';
import 'core/constants/global_variables.dart';
import 'core/get_it/injection_container.dart';
import 'core/utils/hive/hive_init.dart';
import 'firebase_options.dart';

 FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initGetIt();
  await Hive.initFlutter();
  initHiveAdapters();
  await initHiveBoxes();
  Bloc.observer = AppBlocObserver.instance();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseMessaging.instance.getInitialMessage();

  runApp(MyApp());
}



class MyApp extends StatefulWidget {
  MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LoginBloc>(
          create: (_) => sl(),
        ),
        BlocProvider<AuthBloc>(
          create: (_) => sl(),
        ),
        BlocProvider<SmsBloc>(
          create: (_) => sl(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Kindergarden',
        theme: ThemeData(
            scaffoldBackgroundColor: GlobalVariables.whiteColor,
            appBarTheme: const AppBarTheme(
              elevation: 0,
              iconTheme: IconThemeData(
                color: GlobalVariables.blackColor,
              ),
            )),
        // home: const Homev2Screen(),
        // home: const HomeScreen(),
        home: const LoginScreen(),
      ),
    );
  }
}
