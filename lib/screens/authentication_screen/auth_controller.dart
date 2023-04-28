part of 'auth_screen.dart';

class AuthController extends GetxController {
  // ===== GetBuilder Tags ======
  final pageTypeSwitcherTag = 'page-type-switcher';

  @override
  void onInit() {
    if ((Get.arguments as String) == _PageType.signUp.title) {
      pageType.value = _PageType.signUp;
    }
    _workerInit();
    super.onInit();
  }

  void _workerInit() {
    debounce(
      pageType,
      (_) => update([pageTypeSwitcherTag]),
      time: pageSwitchDuration,
    );
  }

  // ====== Page Type =======
  final pageType = _PageType.signIn.obs;
  bool get isSignInPage => pageType.value == _PageType.signIn;

  void switchPageType() {
    if (pageType.value == _PageType.signIn) {
      pageType.value = _PageType.signUp;
    } else {
      pageType.value = _PageType.signIn;
    }
  }

  // ====== ANIMATION =========
  final pageStartAniDelay = 600.ms;
  final pageAniDuration = 400.ms;
  final pageSwitchDuration = 275.ms;

  // ======== EMAIL AND PASSWORD AUTHENTICATION ========
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordObscure = true.obs;

  void passwordVisibilityToggler() {
    passwordObscure.value = !passwordObscure.value;
  }
}
