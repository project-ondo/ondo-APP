import 'package:get/get.dart';

class MainTopBarAlertController extends GetxController {
  RxBool enable = true.obs;
  RxInt totals = 0.obs;
  final List alerts = [
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
  ];

  MainTopBarAlertController() {
    setTotal();
  }

  void setEnable(bool value) => enable.value = value;

  void clearAlerts() {
    alerts.clear();
    setTotal();
  }

  void setTotal () => totals.value = alerts.length;

}
