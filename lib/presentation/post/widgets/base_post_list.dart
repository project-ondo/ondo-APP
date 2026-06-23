import 'package:flutter/material.dart';
import 'package:ondo/core/design_system/app_colors.dart';
import 'package:ondo/core/design_system/app_layout.dart';
import 'package:ondo/core/design_system/app_text_styles.dart';
import 'package:ondo/core/design_system/app_icon.dart';
import 'package:ondo/core/design_system/components/app_empty_state.dart';
import 'package:ondo/core/design_system/components/app_error_state.dart';
import 'package:ondo/core/design_system/components/app_loading_indicator.dart';

import 'post_item.dart';

@immutable
class PostGridList extends StatelessWidget {
  final String title;
  final List<PostItem> list;
  final bool scrollable;
  final bool isLoading;
  final String errorMessage;
  final String emptyMessage;
  final VoidCallback? onRetry;

  const PostGridList({
    super.key,
    required this.title,
    this.scrollable = false,
    required this.list,
    this.isLoading = false,
    this.errorMessage = '',
    this.emptyMessage = '게시물이 없어요.',
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppPadding.screenHorizontal,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.titleSm16(textColor: AppColors.gray90),
          ),
          AppGap.v16,
          _content(),
        ],
      ),
    );
  }

  Widget _content() {
    if (isLoading && list.isEmpty) {
      return const SizedBox(height: 160, child: AppLoadingIndicator());
    }
    if (errorMessage.isNotEmpty && list.isEmpty) {
      return SizedBox(
        height: 160,
        child: AppErrorState(message: errorMessage, onRetry: onRetry),
      );
    }
    if (list.isEmpty) {
      return SizedBox(
        height: 160,
        child: AppEmptyState(
          message: emptyMessage,
          icon: AppIcon.communityUnSelect,
        ),
      );
    }
    return Column(
      children: [
        GridView(
          shrinkWrap: true,
          physics:
              scrollable ? null : const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: AppSpacing.s16,
            crossAxisSpacing: AppSpacing.s16,
            childAspectRatio: 3 / 2,
          ),
          children: list,
        ),
        if (isLoading) const AppBottomLoadingIndicator(),
      ],
    );
  }
}
