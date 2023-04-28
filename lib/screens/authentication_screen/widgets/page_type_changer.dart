part of '../auth_screen.dart';

class _PageTypeChanger extends GetView<AuthController> {
  const _PageTypeChanger();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(
      id: controller.pageTypeSwitcherTag,
      builder: (_) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // flutter_animate.crossfade doesn't properly animates the width
            AnimatedCrossFade(
              firstChild: Text(
                "Don't have an account?",
                style: TextHelper.pageSwitcherTextStyle,
              ),
              secondChild: Text(
                'Already have an account?',
                style: TextHelper.pageSwitcherTextStyle,
              ),
              crossFadeState: controller.isSignInPage
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
              duration: controller.pageSwitchDuration,
            ),
            const SizedBox(width: 6),
            GestureDetector(
              onTap: controller.switchPageType,
              child: Container(
                color: Colors.white.withOpacity(0.001),
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 4,
                ),
                child: AnimatedCrossFade(
                  firstChild: Text(
                    'Register Now',
                    style: TextHelper.pageSwitcherTextStyle.copyWith(
                      color: Get.theme.primaryColor.withOpacity(0.6),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  secondChild: Text(
                    'Sign In',
                    style: TextHelper.pageSwitcherTextStyle.copyWith(
                      color: Get.theme.primaryColor.withOpacity(0.6),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  crossFadeState: controller.isSignInPage
                      ? CrossFadeState.showFirst
                      : CrossFadeState.showSecond,
                  duration: controller.pageSwitchDuration,
                ),
              ),
            ),
          ],
        );
      },
    )
        .animate(
            delay:
                controller.pageStartAniDelay * 1.6 + controller.pageAniDuration)
        .moveY(duration: controller.pageAniDuration, begin: 20)
        .fadeIn(duration: controller.pageAniDuration);
  }
}
