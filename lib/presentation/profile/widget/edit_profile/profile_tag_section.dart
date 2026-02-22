import 'package:flutter/material.dart';
import 'package:ondo/core/design_system/app_colors.dart';
import 'package:ondo/core/design_system/app_layout.dart';
import 'package:ondo/core/design_system/app_text_styles.dart';
import 'package:ondo/presentation/profile/widget/edit_profile/profile_select_tag_chips.dart';

class ProfileTagSection extends StatefulWidget {
  const ProfileTagSection({
    super.key,
    required this.title,
    required this.tags,
    required this.selectedTags,
  });

  final String title;
  final List<String> tags;
  final Set<String> selectedTags;

  @override
  State<ProfileTagSection> createState() => _ProfileTagSectionState();
}

class _ProfileTagSectionState extends State<ProfileTagSection> {
  @override
  Widget build(BuildContext context) {
    final String title = widget.title;
    final List<String> tags = widget.tags;
    final Set<String> selectedTags = widget.selectedTags;

    void toggleTag(Set<String> targetSet, String tag) {
      setState(() {
        if (targetSet.contains(tag)) {
          targetSet.remove(tag);
        } else {
          targetSet.add(tag);
        }
      });
    }

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
          children: tags.map(
            (e) {
              final bool isSelected = selectedTags.contains(e);
              return GestureDetector(
                onTap: () => toggleTag(selectedTags, e),
                child: ProfileSelectTagChips(title: e, isSelected: isSelected),
              );
            },
          ).toList(),
        ),
      ],
    );
  }
}
