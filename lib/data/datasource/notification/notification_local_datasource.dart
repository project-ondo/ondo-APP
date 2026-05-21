import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationLocalDatasource {
  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  /// SharedPreferences 인스턴스 캐시 — init() 호출 후 재사용
  SharedPreferences? _prefs;

  // SharedPreferences 키
  static const String keyPushEnabled = 'push_notification_enabled';
  static const String keyVibrationEnabled = 'vibration_enabled';
  static const String keySoundEnabled = 'sound_enabled';

  // 알림 채널 ID
  static const String _channelSoundVibration = 'ondo_sound_vibration';
  static const String _channelSoundOnly = 'ondo_sound_only';
  static const String _channelVibrationOnly = 'ondo_vibration_only';
  static const String _channelSilent = 'ondo_silent';

  /// 앱 시작 시 초기화
  ///
  /// [onNotificationTap] 알림 탭 시 실행할 콜백 (presentation 레이어에서 주입)
  ///
  /// await를 보장하려면 Splash 화면 등 async 컨텍스트에서 호출해야 한다.
  Future<void> init({VoidCallback? onNotificationTap}) async {
    // SharedPreferences 인스턴스를 미리 확보하여 이후 읽기/쓰기에 재사용
    _prefs = await SharedPreferences.getInstance();

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    await _plugin.initialize(
      settings: const InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      ),
      onDidReceiveNotificationResponse: (response) {
        onNotificationTap?.call();
      },
    );

    // Android 알림 권한 요청
    await _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();
  }

  // ─── 내부 헬퍼 ─────────────────────────────────────────────────

  /// 캐시된 인스턴스를 반환하며, init() 전에 호출된 경우 새로 생성한다.
  Future<SharedPreferences> _getPrefs() async {
    return _prefs ??= await SharedPreferences.getInstance();
  }

  // ─── 설정값 불러오기 ───────────────────────────────────────────

  Future<bool> isPushEnabled() async {
    final prefs = await _getPrefs();
    return prefs.getBool(keyPushEnabled) ?? true;
  }

  Future<bool> isVibrationEnabled() async {
    final prefs = await _getPrefs();
    return prefs.getBool(keyVibrationEnabled) ?? false;
  }

  Future<bool> isSoundEnabled() async {
    final prefs = await _getPrefs();
    return prefs.getBool(keySoundEnabled) ?? false;
  }

  // ─── 설정값 저장 ───────────────────────────────────────────────

  Future<void> setPushEnabled(bool value) async {
    final prefs = await _getPrefs();
    await prefs.setBool(keyPushEnabled, value);
  }

  Future<void> setVibrationEnabled(bool value) async {
    final prefs = await _getPrefs();
    await prefs.setBool(keyVibrationEnabled, value);
  }

  Future<void> setSoundEnabled(bool value) async {
    final prefs = await _getPrefs();
    await prefs.setBool(keySoundEnabled, value);
  }

  // ─── 알림 발송 ─────────────────────────────────────────────────

  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    final isPush = await isPushEnabled();
    if (!isPush) return;

    final isVibration = await isVibrationEnabled();
    final isSound = await isSoundEnabled();

    final channelId = _resolveChannelId(isSound, isVibration);
    final channelName = _resolveChannelName(isSound, isVibration);

    final androidDetails = AndroidNotificationDetails(
      channelId,
      channelName,
      importance: Importance.max,
      priority: Priority.high,
      playSound: isSound,
      enableVibration: isVibration,
    );

    final iosDetails = DarwinNotificationDetails(
      presentSound: isSound,
      presentBadge: true,
      presentAlert: true,
    );

    await _plugin.show(
      id: id,
      title: title,
      body: body,
      notificationDetails: NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      ),
    );
  }

  // ─── 내부 유틸 ─────────────────────────────────────────────────

  String _resolveChannelId(bool isSound, bool isVibration) {
    if (isSound && isVibration) return _channelSoundVibration;
    if (isSound && !isVibration) return _channelSoundOnly;
    if (!isSound && isVibration) return _channelVibrationOnly;
    return _channelSilent;
  }

  String _resolveChannelName(bool isSound, bool isVibration) {
    if (isSound && isVibration) return '소리 + 진동 알림';
    if (isSound && !isVibration) return '소리 알림';
    if (!isSound && isVibration) return '진동 알림';
    return '무음 알림';
  }
}
