part of 'auth_screen.dart';

class AuthController extends GetxController {
  final authService = AppServices.instance.authHelper;

  // ===== GetBuilder Tags ======
  final pageTypeSwitcherTag = 'page-type-switcher';
  final authStateTag = 'auth-state';

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

    ever(authState, (_) => update([authStateTag]));
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

  // ====== Page State Handler =====
  final authState = _AuthState.initialized.obs;
  bool get isAuthInProgress {
    return authState.value == _AuthState.inProgress;
  }

  bool get isAuthInProgressOrComplete {
    return isAuthInProgress || authState.value == _AuthState.inProgress;
  }

  // ====== ANIMATION =========
  final pageStartAniDelay = 600.ms;
  final pageAniDuration = 400.ms;
  final pageSwitchDuration = 275.ms;

  // ======== NATIVE AUTHENTICATION ========
  final formKey = GlobalKey<FormState>();
  final phoneNumberController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordObscure = true.obs;

  void passwordVisibilityToggler() {
    passwordObscure.value = !passwordObscure.value;
  }

  Future<void> emailPassOnSubmitHandler() async {
    if (isAuthInProgressOrComplete) return;
    authState.value = _AuthState.inProgress;

    if (!formKey.currentState!.validate()) {
      authState.value = _AuthState.initialized;
      debugPrint('Local Validation Failed');
      // TODO: Show Toast with error message
      return;
    }

    try {
      if (isSignInPage) {
        await authService.signInWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
      } else {
        await authService.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
      }
      authState.value = _AuthState.complete;
    } on FirebaseAuthException catch (e) {
      authState.value = _AuthState.initialized;
      debugPrint(e.toString());
      // TODO: Show Toast with error message
    } catch (e) {
      authState.value = _AuthState.initialized;
      debugPrint(e.toString());
    }
  }

  // ------ Local Validation --------
  String? emailValidation(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a email';
    }
    return null;
  }

  String? passwordValidation(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }
    return null;
  }

  String? phoneValidation(String? value) {
    return null;
  }

  // ========== GOOGLE SIGN IN ==========
  Future<void> googleSignInHandler() async {
    if (isAuthInProgressOrComplete) return;
    authState.value = _AuthState.inProgress;

    try {
      // Google Sign In
      await authService.signInWithGoogle();
      authState.value = _AuthState.complete;
    } on PlatformException catch (e) {
      authState.value = _AuthState.initialized;
      debugPrint(e.toString());
      // TODO: Show Toast with error message
    } on FirebaseAuthException catch (e) {
      authState.value = _AuthState.initialized;
      debugPrint(e.toString());
      // TODO: Show Toast with error message
    } catch (e) {
      authState.value = _AuthState.initialized;
      debugPrint(e.toString());
    }
  }

  // ========== FACEBOOK SIGN IN ==========
  Future<void> facebookSignInHandler() async {
    if (isAuthInProgressOrComplete) return;
    authState.value = _AuthState.inProgress;

    try {
      // Google Sign In
      await authService.signInWithFacebook();
      authState.value = _AuthState.complete;
    } on PlatformException catch (e) {
      authState.value = _AuthState.initialized;
      debugPrint(e.toString());
      // TODO: Show Toast with error message
    } on FirebaseAuthException catch (e) {
      authState.value = _AuthState.initialized;
      debugPrint(e.toString());
      // TODO: Show Toast with error message
    } catch (e) {
      authState.value = _AuthState.initialized;
      debugPrint(e.toString());
    }
  }
}
