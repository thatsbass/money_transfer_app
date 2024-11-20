import 'package:get/get.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';


class AppPages {
  static final routes = [
    GetPage(
      name: '/login',
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: '/client/home',
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
  ];
}