part of 'splash_screen.dart';

class SplashController extends GetxController {
  final double splashSize = 0.2.sw;

  late final AppServices appServices;

  @override
  void onInit() async {
    appServices = await Get.putAsync(() => AppServices().init());
    super.onInit();
  }

  @override
  void onReady() {
    if (appServices.initialized) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        appServices.initFirebaseServices();
      });
    }
    super.onReady();
  }
}
