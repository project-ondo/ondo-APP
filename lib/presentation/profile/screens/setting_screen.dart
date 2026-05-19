import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:ondo/core/design_system/app_layout.dart';
import 'package:ondo/core/design_system/components/custom_back_button.dart';
import 'package:ondo/core/router/app_router.dart';
import 'package:ondo/core/ui/base/base_scaffold.dart';
import 'package:ondo/presentation/profile/controllers/my_profile_controller.dart';
import 'package:ondo/presentation/profile/widget/build_app_version_session.dart';
import 'package:ondo/presentation/profile/widget/build_custom_switch.dart';
import 'package:ondo/presentation/profile/widget/custom_setting_item.dart';
import 'package:ondo/presentation/profile/widget/user_delete_popup.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool isPushState = false;
  bool isVibrationState = false;
  bool isSoundState = false;
  bool isOnLine = false;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MyProfileController>();

    return SafeArea(
      child: BaseScaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () => context.pop(),
              child: const CustomBackButton(moreOptions: false),
            ),
            AppGap.v16,
            Container(
              width: MediaQuery.of(context).size.width,
              padding: AppPadding.settingSession,
              child: Column(
                children: [
                  BuildCustomSwitch(
                    name: '푸시알람',
                    value: isPushState,
                    onChanged: (value) => setState(() {
                      isPushState = !isPushState;
                      isVibrationState = false;
                      isSoundState = false;
                    }),
                  ),
                  AppGap.v24,
                  //진동알람
                  BuildCustomSwitch(
                    name: 'ㄴ 진동알람',
                    value: isVibrationState,
                    onChanged: (value) => setState(() {
                      isVibrationState = !isVibrationState;
                    }),
                  ),
                  AppGap.v16,
                  //소리알람
                  BuildCustomSwitch(
                    name: 'ㄴ 소리알람',
                    value: isSoundState,
                    onChanged: (value) => setState(() {
                      isSoundState = !isSoundState;
                    }),
                  ),
                  AppGap.v24,
                  //온라인 표시
                  BuildCustomSwitch(
                    name: '다른 사람에게 온라인 표시',
                    value: isOnLine,
                    onChanged: (value) => setState(() {
                      isOnLine = !isOnLine;
                    }),
                  ),
                ],
              ),
            ),
            AppGap.v16,
            Container(
              width: MediaQuery.of(context).size.width,
              padding: AppPadding.settingSession,
              child: Column(
                children: [
                  CustomSettingItem(
                    name: '이용약관',
                    onTap: () => context.push(RoutePaths.profileTerms),
                  ),
                  AppGap.v24,
                  CustomSettingItem(
                    name: '회원탈퇴',
                    onTap: () => UserDeletePopup.userDeletePopup(
                      context,
                      onDelete: () async {
                        final success = await controller.deleteAccount();
                        if (success && context.mounted) {
                          context.go(RoutePaths.login);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            AppGap.v16,
            const BuildAppVersionSession(),
          ],
        ),
      ),
    );
  }
}