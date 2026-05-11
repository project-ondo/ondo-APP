
import 'package:flutter/material.dart';
import 'package:ondo/core/design_system/app_colors.dart';
import 'package:ondo/core/design_system/app_layout.dart';
import 'package:ondo/core/design_system/app_text_styles.dart';
import 'package:ondo/core/design_system/component_variants.dart';
import 'package:ondo/core/design_system/components/custom_button.dart';
import 'package:ondo/core/design_system/components/custom_textfield.dart';
import 'package:ondo/presentation/profile/widget/report_reason_chip.dart';

class PostReportDialog extends StatefulWidget {
  const PostReportDialog({
    super.key,
  });

  @override
  State<PostReportDialog> createState() => _PostReportDialogState();
}

class _PostReportDialogState extends State<PostReportDialog> {
  final TextEditingController controller = TextEditingController();

  final List<String> _reasons = [
    "욕설이 많아요",
    "상대를 존중하지 않아요",
    "불쾌감을 느끼는 발언을 해요",
    "공격적인 언어를 사용해요",
    "신분, 장애, 인종에 대해 차별 발언을 일삼아요",
    "부적절한 이름을 사용해요",
    "기타",
  ];

  final Set<String> _selectedReasons = {};

  bool get _isValid =>
      _selectedReasons.isNotEmpty || controller.text.trim().isNotEmpty;

  void _toggleReason(String reason) {
    setState(() {
      if (_selectedReasons.contains(reason)) {
        _selectedReasons.remove(reason);
      } else {
        _selectedReasons.add(reason);
      }
    });
  }

  Future<void> _submitReport() async {
    if (!_isValid) return;

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      alignment: Alignment.center,
      backgroundColor: AppColors.white,
      insetPadding: AppPadding.screenHorizontal,
      child: Container(
        padding: AppPadding.actionPopup,
        decoration: BoxDecoration(
          borderRadius: AppRadius.popupRadius,
          color: AppColors.white,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(child: Text("게시물 신고", style: AppTextStyles.titleBold20())),
              AppGap.v16,
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.start,
                  spacing: AppSpacing.s12,
                  runSpacing: AppSpacing.s12,
                  children: _reasons.map(
                        (e) {
                      return ReportReasonChip(
                        label: e,
                        isSelected: _selectedReasons.contains(e),
                        onTap: () => _toggleReason(e),
                      );
                    },
                  ).toList(),
                ),
              ),
              AppGap.v16,
              CustomTextField(
                controller: controller,
                hintText: "상세 내용을 입력해주세요",
                onChanged: (_) => setState(() {}),
                minLines: 4,
                maxLines: 4,
              ),
              AppGap.v16,
              CustomButton(
                text: "신고",
                variant: ButtonVariant.primary,
                enabled: _isValid,
                onPressed: () => _submitReport(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
