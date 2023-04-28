part of '../app_services.dart';

/// Helps manage user authentication using Firebase Authentication
class AuthHelper {
  /// FirebaseAuth is the Firebase authentication object that we use to handle user authentication
  late final FirebaseAuth _auth;

  /// currentUser is an observable stream that holds the current user's authentication state
  late Rx<User?> currentUser;

  /// _isInitUserState is a flag that keeps track of whether the user's state has been initialized
  bool _isInitUserState = true;

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
}
