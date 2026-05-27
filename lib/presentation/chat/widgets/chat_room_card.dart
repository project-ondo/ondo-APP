import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ondo/core/design_system/app_colors.dart';
import 'package:ondo/core/design_system/app_icon.dart';
import 'package:ondo/core/design_system/app_layout.dart';
import 'package:ondo/core/design_system/app_text_styles.dart';
import 'package:ondo/core/utils/app_date_utils.dart';
import 'package:ondo/domain/entities/chat/chat_entity.dart';

@immutable
class ChatRoomCard extends StatelessWidget {
  final ValueNotifier<bool> bookmark;
  final ChatEntity chat;
  final VoidCallback? onTap;

  ChatRoomCard({
    super.key,
    required this.chat,
    this.onTap,
    //TODO : 북마크 api 이후 수정
  }) : bookmark = ValueNotifier(false);

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
            if (chat.unreadCount > 1) _newChatCountIcon(),
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
            chat.opponentDisplayName,
            style: AppTextStyles.caption(textColor: AppColors.gray60),
          ),
          Text(
            AppDateUtils.timeAgo(chat.lastMessageAt),
            style: AppTextStyles.caption(textColor: AppColors.gray60),
          ),
        ],
      ),
      Text(
        chat.lastMessagePreview,
        style: AppTextStyles.caption(
          textColor: chat.unreadCount != 0
              ? AppColors.gray90
              : AppColors.gray60,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    ],
  );

  Widget _newChatCountIcon() => Padding(
    padding: AppPadding.between,
    child: Text(
      "+${chat.unreadCount}",
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
