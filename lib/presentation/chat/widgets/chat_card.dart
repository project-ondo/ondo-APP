import 'package:flutter/material.dart';
import 'package:ondo/core/design_system/app_colors.dart';
import 'package:ondo/core/design_system/app_layout.dart';
import 'package:ondo/core/design_system/app_text_styles.dart';

class ChatCard extends StatelessWidget {
  const ChatCard({
    super.key,
    required this.isMe,
    required this.text,
    this.isRead = false,
    this.sendAt,
    this.otherName,
    this.otherProfile,
  });

  final bool isMe;
  final String text;

  /// 내가 보낸 메시지가 상대방에게 읽혔는지 여부 (isMe == true 일 때만 사용)
  final bool isRead;
  final Widget? otherProfile;
  final String? otherName;
  final Duration? sendAt;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppPadding.chatMargin,
      child: isMe ? _myCard() : _otherCard(),
    );
  }

  Widget _myCard() => Row(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.end,
    children: [
      if (isRead)
        Padding(
          padding: const EdgeInsets.only(right: 4),
          child: Text(
            '읽음',
            style: AppTextStyles.caption(textColor: AppColors.primary),
          ),
        ),
      _card(),
    ],
  );

  Widget _otherCard() => Row(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _profile(),
      AppGap.h16,
      Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$otherName • ${_formatSendAt(sendAt)}",
            style: AppTextStyles.caption(textColor: AppColors.gray60),
          ),
          _card(),
        ],
      ),
    ],
  );

  String _formatSendAt(Duration? duration) {
    if (duration == null) return '';
    if (duration.inSeconds < 60) return '방금 전';
    if (duration.inMinutes < 60) return '${duration.inMinutes}분 전';
    if (duration.inHours < 24) return '${duration.inHours}시간 전';
    return '${duration.inDays}일 전';
  }

  Widget _profile() => Container(
    width: AppSpacing.s36,
    height: AppSpacing.s36,
    decoration: BoxDecoration(
      borderRadius: AppRadius.circleRadius,
    ),
    clipBehavior: Clip.hardEdge,
    child: otherProfile,
  );

  Widget _card() => ConstrainedBox(
    constraints: BoxConstraints(maxWidth: 300),
    child: Card(
      color: isMe ? AppColors.primary : AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: isMe ? AppRadius.myChat : AppRadius.otherChat,
      ),
      child: Padding(
        padding: AppPadding.chatPadding,
        child: Text(
          text,
          softWrap: true,
          style: AppTextStyles.textMedium(
            textColor: isMe ? AppColors.white : AppColors.black,
          ),
        ),
      ),
    ),
  );
}
