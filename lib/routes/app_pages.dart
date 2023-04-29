import 'package:get/get.dart';

import '../screens/splash_screen/splash_screen.dart';
import '../screens/home_screen/home_screen.dart';
import '../screens/welcome_screen/welcome_screen.dart';
import '../screens/authentication_screen/auth_screen.dart';

part 'app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.SPLASH,
      page: () => const SplashScreen(),
      binding: SplashBindings(),
      preventDuplicates: true,
      transition: Transition.fade,
    ),
    GetPage(
      name: AppRoutes.WELCOME,
      page: () => const WelcomeScreen(),
      preventDuplicates: true,
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.AUTH,
      page: () => const AuthScreen(),
      binding: AuthBindings(),
      preventDuplicates: true,
      transition: Transition.fadeIn,
      transitionDuration: 600.milliseconds,
    ),
    GetPage(
      name: AppRoutes.HOME,
      page: () => const HomeScreen(),
      binding: HomeBindings(),
      preventDuplicates: true,
      transition: Transition.fadeIn,
      transitionDuration: 400.milliseconds,
    ),
  ];
}
