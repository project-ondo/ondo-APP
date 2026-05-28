import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:ondo/core/design_system/app_layout.dart';
import 'package:ondo/core/design_system/components/custom_back_button.dart';
import 'package:ondo/core/router/app_router.dart';
import 'package:ondo/core/ui/base/base_scaffold.dart';
import 'package:ondo/presentation/profile/controllers/my_profile_controller.dart';
import 'package:ondo/presentation/profile/controllers/setting_controller.dart';
import 'package:ondo/presentation/profile/widget/build_app_version_session.dart';
import 'package:ondo/presentation/profile/widget/build_custom_switch.dart';
import 'package:ondo/presentation/profile/widget/custom_setting_item.dart';
import 'package:ondo/presentation/profile/widget/user_delete_popup.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MyProfileController>();
    final settingController = Get.find<SettingController>();

    return SafeArea(
      child: BaseScaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomBackButton(moreOptions: false),

            AppGap.v16,
            Obx(
              () => Container(
                width: double.maxFinite,
                padding: AppPadding.settingSession,
                child: Column(
                  children: [
                    BuildCustomSwitch(
                      name: '푸시알람',
                      value: settingController.isPush.value,
                      onChanged: settingController.togglePush,
                    ),
                    AppGap.v24,
                    BuildCustomSwitch(
                      name: 'ㄴ 진동알람',
                      value: settingController.isVibration.value,
                      onChanged: settingController.toggleVibration,
                    ),
                    AppGap.v16,
                    BuildCustomSwitch(
                      name: 'ㄴ 소리알람',
                      value: settingController.isSound.value,
                      onChanged: settingController.toggleSound,
                    ),
                    AppGap.v24,
                    // TODO: 온라인 표시 기능 API 연동 시 추가
                    BuildCustomSwitch(
                      name: '다른 사람에게 온라인 표시',
                      value: false,
                      onChanged: (_) {},
                    ),
                  ],
                ),
              ),
            ),
            AppGap.v16,
            Container(
              width: double.maxFinite,
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
