import 'package:digioteca/app/modules/auth/auth_binding.dart';
import 'package:digioteca/app/modules/home/home_page.dart';
import 'package:get/get.dart';

import '../modules/auth/auth_page.dart';

class AppRoutes {
  static final routes = [
    GetPage(
      name: '/login',
      page: () => AuthPage(),
      binding: AuthBinding(),
      //Todo n consegui fazer o middleware funcionar.
      //middlewares: [AuthPageMiddleware()]),
    ),
    GetPage(name: '/home', page: () => HomePage())
  ];
}
