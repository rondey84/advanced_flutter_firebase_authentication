part of '../auth_screen.dart';

class _FederatedLogins extends GetView<AuthController> {
  const _FederatedLogins();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: SecondaryButton(
            maxHeight: 48,
            onTap: _phoneSignInDialog,
            child: FaIcon(
              FontAwesomeIcons.phone,
              color: Colors.white.withOpacity(0.7),
              size: 24,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: SecondaryButton(
            maxHeight: 48,
            onTap: controller.googleSignInHandler,
            child: FaIcon(
              FontAwesomeIcons.google,
              color: Colors.white.withOpacity(0.7),
              size: 24,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: SecondaryButton(
            maxHeight: 48,
            onTap: controller.facebookSignInHandler,
            child: FaIcon(
              FontAwesomeIcons.facebook,
              color: Colors.white.withOpacity(0.7),
              size: 24,
            ),
          ),
        ),
      ]
          .animate(
            delay: controller.pageStartAniDelay * 1.6 +
                controller.pageAniDuration * 0.5,
            interval: controller.pageAniDuration * 0.2,
          )
          .moveY(duration: controller.pageAniDuration * 0.5)
          .fade(duration: controller.pageAniDuration * 0.5),
    );
  }

  void _phoneSignInDialog() {
    // final globalKey = GlobalKey<NavigatorState>();

    Get.customDialog(
      contentPadding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
      child: Form(
        key: controller.phoneNumberFormKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Obx(() {
              return Text(
                controller.isOTPMode.value
                    ? 'Enter OTP'
                    : 'Enter Your Phone Number',
                style: TextHelper.dialogHeaderTextStyle,
              )
                  .animate(target: controller.isOTPMode.value ? 0 : 1)
                  .shake(duration: controller.pageSwitchDuration);
            }),
            const SizedBox(height: 30),
            Obx(() {
              if (controller.isOTPMode.value) {
                return _buildPinInput();
              }
              return CustomTextField(
                controller: controller.phoneNumberController,
                hintText: 'Phone Number',
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.phone,
                maxLength: 10,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                validator: controller.phoneValidation,
                fillColor: Colors.white.withOpacity(0.05),
                borderColor: Colors.transparent,
                prefix: Padding(
                  padding: const EdgeInsetsDirectional.only(end: 16),
                  child: GestureDetector(
                    onTap: () {
                      // TODO: country code switcher
                    },
                    child: Container(
                      color: Colors.black.withOpacity(0.01),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            // key: globalKey,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              '+${controller.countryCode}',
                              style: TextHelper.textFieldTextStyle,
                            ),
                          ),
                          Container(
                            height: TextHelper.textSize(
                              '+',
                              TextHelper.textFieldTextStyle,
                            ).height,
                            width: 1,
                            color: Colors.white.withOpacity(0.16),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
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
                }, controller.phoneAuthErrorMessage),
              ),
            ),
            const SizedBox(height: 24),
            Obx(() {
              return Row(
                children: [
                  const SizedBox(width: 32),
                  Expanded(
                    child: Text(
                      controller.isOTPMode.value
                          ? 'A OTP has been sent to\n'
                              '+${controller.countryCode.value} ${controller.phoneNumberController.text}'
                          : 'An OTP will be sent to your mobile\nnumber for verification',
                      style: TextHelper.dialogCaptionTextStyle,
                      textAlign: TextAlign.center,
                    )
                        .animate()
                        .fade(duration: controller.pageSwitchDuration)
                        .moveY(begin: -10),
                  ),
                  if (controller.isOTPMode.value)
                    CircularIconButton(
                      onTap: controller.editButtonOnTap,
                      icon: Icons.edit_rounded,
                    )
                        .animate()
                        .fade(duration: controller.pageSwitchDuration)
                        .moveX(begin: 10)
                  else
                    const SizedBox(width: 32),
                ],
              );
            }),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: PrimaryButton(
                onTap: () => controller.phoneAuthOnSubmitHandler(''),
                // text: '${controller.isOTPMode.value ? 'Verify' : 'Send'} OTP',
                child: Obx(() {
                  return AnimatedSwitcher(
                    duration: controller.pageSwitchDuration,
                    child: controller.isPhoneAuthInProgress
                        ? Center(
                            key: const ValueKey('loading'),
                            child: SpinKitRipple(
                              color: TextHelper.buttonTextStyle.color,
                            ),
                          )
                        : controller.isOTPMode.value
                            ? Text(
                                key: const ValueKey(1),
                                'Verify OTP',
                                style: TextHelper.buttonTextStyle,
                              )
                            : Text(
                                key: const ValueKey(0),
                                'Send OTP',
                                style: TextHelper.buttonTextStyle,
                              ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 18),
            CaptionButton(
              onTap: () => Get.close(1),
              maxWidth: 160,
              text: 'Cancel',
            ),
          ],
        ),
      ),
    ).then((_) {
      controller.isOTPMode.value = false;
      controller.phoneNumberController.clear();
      controller.phoneAuthErrorMessage.value = null;
      controller.phoneAuthState.value = _AuthState.initialized;
    });
  }

  Widget _buildPinInput() {
    final defaultPinTheme = PinTheme(
      height: 42,
      width: 42,
      textStyle: TextHelper.textFieldTextStyle,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(14),
      ),
    );

    return Pinput(
      length: 6,
      autofocus: true,
      validator: controller.otpValidationHandler,
      onCompleted: controller.phoneAuthOnSubmitHandler,
      onSubmitted: controller.phoneAuthOnSubmitHandler,
      defaultPinTheme: defaultPinTheme,
      errorBuilder: (errorText, pin) {
        return const SizedBox.shrink();
      },
      errorText: null,
      errorTextStyle: const TextStyle(color: Colors.transparent, fontSize: 0),
      focusedPinTheme: defaultPinTheme.copyWith(
        decoration: defaultPinTheme.decoration!.copyWith(
          border: Border.all(
            color: Colors.teal.shade300.withOpacity(0.2),
          ),
        ),
      ),
      errorPinTheme: defaultPinTheme.copyWith(
          decoration: defaultPinTheme.decoration!.copyWith(
        border: Border.all(
          color: Colors.red.withOpacity(0.5),
        ),
      )),
    );
  }
}
