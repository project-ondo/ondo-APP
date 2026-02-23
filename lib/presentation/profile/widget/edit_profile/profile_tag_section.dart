import 'package:flutter/material.dart';
import 'package:ondo/core/design_system/app_colors.dart';
import 'package:ondo/core/design_system/app_layout.dart';
import 'package:ondo/core/design_system/app_text_styles.dart';
import 'package:ondo/presentation/profile/widget/edit_profile/profile_select_tag_chips.dart';

class ProfileTagSection extends StatelessWidget {
  const ProfileTagSection({
    super.key,
    required this.title,
    required this.tags,
    required this.selectedTags,
    required this.onTagToggle,
  });

  final String title;
  final List<String> tags;
  final Set<String> selectedTags;
  final void Function(String tag) onTagToggle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.textMedium(textColor: AppColors.gray80),
        ),
        AppGap.v4,
        Wrap(
          spacing: AppSpacing.s16,
          runSpacing: AppSpacing.s12,
          children: tags.map((e) {
            final bool isSelected = selectedTags.contains(e);

            return GestureDetector(
              onTap: () => onTagToggle(e),
              child: ProfileSelectTagChips(
                title: e,
                isSelected: isSelected,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
