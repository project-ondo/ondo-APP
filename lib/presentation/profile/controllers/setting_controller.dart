import 'package:get/get.dart';
import 'package:ondo/domain/usecases/notification/load_notification_setting_use_case.dart';
import 'package:ondo/domain/usecases/notification/update_notification_setting_use_case.dart';

class SettingController extends GetxController {
  final LoadNotificationSettingUseCase loadNotificationSettingUseCase;
  final UpdateNotificationSettingUseCase updateNotificationSettingUseCase;

  SettingController({
    required this.loadNotificationSettingUseCase,
    required this.updateNotificationSettingUseCase,
  });

  final RxBool isPush = false.obs;
  final RxBool isVibration = false.obs;
  final RxBool isSound = false.obs;

  @override
  void onInit() {
    _loadSettings();
    super.onInit();
  }

  Future<void> _loadSettings() async {
    final settings = await loadNotificationSettingUseCase.call();
    isPush.value = settings['push'] ?? true;
    isVibration.value = settings['vibration'] ?? false;
    isSound.value = settings['sound'] ?? false;
  }

  Future<void> togglePush(bool value) async {
    isPush.value = value;
    // 푸시 끄면 진동/소리도 같이 끔
    if (!value) {
      isVibration.value = false;
      isSound.value = false;
      await updateNotificationSettingUseCase.setVibration(false);
      await updateNotificationSettingUseCase.setSound(false);
    }
    await updateNotificationSettingUseCase.setPush(value);
  }

  Future<void> toggleVibration(bool value) async {
    if (!isPush.value) return; // 푸시 꺼져있으면 변경 불가
    isVibration.value = value;
    await updateNotificationSettingUseCase.setVibration(value);
  }

  Future<void> toggleSound(bool value) async {
    if (!isPush.value) return; // 푸시 꺼져있으면 변경 불가
    isSound.value = value;
    await updateNotificationSettingUseCase.setSound(value);
  }
}
