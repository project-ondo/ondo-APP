import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ondo/core/design_system/app_colors.dart';
import 'package:ondo/core/design_system/app_icon.dart';
import 'package:ondo/core/design_system/app_layout.dart';
import 'package:ondo/core/design_system/app_text_styles.dart';

@immutable
class ChatRoomCard extends StatelessWidget {
  final ValueNotifier<bool> bookmark;
  final String name;
  final Duration lastChatAt;
  final String lastChat;
  final int newChatCount;
  final VoidCallback? onTap;

  ChatRoomCard({
    super.key,
    required bool bookmark,
    required this.name,
    required this.lastChatAt,
    required this.lastChat,
    required this.newChatCount,
    this.onTap,
  }) : bookmark = ValueNotifier(bookmark);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: AppPadding.card,
        decoration: BoxDecoration(
          borderRadius: AppRadius.baseRadius,
          color: AppColors.white,
        ),
        child: Row(
          children: [
            _profile(),
            AppGap.h16,
            Expanded(child: _content()),
            if (newChatCount > 1) _newChatCountIcon(),
            _bookmarkIcon(),
          ],
        ),
      ),
    );
  }

  Widget _profile() => Container(
    height: AppSpacing.s36,
    width: AppSpacing.s36,
    decoration: BoxDecoration(borderRadius: AppRadius.circleRadius),
    child: SvgPicture.asset(AppIcon.defaultProfile.path),
  );

  Widget _content() => Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            name,
            style: AppTextStyles.caption(textColor: AppColors.gray60),
          ),
          Text(
            "${lastChatAt.inHours}시간 전",
            style: AppTextStyles.caption(textColor: AppColors.gray60),
          ),
        ],
      ),
      Text(
        lastChat,
        style: AppTextStyles.caption(
          textColor: newChatCount != 0 ? AppColors.gray90 : AppColors.gray60,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    ],
  );

  Widget _newChatCountIcon() => Padding(
    padding: AppPadding.between,
    child: Text(
      "+$newChatCount",
      style: AppTextStyles.caption(textColor: AppColors.primary),
    ),
  );

  Widget _bookmarkIcon() => ValueListenableBuilder(
    valueListenable: bookmark,
    builder: (context, value, child) {
      return IconButton(
        onPressed: () => bookmark.value = !bookmark.value,
        icon: Image.asset(
          AppIcon.bookmark.path,
          color: bookmark.value ? AppColors.yellow : AppColors.gray50,
          fit: BoxFit.fill,
        ),
        style: ButtonStyle(
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          padding: WidgetStatePropertyAll(EdgeInsets.zero),
        ),
      );
    },
  );
}
