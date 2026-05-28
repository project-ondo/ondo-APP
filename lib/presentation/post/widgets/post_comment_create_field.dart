import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ondo/core/design_system/app_colors.dart';
import 'package:ondo/core/design_system/app_icon.dart';
import 'package:ondo/core/design_system/app_layout.dart';
import 'package:ondo/core/design_system/app_text_styles.dart';
import 'package:ondo/core/design_system/components/custom_profile_circle.dart';

class PostCommentCreateField extends StatefulWidget {
  const PostCommentCreateField({
    super.key,
    required this.controller,
    required this.authorName,
    required this.profileUrl,
    required this.submit,
  });

  final TextEditingController controller;
  final String authorName;
  final String? profileUrl;
  final Function(String m) submit;

  @override
  State<PostCommentCreateField> createState() => _PostCommentCreateFieldState();
}

class _PostCommentCreateFieldState extends State<PostCommentCreateField> {
  bool enableSubmit = false;
  String text = "";

  void clear() {
    setState(() {
      text = "";
      enableSubmit = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: CustomProfileCircle(
              radius: AppSpacing.s24,
              imageUrl: widget.profileUrl,
            ),
          ),
          AppGap.h16,
          Expanded(
            child: Column(
              crossAxisAlignment: .start,
              children: [
                Text(
                  widget.authorName,
                  style: AppTextStyles.caption(textColor: AppColors.gray60),
                ),
                AppGap.v6,
                Expanded(child: _commentInputField()),
              ],
            ),
          ),
          AppGap.h12,
          Center(
            child: GestureDetector(
              onTap: () {
                if (enableSubmit) {
                  widget.submit.call(text.trim());
                  clear();
                }
              },
              child: Transform.flip(
                flipX: true,
                child: SvgPicture.asset(
                  AppIcon.arrowLeft.path,
                  colorFilter: ColorFilter.mode(
                    enableSubmit ? AppColors.primary : AppColors.gray60,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
          ),
          AppGap.h12,
        ],
      ),
    );
  }

  Widget _commentInputField() => TextField(
    controller: widget.controller,
    decoration: InputDecoration(
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: AppColors.gray90),
      ),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: AppColors.gray90),
      ),
      hintStyle: AppTextStyles.caption(textColor: AppColors.gray70),
      hintText: "댓글 입력...",
    ),
    onChanged: (text) {
      setState(() {
        this.text = text;
        enableSubmit = text.isNotEmpty;
      });
    },
    onSubmitted: enableSubmit
        ? (m) {
            widget.submit.call(m);
            clear();
          }
        : null,
  );
}
