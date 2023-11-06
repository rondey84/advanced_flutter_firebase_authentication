part of '../app_services.dart';

/// Helps manage user authentication using Firebase Authentication
class AuthHelper {
  /// FirebaseAuth is the Firebase authentication object that we use to handle user authentication
  late final FirebaseAuth _auth;

  /// currentUser is an observable stream that holds the current user's authentication state
  late Rx<User?> currentUser;

  /// _isInitUserState is a flag that keeps track of whether the user's state has been initialized
  bool _isInitUserState = true;

  GoogleSignIn? googleSignIn;

  /// This is the constructor for the AuthHelper class
  AuthHelper() {
    _auth = FirebaseAuth.instance;
    currentUser = _auth.currentUser.obs;

    // Binding the currentUser stream to the userChanges stream from FirebaseAuth
    currentUser.bindStream(_auth.userChanges());
    // Listen to changes in the currentUser stream and call the _userChangesSubscription method
    ever<User?>(currentUser, _userChangesSubscription);
  }

  /// Handles changes to the user's authentication state
  Future<void> _userChangesSubscription(User? user) async {
    if (user == null) {
      // If the user is not authenticated
      _isInitUserState = true;
      // If the current screen is not the Welcome screen
      if (Get.currentRoute != AppRoutes.WELCOME) {
        // Navigate to the Welcome screen
        Get.offAllNamed(AppRoutes.WELCOME);
      }
    } else {
      // If the user is authenticated
      if (_isInitUserState) {
        _isInitUserState = false;
        // Navigate to the Home screen
        Get.offAllNamed(AppRoutes.HOME);
      }
    }
  }

  // ======= EMAIL AND PASSWORD AUTHENTICATION =======
  Future<void> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> resetPassword({required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
    } catch (e) {
      rethrow;
    }
  }

  // ======= PHONE NUMBER AUTHENTICATION =======
  Future<void> verifyPhoneNumber(
    String phoneNumber, {
    required PhoneCodeSent codeSent,
    required PhoneVerificationFailed verificationFailed,
  }) async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          // ANDROID ONLY! Sign the user in (or link) with the auto-generated credential
          await _auth.signInWithCredential(credential);
        },
        codeSent: codeSent,
        codeAutoRetrievalTimeout: (String verificationId) {
          // this.verificationId.value = verificationId;
        },
        verificationFailed: verificationFailed,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> verifyOTP(String otp, String verificationId) async {
    try {
      await _auth.signInWithCredential(
        PhoneAuthProvider.credential(
          verificationId: verificationId,
          smsCode: otp,
        ),
      );
    } catch (e) {
      rethrow;
    }
  }

  // ======= GOOGLE AUTHENTICATION =======
  Future<void> signInWithGoogle() async {
    googleSignIn ??= GoogleSignIn(scopes: ['email', 'profile']);

    try {
      final GoogleSignInAccount? gUser = await googleSignIn?.signIn();
      final GoogleSignInAuthentication? gAuth = await gUser?.authentication;
      // Get the google auth credentials
      final credential = GoogleAuthProvider.credential(
        accessToken: gAuth?.accessToken,
        idToken: gAuth?.idToken,
      );

      await _auth.signInWithCredential(credential);
    } catch (e) {
      googleSignIn?.signOut();
      rethrow;
    }
  }

  Future<void> signInWithFacebook() async {
    try {
      // Trigger the sign-in flow
      final loginResult = await FacebookAuth.instance.login(
        loginBehavior: LoginBehavior.nativeWithFallback,
      );

      // Create a credential from the access token
      final facebookAuthCredential = FacebookAuthProvider.credential(
        loginResult.accessToken!.token,
      );

      // Once signed in, return the UserCredential
      FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
    } catch (e) {
      rethrow;
    }
  }

  // ======== SIGN OUT =========
  Future<void> signOut([User? oldUser]) async {
    // Old user used for forcefully logging out a google/apple provider user.
    try {
      final signInProvider =
          (oldUser ?? currentUser.value)?.providerData.first.providerId;
      if (signInProvider == null) return;

      print('SIGN IN PROVIDER: $signInProvider');

      if (signInProvider == AuthMethod.google.signInProvider) {
        googleSignIn ??= GoogleSignIn();
        // IMPORTANT: Google SignOut Required to show the interactive popup again else it will automatically log me in with the same account 😅
        googleSignIn?.signOut();
      } else if (signInProvider == AuthMethod.facebook.signInProvider) {
        await FacebookAuth.instance.logOut();
      }
    } finally {
      // Providers sign-out not required for native sign-in's (email/password and phone)
      await _auth.signOut();
    }
  }
}
