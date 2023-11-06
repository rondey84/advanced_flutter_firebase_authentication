part of '../auth_screen.dart';

class _EmailAndPasswordAuthForm extends GetView<AuthController> {
  const _EmailAndPasswordAuthForm();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller.formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomTextField(
            controller: controller.emailController,
            labelText: 'Email',
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.emailAddress,
            validator: controller.emailValidation,
          )
              .animate(delay: controller.pageStartAniDelay * 0.55)
              .moveX(duration: controller.pageAniDuration, begin: 0.1.sw)
              .fadeIn(duration: controller.pageAniDuration),
          SizedBox(height: 2.r),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12).r,
              child: ObxValue((emailErrorMsg) {
                return Text(
                  emailErrorMsg.value ?? '',
                  style: TextHelper.captionTextStyle.copyWith(
                    color: Colors.redAccent,
                    fontWeight: FontWeight.w700,
                  ),
                );
              }, controller.emailErrorMessage),
            ),
          ),
          SizedBox(height: 16.r),
          Obx(() {
            return CustomTextField(
              controller: controller.passwordController,
              labelText: 'Password',
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.visiblePassword,
              obscureText: controller.passwordObscure.value,
              passwordVisibilityHandler: controller.passwordVisibilityToggler,
              validator: controller.passwordValidation,
            );
          })
              .animate(delay: controller.pageStartAniDelay * 0.8)
              .moveX(duration: controller.pageAniDuration, begin: 0.1.sw)
              .fadeIn(duration: controller.pageAniDuration),
          SizedBox(height: 2.r),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12).r,
              child: ObxValue((passErrorMsg) {
                return Text(
                  passErrorMsg.value ?? '',
                  style: TextHelper.captionTextStyle.copyWith(
                    color: Colors.redAccent,
                    fontWeight: FontWeight.w700,
                  ),
                );
              }, controller.passwordErrorMessage),
            ),
          ),
          SizedBox(height: 0.r),
          Align(
            alignment: Alignment.centerRight,
            child: _forgotPasswordButton(),
          ),
          SizedBox(height: 30.r),
          GetBuilder<AuthController>(
            id: controller.authStateTag,
            builder: (_) {
              return PrimaryButton(
                onTap: controller.isEmailAuthInProgress
                    ? null
                    : controller.emailPassOnSubmitHandler,
                maxHeight: 56,
                maxWidth: 0.7.sw,
                child: GetBuilder<AuthController>(
                    id: controller.pageTypeSwitcherTag,
                    builder: (_) {
                      return AnimatedSwitcher(
                        duration: controller.pageSwitchDuration,
                        child: controller.isEmailAuthInProgress
                            ? Center(
                                key: const ValueKey('loading'),
                                child: SpinKitRipple(
                                  color: TextHelper.buttonTextStyle.color,
                                ),
                              )
                            : controller.isSignInPage
                                ? Text(
                                    key: const ValueKey(0),
                                    controller.pageType.value.title,
                                    style: TextHelper.buttonTextStyle,
                                  )
                                : Text(
                                    key: const ValueKey(1),
                                    controller.pageType.value.title,
                                    style: TextHelper.buttonTextStyle,
                                  ),
                      );
                    }),
              )
                  .animate(target: controller.isEmailAuthInProgress ? 1 : 0)
                  .desaturate(duration: controller.pageSwitchDuration);
            },
          )
              .animate(delay: controller.pageStartAniDelay * 1.6)
              .fadeIn(duration: controller.pageAniDuration * 0.6),
        ],
      ),
    );
  }

  Widget _forgotPasswordButton() {
    return GetBuilder<AuthController>(
      id: controller.pageTypeSwitcherTag,
      builder: (context) {
        return GestureDetector(
          onTap: _resetPasswordDialog,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.001),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            child: Text(
              'Forgot Password?',
              style: TextHelper.forgotPassTextStyle,
            ),
          ),
        )
            .animate(target: controller.isSignInPage ? 0 : 1)
            .moveY(duration: controller.pageSwitchDuration, end: 20)
            .fadeOut(duration: controller.pageSwitchDuration)
            .swap(builder: (_, __) {
          return SizedBox(
            height: TextHelper.textSize(
                  'Forgot Password?',
                  TextHelper.forgotPassTextStyle,
                ).height +
                7.5 * 2,
          );
        });
      },
    )
        .animate(delay: controller.pageStartAniDelay)
        .moveY(duration: controller.pageAniDuration, begin: 16)
        .fadeIn(duration: controller.pageAniDuration);
  }

  void _resetPasswordDialog() {
    Get.customDialog(
      contentPadding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
      barrierLabel: 'Reset Password Dialog',
      barrierDismissible: true,
      child: Form(
        key: controller.resetFormKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Reset password',
              style: TextHelper.dialogHeaderTextStyle,
            ),
            const SizedBox(height: 30),
            CustomTextField(
              controller: controller.resetEmailController,
              hintText: 'Enter email',
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.emailAddress,
              validator: (value) => controller.emailValidation(
                value,
                isResetEmailValidation: true,
              ),
              fillColor: Colors.white.withOpacity(0.05),
              borderColor: Colors.transparent,
            ),
            const SizedBox(height: 4),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12).r,
                child: ObxValue((emailErrorMsg) {
                  return Text(
                    emailErrorMsg.value ?? '',
                    style: TextHelper.captionTextStyle.copyWith(
                      color: Colors.redAccent,
                      fontWeight: FontWeight.w700,
                    ),
                  );
                }, controller.resetEmailErrorMessage),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'An reset link will be sent to your email address for verification.',
              style: TextHelper.dialogCaptionTextStyle,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: CaptionButton(
                    onTap: () => Get.close(1),
                    maxWidth: 160,
                    text: 'Cancel',
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 4,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: PrimaryButton(
                        onTap: controller.resetPassword, text: 'Reset'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ).then((_) {
      controller.resetEmailController.clear();
      controller.resetEmailErrorMessage.value = null;
    });
  }
}
