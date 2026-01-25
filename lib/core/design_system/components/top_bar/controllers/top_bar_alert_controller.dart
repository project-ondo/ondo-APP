import 'package:get/get.dart';

class TopBarAlertController extends GetxController {
  final enable = true.obs;
  final totals = 30.obs;

  void setEnable (bool value) => enable.value = value;
  void setTotals (int value) => totals.value = value;
}
