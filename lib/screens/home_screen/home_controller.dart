part of 'home_screen.dart';

class HomeController extends GetxController {
  final authService = AppServices.instance.authHelper;

  Future<void> signOutHandler() async {
    await authService.signOut();
  }

  Future<void> testHandler() async {
    print(authService.currentUser.value?.providerData);
  }
}
