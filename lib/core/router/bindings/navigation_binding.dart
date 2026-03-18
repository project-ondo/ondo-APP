import 'package:get/get.dart';
import 'package:ondo/presentation/navigation/controllers/navigation_controller.dart';

class NavigationBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut<NavigationController>(() => NavigationController());
  }
}