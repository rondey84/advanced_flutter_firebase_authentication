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
            onTap: () {},
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
            onTap: () {},
            child: FaIcon(
              FontAwesomeIcons.apple,
              color: Colors.white.withOpacity(0.7),
              size: 24,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: SecondaryButton(
            maxHeight: 48,
            onTap: () {},
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
}
