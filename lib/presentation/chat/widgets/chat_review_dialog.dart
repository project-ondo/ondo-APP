import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ondo/core/design_system/app_colors.dart';
import 'package:ondo/core/design_system/app_icon.dart';
import 'package:ondo/core/design_system/app_layout.dart';
import 'package:ondo/core/design_system/app_text_styles.dart';
import 'package:ondo/core/design_system/component_variants.dart';
import 'package:ondo/core/design_system/components/custom_button.dart';
import 'package:ondo/core/design_system/components/custom_tag_card.dart';
import 'package:ondo/presentation/chat/controllers/chat_review_controller.dart';

class ChatReviewDialog extends StatefulWidget {
  static final List<String> categories = [
    "질문에 대한 답변이 빨라요",
    "친절해요",
    "예의있어요",
    "매너가 좋아요",
    "잘 들어줘요",
    "상세하게 설명해줘요",
    "저를 존중해줘요",
    "신뢰할 수 있는 정보를 주었어요",
  ];

  const ChatReviewDialog({super.key});

  @override
  State<ChatReviewDialog> createState() => _ChatReviewDialogState();
}

class _ChatReviewDialogState extends State<ChatReviewDialog> {
  final ChatReviewController _controller = Get.put(ChatReviewController());

  final TextEditingController _textEditingController = TextEditingController();

  late final Map<String, bool> categoriesMap = Map.fromEntries(
    ChatReviewDialog.categories.map(
      (category) => MapEntry(category, false),
    ),
  );

  @override
  void initState() {
    _textEditingController.addListener(
      () => _controller.setDetailReview(_textEditingController.value.text),
    );

    super.initState();
  }

  void _tapStar(int index) => _controller.setStar(index);

  void _tapCategory(String category) {
    categoriesMap[category] = !(categoriesMap[category] ?? false);
    if (categoriesMap[category]!) {
      _controller.addCategory(category);
    } else {
      _controller.removeCategory(category);
    }
  }

  void _tapQuit() {
    _controller.submit();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.white,
      insetPadding: AppPadding.basePopup,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.popupRadius),
      child: Padding(
        padding: AppPadding.actionPopup,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "리뷰 남기기",
              style: AppTextStyles.popupTitle(),
            ),
            AppGap.v16,
            _starIconList(),
            AppGap.v16,
            _reviewCategoryList(),
            AppGap.v16,
            _reviewDetailInputField(),
            AppGap.v16,
            _quitButton(),
          ],
        ),
      ),
    );
  }

  Widget _quitButton() => Obx(
    () => CustomButton(
      text: "종료",
      variant: ButtonVariant.primary,
      onPressed: _tapQuit,
      enabled: _controller.enableSubmit.value,
    ),
  );

  Widget _reviewDetailInputField() => SizedBox(
    height: 120,
    child: TextField(
      expands: true,
      maxLines: null,
      minLines: null,
      textAlignVertical: TextAlignVertical.top,
      controller: _textEditingController,
      decoration: InputDecoration(
        contentPadding: AppPadding.textField,
        hint: Text(
          "상세 내용을 입력해 주세요",
          style: AppTextStyles.textMedium(textColor: AppColors.gray60),
        ),
        filled: true,
        fillColor: AppColors.gray20,
        border: OutlineInputBorder(
          borderRadius: AppRadius.baseRadius,
          borderSide: BorderSide.none,
        ),
      ),
    ),
  );

  Widget _reviewCategoryList() => SizedBox(
    width: 364,
    child: Wrap(
      direction: Axis.horizontal,
      spacing: AppSpacing.s12,
      runSpacing: AppSpacing.s12,
      children: List.generate(
        ChatReviewDialog.categories.length,
        (index) => CustomTagCard(
          onTap: _tapCategory,
          tag: categoriesMap.keys.toList()[index],
          color: AppColors.gray20,
        ),
      ),
    ),
  );

  Widget _starIconList() => Row(
    mainAxisSize: MainAxisSize.min,
    children: List.generate(
      5,
      (index) => _starIcon(index),
    ),
  );

  Widget _starIcon(int index) => GestureDetector(
    onTap: () {
      _tapStar(index);
    },
    child: Obx(
      () => Image.asset(
        AppIcon.star.path,
        width: 28,
        height: 28,
        color: _controller.star.value > index
            ? AppColors.primary
            : AppColors.gray50,
      ),
    ),
  );
}
