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
    final globalKey = GlobalKey<NavigatorState>();

    Get.customDialog(
      contentPadding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Enter Your Phone Number',
            style: TextHelper.dialogHeaderTextStyle,
          ),
          const SizedBox(height: 30),
          CustomTextField(
            controller: controller.phoneNumberController,
            hintText: 'Phone Number',
            textInputAction: TextInputAction.done,
            keyboardType: TextInputType.phone,
            validator: controller.phoneValidation,
            fillColor: Colors.white.withOpacity(0.05),
            borderColor: Colors.transparent,
            prefix: Padding(
              padding: const EdgeInsetsDirectional.only(end: 16),
              child: GestureDetector(
                onTap: () {},
                child: Container(
                  color: Colors.black.withOpacity(0.01),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        key: globalKey,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          '+91',
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
          ),
          const SizedBox(height: 30),
          Text(
            'An OTP will be sent to your mobile\nnumber for verification',
            style: TextHelper.dialogCaptionTextStyle,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: PrimaryButton(onTap: () {}, text: 'Continue'),
          ),
          const SizedBox(height: 18),
          CaptionButton(
            onTap: () {
              controller.phoneNumberController.clear();
              Get.close(1);
            },
            maxWidth: 160,
            text: 'Cancel',
          ),
        ],
      ),
    );
  }
}
