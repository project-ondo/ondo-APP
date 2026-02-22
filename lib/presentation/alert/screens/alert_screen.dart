import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ondo/core/design_system/app_colors.dart';
import 'package:ondo/core/design_system/app_icon.dart';
import 'package:ondo/core/design_system/app_layout.dart';
import 'package:ondo/core/design_system/app_text_styles.dart';
import 'package:ondo/core/design_system/components/custom_alert_dialog.dart';
import 'package:ondo/core/design_system/components/custom_back_button.dart';
import 'package:ondo/core/design_system/components/top_bar/controllers/main_top_bar_alert_controller.dart';
import 'package:ondo/core/ui/base/base_scaffold.dart';

import '../widgets/alert_card.dart';
import '../widgets/report_alert_card.dart';

@immutable
class AlertScreen extends StatefulWidget {
  const AlertScreen({super.key});

  @override
  State<AlertScreen> createState() => _AlertScreenState();
}

class _AlertScreenState extends State<AlertScreen> {
  final MainTopBarAlertController _controller = Get.put(
    MainTopBarAlertController(),
  );

  void _showAlertDeleteDialog() => showDialog(
    context: context,
    builder: (context) => CustomAlertDialog(
      title: "알림",
      comment: "정말 모든 알림을 삭제하시겠어요?",
      actionLeft: () {
        Navigator.pop(context);
      },
      actionRight: () {
        setState(() {
          _controller.clearAlerts();
        });
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
        ],
      ),
    );
  }

  Widget _topBar() => Column(
    children: [
      CustomBackButton(
        moreOptions: true,
        itemBuilder: (context) => [
          PopupMenuItem(
            padding: AppPadding.popupManuButton,
            onTap: () => _showAlertDeleteDialog(),
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
      ),
      AppGap.v8,
      Padding(
        padding: AppPadding.screenHorizontal,
        child: _title(),
      ),
      AppGap.v16,
    ],
  );

  Widget _body() => Container(
    width: double.maxFinite,
    color: AppColors.background,
    child: Padding(
      padding: AppPadding.screenHorizontal,
      child: Column(
        children: [
          if (_controller.totals <= 0)
            Expanded(child: _noMessageIcon())
          else
            _AlertPageList(),
        ],
      ),
    ),
  );

  Widget _title() => Row(
    children: [
      Text(
        "알림",
        style: AppTextStyles.titleSm16(textColor: AppColors.gray90),
      ),
      AppGap.h12,
      Text(
        "${_controller.totals.value}",
        style: AppTextStyles.textMedium(textColor: AppColors.gray60),
      ),
    ],
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

@immutable
class _AlertPageList extends StatefulWidget {
  const _AlertPageList();

  @override
  State<_AlertPageList> createState() => _AlertPageListState();
}

class _AlertPageListState extends State<_AlertPageList> {
  final MainTopBarAlertController _controller =
      Get.find<MainTopBarAlertController>();

  ValueNotifier<int> curPageIndex = ValueNotifier(0);

  bool isOverInList(int lastIndex) => lastIndex > _controller.alerts.length;

  int lastIndexInList(int startIndex) =>
      isOverInList(startIndex + 11) ? _controller.alerts.length : 11;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 624,
          child: PageView.builder(
            onPageChanged: (value) => curPageIndex.value = value,
            itemBuilder: (context, index) {
              return _alertList(
                _controller.alerts.sublist(
                  index * 11,
                  lastIndexInList(index * 11),
                ),
              );
            },
            itemCount: (_controller.alerts.length / 11).ceil(),
          ),
        ),
        AppGap.v16,
        _indicator(),
      ],
    );
  }

  Widget _alertList(List subAlerts) => ListView.separated(
    itemBuilder: (context, index) {
      if (index % 2 == 0) {
        return ReportAlertCard(
          profileImage: AppIcon.defaultProfile.path,
          reason: "욕설",
          restrictAt: DateTime.now(),
          restrictDuration: Duration(days: 7),
        );
      }
      return AlertCard(
        profileImage: AppIcon.defaultProfile.path,
        alertType: "누군가가 댓글을 남겼어요.",
        sendAt: Duration(hours: 3),
        comment: "진짜 ㄹㅇ...",
      );
    },
    separatorBuilder: (context, index) => AppGap.v16,
    itemCount: subAlerts.length,
  );

  Widget _indicator() => ValueListenableBuilder(
    valueListenable: curPageIndex,
    builder: (_, _, _) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          (_controller.alerts.length / 11).ceil(),
          (index) => Padding(
            padding: AppPadding.pageIndicator,
            child: Text(
              "${index + 1}",
              style: AppTextStyles.pageIndicator(
                isCurrent: curPageIndex.value == index,
              ),
            ),
          ),
        ),
      );
    },
  );
}
