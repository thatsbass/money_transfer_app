import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import '../../../../services/user_service.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserService>(() => UserService());
    Get.lazyPut<HomeController>(() => HomeController());
  }
}