import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../features/auth/auth_screen.dart';

part 'app_router.gr.dart';

@MaterialAutoRouter(
  replaceInRouteName: 'Page,Screen,Route',
  routes: [
    AutoRoute(
      page: AuthScreen,
      path: '/',
      name: 'AuthScreenRoute',
      initial: true,
    ),
    
  ],
)
// extend the generated private router
class AppRouter extends _$AppRouter {}
