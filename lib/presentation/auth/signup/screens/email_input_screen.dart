import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:ondo/core/design_system/app_strings.dart';
import '../../../../core/design_system/app_layout.dart';
import '../../../../core/design_system/components/custom_textfield.dart';
import '../../../../core/ui/base/base_scaffold.dart';

import '../controllers/email_controller.dart';
import '../widgets/login_back_button.dart';
import '../widgets/next_button.dart';
import '../widgets/title_text.dart';


class EmailInputScreen extends StatefulWidget {
  const EmailInputScreen({super.key});

  @override
  State<EmailInputScreen> createState() => _EmailInputScreenState();
}

class _EmailInputScreenState extends State<EmailInputScreen> {

  TextEditingController? _emailTextController;

  final EmailController _emailController = Get.put(
    EmailController(),
    permanent: false,
  );

  /// controller 초기화 이전에도 안전
  bool get _hasEmailInput =>
      _emailTextController?.text.isNotEmpty ?? false;

  @override
  void initState() {
    super.initState();
    _emailTextController = TextEditingController();
  }

  @override
  void dispose() {
    _emailTextController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BaseScaffold(
        body: Padding(
          padding: AppPadding.screenHorizontal,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildTopSection(),
              _buildNextButton(),
            ],
          ),
        ),
      ),
    );
  }

  /// -------------------------------
  /// 상단 영역
  /// -------------------------------
  Widget _buildTopSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppGap.v16,
        LoginBackButton(onTap: Get.back),
        AppGap.v36,
        TitleText.titleText(
          AppStrings.emailInputTitle,
        ),
        AppGap.v24,
        _buildEmailField(),
      ],
    );
  }

  /// -------------------------------
  /// 이메일 입력 필드
  /// -------------------------------
  Widget _buildEmailField() {
    return GetBuilder<EmailController>(
      builder: (controller) {
        return LabelTextField(
          label: '이메일',
          controller: _emailTextController!, // initState 이후 보장
          hintText: AppStrings.emailInputHint,
          keyboardType: TextInputType.emailAddress,
          errorText: controller.emailState == EmailInputState.invalid
              ? AppStrings.invalidEmailFormat
              : null,
          onChanged: (_) {
            controller.resetState();
            setState(() {}); // Next 버튼 상태 갱신
          },
        );
      },
    );
  }

  /// -------------------------------
  /// Next 버튼
  /// -------------------------------
  Widget _buildNextButton() {
    return NextButton(
      isAgreementChecked: _hasEmailInput,
      onPressed: _onNextPressed,
    );
  }

  void _onNextPressed() {
    final email = _emailTextController?.text.trim() ?? '';

    final isValid = _emailController.validateEmail(email);

    if (isValid) {
      log('이메일 통과: $email');
      // Get.to(() => const NextSignupScreen());
    }
  }
}
