import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ondo/core/constants/report_type.dart';
import 'package:ondo/core/design_system/app_colors.dart';
import 'package:ondo/core/design_system/app_layout.dart';
import 'package:ondo/core/design_system/app_text_styles.dart';
import 'package:ondo/core/design_system/component_variants.dart';
import 'package:ondo/core/design_system/components/custom_button.dart';
import 'package:ondo/core/design_system/components/custom_tag_card.dart';
import 'package:ondo/core/design_system/components/custom_textfield.dart';
import 'package:ondo/domain/usecases/report/report_use_case.dart';

class CustomReportDialog extends StatefulWidget {
  const CustomReportDialog({
    super.key,
    required this.type,
    required this.targetId,
  });

  final ReportType type;
  final String targetId;

  @override
  State<CustomReportDialog> createState() => _CustomReportDialogState();
}

class _CustomReportDialogState extends State<CustomReportDialog> {
  final TextEditingController controller = TextEditingController();

  final Set<ReportReason> _selectedReasons = {};

  String get _title => switch (widget.type) {
    ReportType.post => '게시물 신고',
    ReportType.comment => '댓글 신고',
    ReportType.chatRoom => '채팅방 신고',
    ReportType.user => '유저 신고',
  };

  bool get _isValid =>
      _selectedReasons.isNotEmpty && controller.text.trim().isNotEmpty;

  Future<void> _submitReport() async {
    if (!_isValid) return;

    final description = [
      'tags',
      ..._selectedReasons.map((e) => e.label),
      if (controller.text.trim().isNotEmpty) ...['detail', controller.text.trim()],
    ].join('\n');

    await Get.find<ReportUseCase>()(
      targetType: widget.type,
      targetId: widget.targetId,
      description: description,
    );

    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
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
              Center(child: Text(_title, style: AppTextStyles.titleBold20())),
              AppGap.v16,
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.start,
                  spacing: AppSpacing.s12,
                  runSpacing: AppSpacing.s12,
                  children: ReportReason.values.map(
                    (r) {
                      return CustomTagCard(
                        label: r.label,
                        onTap: (isSelect) {
                          setState(() {
                            if (isSelect) {
                              _selectedReasons.add(r);
                            } else {
                              _selectedReasons.remove(r);
                            }
                          });
                        },
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
