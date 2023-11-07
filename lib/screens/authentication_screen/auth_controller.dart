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
      (_) {
        emailErrorMessage.value = passwordErrorMessage.value = null;
        update([pageTypeSwitcherTag]);
      },
      time: pageSwitchDuration,
    );

    ever(emailAuthState, (_) => update([authStateTag]));
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

  // ======== NATIVE AUTHENTICATION ========
  // ------- Email Pass Auth Properties-------
  final emailAuthState = _AuthState.initialized.obs;
  bool get isEmailAuthInProgress {
    return emailAuthState.value == _AuthState.inProgress;
  }

  bool get isEmailAuthInProgressOrComplete {
    return isEmailAuthInProgress || emailAuthState.value == _AuthState.complete;
  }

  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordObscure = true.obs;
  final emailErrorMessage = RxnString();
  final passwordErrorMessage = RxnString();

  // ------- Reset Password Properties--------
  final resetFormKey = GlobalKey<FormState>();
  final resetEmailController = TextEditingController();
  final resetEmailErrorMessage = RxnString();

  // ------- Phone Auth Properties---------
  final phoneAuthState = _AuthState.initialized.obs;
  bool get isPhoneAuthInProgress {
    return phoneAuthState.value == _AuthState.inProgress;
  }

  bool get isPhoneAuthInProgressOrComplete {
    return isPhoneAuthInProgress || phoneAuthState.value == _AuthState.complete;
  }

  final isOTPMode = false.obs;
  final phoneNumberFormKey = GlobalKey<FormState>();
  final phoneNumberController = TextEditingController();
  final phoneAuthErrorMessage = RxnString();
  final countryCode = '91'.obs;
  String? _verificationId;

  // ------ Native Helper METHOD --------
  void _resetErrorMessages() {
    emailErrorMessage.value = null;
    passwordErrorMessage.value = null;
    resetEmailErrorMessage.value = null;
    phoneAuthErrorMessage.value = null;
  }

  // ------ Email Auth Methods --------
  void passwordVisibilityToggler() {
    passwordObscure.value = !passwordObscure.value;
  }

  Future<void> emailPassOnSubmitHandler() async {
    if (isEmailAuthInProgressOrComplete) return;
    emailAuthState.value = _AuthState.inProgress;

    if (!formKey.currentState!.validate()) {
      emailAuthState.value = _AuthState.initialized;
      debugPrint('Email Validation Failed');
      return;
    }

    _resetErrorMessages();

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
      emailAuthState.value = _AuthState.complete;
    } on FirebaseAuthException catch (e) {
      _resetErrorMessages();
      emailAuthState.value = _AuthState.initialized;
      debugPrint(e.toString());

      if (e.code == 'email-already-in-use') {
        emailErrorMessage.value = 'Email already registered.';
      }
      if (e.code == 'wrong-password') {
        passwordErrorMessage.value = 'Invalid password.';
      }
      // TODO: Show Toast with error message
    } catch (e) {
      emailAuthState.value = _AuthState.initialized;
      debugPrint(e.toString());
    }
  }

  // ------ Forgot Pass Method --------
  Future<void> resetPassword() async {
    if (!resetFormKey.currentState!.validate()) {
      debugPrint('Reset Email Local Validation Failed');
    }

    _resetErrorMessages();

    try {
      await authService.resetPassword(email: resetEmailController.text);
      Get.customSnackBar(
        statusType: StatusType.success,
        designType: SnackDesign.line,
        title: 'Reset email sent successfully.',
        compact: true,
      );
      Get.close(1);
    } on FirebaseAuthException catch (e) {
      _resetErrorMessages();
      debugPrint(e.toString());

      if (e.code == 'user-not-found') {
        resetEmailErrorMessage.value = 'Please register first with the user.';
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  // ------ Phone Auth Methods--------
  Future<void> phoneAuthOnSubmitHandler(String value) async {
    if (isPhoneAuthInProgressOrComplete) return;
    phoneAuthState.value = _AuthState.inProgress;

    if (!phoneNumberFormKey.currentState!.validate()) {
      phoneAuthState.value = _AuthState.initialized;
      debugPrint('${isOTPMode.value ? 'OTP' : 'Phone'} Validation Failed');
      return;
    }

    _resetErrorMessages();

    if (isOTPMode.value && _verificationId != null) {
      await verifyOTP(value);
      return;
    } else if (!isOTPMode.value) {
      await verifyPhoneNumber();
    }
  }

  Future<void> verifyPhoneNumber() async {
    final phoneNumber = '+${countryCode.value} ${phoneNumberController.text}';

    try {
      await authService.verifyPhoneNumber(
        phoneNumber,
        codeSent: (verificationId, forceResendingToken) {
          // Move to OTP verification
          isOTPMode.value = true;
          _verificationId = verificationId;
          // This is not `complete` state because we will use the same state for OTP.
          phoneAuthState.value = _AuthState.initialized;
        },
        verificationFailed: (FirebaseAuthException e) {
          if (e.code == 'invalid-phone-number') {
            phoneAuthErrorMessage.value = 'Invalid Phone Number';
          } else if (e.code == 'too-many-requests') {
            Get.customSnackBar(
              statusType: StatusType.error,
              compact: true,
              designType: SnackDesign.line,
              title: 'Too Many Requests',
            );
          } else {
            Get.customSnackBar(
              statusType: StatusType.error,
              designType: SnackDesign.line,
              title: 'Server Error',
              message: 'Something went wrong. Try again or contact support.',
            );
          }
          phoneAuthState.value = _AuthState.initialized;
          _verificationId = null;
          debugPrint('Verification error: $e');
        },
      );
    } catch (e) {
      phoneAuthState.value = _AuthState.initialized;
      _verificationId = null;
      debugPrint('Phone Number error: $e');
      Get.customSnackBar(
        statusType: StatusType.error,
        designType: SnackDesign.line,
        title: 'Unknown Error',
        message: 'Please check your network and try again.',
      );
    }
  }

  Future<void> verifyOTP(String otp) async {
    try {
      if (_verificationId == null) {
        throw Exception('Verification Id Not Set');
      }

      await authService.verifyOTP(otp, _verificationId!);
      phoneAuthState.value = _AuthState.complete;
    } on FirebaseAuthException catch (e) {
      _resetErrorMessages();
      phoneAuthState.value = _AuthState.initialized;
      debugPrint(e.toString());

      if (e.code == 'invalid-verification-code') {
        phoneAuthErrorMessage.value = 'Incorrect code.';
      } else {
        Get.customSnackBar(
          statusType: StatusType.error,
          designType: SnackDesign.line,
          title: 'Server Error',
          message: 'Something went wrong. Try again or contact support.',
        );
      }
    } catch (e) {
      phoneAuthState.value = _AuthState.initialized;
      debugPrint('Phone Number error: $e');
      Get.customSnackBar(
        statusType: StatusType.error,
        designType: SnackDesign.line,
        title: 'Unknown Error',
        message: 'Please check your network and try again.',
      );
    }
  }

  void editButtonOnTap() {
    if (isPhoneAuthInProgressOrComplete) {
      return;
    }
    isOTPMode.value = false;
    phoneAuthErrorMessage.value = null;
    phoneAuthState.value = _AuthState.initialized;
    _verificationId = null;
  }

  // ------ Local Validation --------
  String? emailValidation(
    String? value, {
    bool isResetEmailValidation = false,
  }) {
    if (value == null || value.isEmpty) {
      isResetEmailValidation
          ? resetEmailErrorMessage.value = 'Please enter an email.'
          : emailErrorMessage.value = 'Please enter an email.';
      return isResetEmailValidation
          ? resetEmailErrorMessage.value
          : emailErrorMessage.value;
    }

    const String emailPattern = r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+';
    final RegExp emailRegex = RegExp(emailPattern);

    if (!emailRegex.hasMatch(value)) {
      isResetEmailValidation
          ? resetEmailErrorMessage.value = 'Please enter a valid email address.'
          : emailErrorMessage.value = 'Please enter a valid email address.';
      return isResetEmailValidation
          ? resetEmailErrorMessage.value
          : emailErrorMessage.value;
    }

    resetEmailErrorMessage.value = null;
    emailErrorMessage.value = null;
    return null;
  }

  String? passwordValidation(String? value) {
    if (value == null || value.isEmpty) {
      passwordErrorMessage.value = 'Please enter a password';
      return passwordErrorMessage.value;
    }
    passwordErrorMessage.value = null;
    return passwordErrorMessage.value;
  }

  String? phoneValidation(String? value) {
    if (value == null || value.isEmpty) {
      phoneAuthErrorMessage.value = 'Please enter a phone number';
      return phoneAuthErrorMessage.value;
    }

    const String numericPattern = r'^-?[0-9]+$';
    final RegExp numericRegex = RegExp(numericPattern);

    if (!numericRegex.hasMatch(value)) {
      phoneAuthErrorMessage.value = 'Please enter a valid phone number.';
      return phoneAuthErrorMessage.value;
    }

    if (value.length != 10) {
      phoneAuthErrorMessage.value = 'Please enter 10 digit phone number.';
      return phoneAuthErrorMessage.value;
    }

    phoneAuthErrorMessage.value = null;
    return null;
  }

  String? otpValidationHandler(String? value) {
    if (value == null || value.isEmpty) {
      phoneAuthErrorMessage.value = 'Please enter the OTP.';
      return phoneAuthErrorMessage.value;
    } else {
      const String otpPattern = r'^\d+$';
      final RegExp otpRegex = RegExp(otpPattern);
      if (!otpRegex.hasMatch(value)) {
        phoneAuthErrorMessage.value = 'OTP should contain only numbers.';
        return phoneAuthErrorMessage.value;
      }

      if (value.length != 6) {
        phoneAuthErrorMessage.value = 'Please enter a 6-digit code.';
        return phoneAuthErrorMessage.value;
      }
    }

    phoneAuthErrorMessage.value = null;
    return phoneAuthErrorMessage.value;
  }

  // ========== GOOGLE SIGN IN ==========
  Future<void> googleSignInHandler() async {
    if (isEmailAuthInProgressOrComplete) return;
    emailAuthState.value = _AuthState.inProgress;

    try {
      // Google Sign In
      await authService.signInWithGoogle();
      emailAuthState.value = _AuthState.complete;
    } on PlatformException catch (e) {
      emailAuthState.value = _AuthState.initialized;
      debugPrint(e.toString());
      Get.customSnackBar(
        statusType: StatusType.error,
        designType: SnackDesign.line,
        title: 'Please check your connectivity and try again later.',
        compact: true,
      );
    } on FirebaseAuthException catch (e) {
      emailAuthState.value = _AuthState.initialized;
      debugPrint(e.toString());
      // TODO: Show proper message for each error tokens
      Get.customSnackBar(
        statusType: StatusType.error,
        designType: SnackDesign.line,
        title: e.message,
        compact: true,
      );
    } catch (e) {
      emailAuthState.value = _AuthState.initialized;
      debugPrint(e.toString());
    }
  }

  // ========== FACEBOOK SIGN IN ==========
  Future<void> facebookSignInHandler() async {
    if (isEmailAuthInProgressOrComplete) return;
    emailAuthState.value = _AuthState.inProgress;

    try {
      // Google Sign In
      await authService.signInWithFacebook();
      emailAuthState.value = _AuthState.complete;
    } on PlatformException catch (e) {
      emailAuthState.value = _AuthState.initialized;
      debugPrint(e.toString());
      Get.customSnackBar(
        statusType: StatusType.error,
        designType: SnackDesign.line,
        title: 'Please check your connectivity and try again later.',
        compact: true,
      );
    } on FirebaseAuthException catch (e) {
      emailAuthState.value = _AuthState.initialized;
      debugPrint(e.toString());
      // TODO: Show proper message for each error tokens
      Get.customSnackBar(
        statusType: StatusType.error,
        designType: SnackDesign.line,
        title: e.message,
        compact: true,
      );
    } catch (e) {
      emailAuthState.value = _AuthState.initialized;
      debugPrint(e.toString());
    }
  }
}
