import 'package:flutter/material.dart';
import 'package:ondo/core/design_system/app_colors.dart';
import 'package:ondo/core/design_system/app_text_styles.dart';

class AppErrorState extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const AppErrorState({
    super.key,
    this.message = '데이터를 불러오지 못했어요.',
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, size: 48, color: AppColors.gray60),
          const SizedBox(height: 12),
          Text(
            message,
            style: AppTextStyles.textMedium(textColor: AppColors.gray60),
            textAlign: TextAlign.center,
          ),
          if (onRetry != null) ...[
            const SizedBox(height: 16),
            TextButton(
              onPressed: onRetry,
              child: Text(
                '다시 시도',
                style: AppTextStyles.textMedium(textColor: AppColors.primary),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
