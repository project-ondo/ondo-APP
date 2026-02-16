import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:ondo/core/design_system/app_colors.dart';
import 'package:ondo/core/design_system/app_icon.dart';
import 'package:ondo/core/design_system/app_layout.dart';
import 'package:ondo/core/design_system/app_text_styles.dart';
import 'package:ondo/core/design_system/components/top_bar/controllers/main_top_bar_alert_controller.dart';
import 'package:ondo/core/ui/base/base_scaffold.dart';


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

  final List alerts = List.filled(19, null);

  ValueNotifier<int> curPageIndex = ValueNotifier(0);

  bool isOverInList(int lastIndex) => lastIndex > alerts.length;

  int lastIndexInList(int startIndex) =>
      isOverInList(startIndex + 11) ? alerts.length : 11;

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      body: Padding(
        padding: AppPadding.screenHorizontal,
        child: Column(
          children: [
            _title(),
            AppGap.v16,
            _alertPage(),
            AppGap.v16,
            _indicator(),
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

  Widget _alertPage() => SizedBox(
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
  );

  Widget _alertList(List subAlerts) => ListView.separated(
    itemBuilder: (context, index) {
      if (index % 2 == 0) {
        return _ReportAlertItem(
          profileImage: AppIcon.defaultProfile.path,
          reason: "욕설",
          restrictAt: DateTime.now(),
          restrictDuration: Duration(days: 7),
        );
      }
      return _AlertItem(
        profileImage: AppIcon.defaultProfile.path,
        alertType: "누군가가 댓글을 남겼어요.",
        sendAt: Duration(hours: 3),
        comment: "진짜 ㄹㅇ...",
      );
    },
    separatorBuilder: (context, index) => SizedBox(
      height: AppSpacing.s16,
    ),
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

class _AlertItem extends StatelessWidget {
  final String alertType;
  final Duration sendAt;
  final String? comment;
  final String profileImage;

  const _AlertItem({
    required this.profileImage,
    required this.alertType,
    required this.sendAt,
    this.comment,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _profile(),
        AppGap.h12,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _title(),
              if (comment != null)
                Text(
                  comment!,
                  style: AppTextStyles.caption(textColor: AppColors.gray60),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
            ],
          ),
        ),
      ],
    );
  }

  final double _profileSize = 24;

  Widget _profile() => Container(
    height: _profileSize,
    width: _profileSize,
    decoration: BoxDecoration(
      borderRadius: AppRadius.circleRadius,
    ),
    child: SvgPicture.asset(profileImage),
  );

  Widget _title() => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        alertType,
        style: AppTextStyles.caption(textColor: AppColors.gray90),
      ),
      Text(
        "${sendAt.inHours}시간 전",
        style: AppTextStyles.caption(textColor: AppColors.gray60),
      ),
    ],
  );
}

class _ReportAlertItem extends StatelessWidget {
  final String profileImage;
  final String reason;
  final DateTime restrictAt;
  final Duration restrictDuration;

  const _ReportAlertItem({
    required this.profileImage,
    required this.reason,
    required this.restrictAt,
    required this.restrictDuration,
  });

  String _dateFormat(DateTime date) => "${date.year}-${date.month}-${date.day}";

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppPadding.alertReportItem,
      decoration: BoxDecoration(
        borderRadius: AppRadius.baseRadius,
        color: AppColors.redLight,
      ),
      child: Row(
        children: [
          _profile(),

          AppGap.h12,

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "신고가 누적되어 커피챗 및 커뮤티니 활동이 제한되었습니다.",
                  style: AppTextStyles.caption(textColor: AppColors.gray90),
                ),
                _content(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  final double _profileSize = 24;

  Widget _profile() => Container(
    height: _profileSize,
    width: _profileSize,
    decoration: BoxDecoration(
      borderRadius: AppRadius.circleRadius,
    ),
    child: SvgPicture.asset(profileImage),
  );

  Widget _content() => Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        "시유: $reason",
        style: AppTextStyles.caption(textColor: AppColors.gray70),
      ),
      Text(
        "기간: 제한 된 날로부터 ${restrictDuration.inDays}일간: ${_dateFormat(restrictAt)} - ${_dateFormat(restrictAt.add(restrictDuration))}",
        style: AppTextStyles.caption(textColor: AppColors.gray70),
      ),
    ],
  );
}
