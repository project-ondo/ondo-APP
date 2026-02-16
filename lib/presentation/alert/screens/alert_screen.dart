import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ondo/core/design_system/app_colors.dart';
import 'package:ondo/core/design_system/app_icon.dart';
import 'package:ondo/core/design_system/app_layout.dart';
import 'package:ondo/core/design_system/app_text_styles.dart';
import 'package:ondo/core/design_system/components/top_bar/controllers/main_top_bar_alert_controller.dart';
import 'package:ondo/core/ui/base/base_scaffold.dart';

import '../widgets/alert_card.dart';
import '../widgets/report_alert_card.dart';


void main () {
  runApp(MaterialApp(home: AlertScreen(),));
}



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

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      body: Padding(
        padding: AppPadding.screenHorizontal,
        child: Column(
          children: [
            _title(),
            AppGap.v16,
            _AlertPageList(),
          ],
        ),
      ),
    );
  }

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
}

@immutable
class _AlertPageList extends StatefulWidget {
  const _AlertPageList();

  @override
  State<_AlertPageList> createState() => _AlertPageListState();
}

class _AlertPageListState extends State<_AlertPageList> {
  final List alerts = List.filled(19, null);

  ValueNotifier<int> curPageIndex = ValueNotifier(0);

  bool isOverInList(int lastIndex) => lastIndex > alerts.length;

  int lastIndexInList(int startIndex) =>
      isOverInList(startIndex + 11) ? alerts.length : 11;

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
                alerts.sublist(
                  index * 11,
                  lastIndexInList(index * 11),
                ),
              );
            },
            itemCount: (alerts.length / 11).ceil(),
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
          (alerts.length / 11).ceil(),
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
