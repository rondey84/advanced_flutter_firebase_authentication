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
          )
              .animate(delay: controller.pageStartAniDelay * 0.55)
              .moveX(duration: controller.pageAniDuration, begin: 0.1.sw)
              .fadeIn(duration: controller.pageAniDuration),
          SizedBox(height: 24.r),
          Obx(() {
            return CustomTextField(
              controller: controller.passwordController,
              labelText: 'Password',
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.visiblePassword,
              obscureText: controller.passwordObscure.value,
              passwordVisibilityHandler: controller.passwordVisibilityToggler,
            );
          })
              .animate(delay: controller.pageStartAniDelay * 0.8)
              .moveX(duration: controller.pageAniDuration, begin: 0.1.sw)
              .fadeIn(duration: controller.pageAniDuration),
          SizedBox(height: 12.r),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [_forgotPasswordButton()],
          ),
          SizedBox(height: 30.r),
          GetBuilder<AuthController>(
            id: controller.pageTypeSwitcherTag,
            builder: (_) => PrimaryButton(
              onTap: () {
                // Handle Login and Registration
              },
              maxHeight: 56,
              maxWidth: 0.7.sw,
              child: Text(
                controller.pageType.value.title,
                style: TextHelper.buttonTextStyle,
              ).animate(target: controller.isSignInPage ? 1 : 0).crossfade(
                  builder: (_) => Text(
                        controller.pageType.value.title,
                        style: TextHelper.buttonTextStyle,
                      )),
            ),
          )
              .animate(delay: controller.pageStartAniDelay * 1.6)
              .fadeIn(duration: controller.pageAniDuration * 0.6)
        ],
      ),
    );
  }

  Widget _forgotPasswordButton() {
    return GetBuilder<AuthController>(
            id: controller.pageTypeSwitcherTag,
            builder: (context) {
              return GestureDetector(
                // key: const ValueKey(0),
                onTap: () {
                  // Handle Forgot Password...
                },
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
            })
        .animate(delay: controller.pageStartAniDelay)
        .moveY(duration: controller.pageAniDuration, begin: 16)
        .fadeIn(duration: controller.pageAniDuration);
  }
}
