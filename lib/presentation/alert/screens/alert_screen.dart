import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ondo/core/design_system/app_colors.dart';
import 'package:ondo/core/design_system/app_icon.dart';
import 'package:ondo/core/design_system/app_layout.dart';
import 'package:ondo/core/design_system/app_text_styles.dart';
import 'package:ondo/core/design_system/components/custom_alert_dialog.dart';
import 'package:ondo/core/design_system/components/custom_back_button.dart';
import 'package:ondo/presentation/alert/controllers/alert_controller.dart';
import 'package:ondo/core/ui/base/base_scaffold.dart';
import 'package:ondo/presentation/alert/states/alert_state.dart';

import '../widgets/alert_card.dart';
import '../widgets/report_alert_card.dart';

@immutable
class AlertScreen extends GetView<AlertController> {
  const AlertScreen({super.key});

  void _showAlertDeleteDialog(BuildContext context) => showDialog(
    context: context,
    builder: (context) => CustomAlertDialog(
      title: "알림",
      comment: "정말 모든 알림을 삭제하시겠어요?",
      actionLeft: () {
        Navigator.pop(context);
      },
      actionRight: () {
        controller.clearAlerts();
        Navigator.pop(context);
      },
      rightActionText: "삭제",
    ),
  );

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      body: Column(
        children: [
          _topBar(),
          Expanded(child: _body()),
          AppGap.v16,
        ],
      ),
    );
  }

  Widget _topBar() => CustomBackButton(
    moreOptions: true,
    itemBuilder: (context) => [
      PopupMenuItem(
        padding: AppPadding.popupManuButton,
        onTap: () => _showAlertDeleteDialog(context),
        height: double.minPositive,
        child: Align(
          alignment: Alignment.center,
          child: Text(
            "읽은 알림 모두 삭제",
            style: AppTextStyles.caption(textColor: AppColors.gray90),
          ),
        ),
      ),
    ],
  );

  Widget _body() => Container(
    color: AppColors.background,
    child: Column(
      children: [
        _Title(),

        Obx(
          () => Expanded(
            child: controller.enable.value
                ? _AlertPageList()
                : _noMessageIcon(),
          ),
        ),
      ],
    ),
  );

  Widget _noMessageIcon() => Column(
    children: [
      Spacer(
        flex: 153,
      ),
      Image.asset(AppIcon.message.path),
      Text(
        "지금은 알려드릴 게 없어요",
        style: AppTextStyles.textMedium(textColor: AppColors.gray60),
      ),
      Spacer(
        flex: 275,
      ),
    ],
  );
}

class _Title extends GetView<AlertController> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      padding: AppPadding.screenHorizontal,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppGap.v8,
          Row(
            children: [
              Text(
                "알림",
                style: AppTextStyles.titleSm16(textColor: AppColors.gray90),
              ),
              AppGap.h12,
              Obx(
                () => Text(
                  "${controller.total.value}",
                  style: AppTextStyles.textMedium(textColor: AppColors.gray60),
                ),
              ),
            ],
          ),
          AppGap.v16,
        ],
      ),
    );
  }
}

@immutable
class _AlertPageList extends GetView<AlertController> {
  final ValueNotifier<int> curIndex = ValueNotifier(0);

  int getTotalPage() => (controller.total / 11).ceil();

  int getStartIndex(int index) => index * 11;

  int getLastIndex(int index) =>
      min(getStartIndex(index) + 11, controller.total.value);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      padding: AppPadding.screenHorizontal,
      child: Column(
        children: [
          Expanded(
            child: PageView.builder(
              itemCount: getTotalPage(),
              onPageChanged: (value) => curIndex.value = value,
              itemBuilder: (context, index) =>
                  _alertList(getStartIndex(index), getLastIndex(index)),
            ),
          ),
          AppGap.v16,
          _indicator(),
        ],
      ),
    );
  }

  Widget _alertList(int startIndex, int lastIndex) {
    final subAlerts = controller.alerts.sublist(startIndex, lastIndex);
    return ListView.separated(
      shrinkWrap: true,
      itemCount: subAlerts.length,
      itemBuilder: (context, index) {
        final alert = subAlerts[index];

        if (alert.type == AlertState.reported) {
          return ReportAlertCard(
            profileImg: alert.profileImg,
            reason: "욕설",
            restrictAt: DateTime.now(),
            restrictDuration: Duration(days: 7),
          );
        }

        return AlertCard(
          profileImg: alert.profileImg,
          alertType: alert.type.title,
          sendAt: alert.sendAt!,
          comment: alert.comment,
        );
      },
      separatorBuilder: (context, index) => AppGap.v16,
    );
  }

  Widget _indicator() => ValueListenableBuilder(
    valueListenable: curIndex,
    builder: (_, _, _) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          (controller.alerts.length / 11).ceil(),
          (index) => Padding(
            padding: AppPadding.userCard,
            child: Text(
              "${index + 1}",
              style: AppTextStyles.pageIndicator(
                isCurrent: curIndex.value == index,
              ),
            ),
          ),
        ),
      );
    },
  );
}
