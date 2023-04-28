import 'package:advanced_flutter_firebase_authentication/routes/app_pages.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';

part 'firebase_helpers/auth_helper.dart';

/// Contains all the app wide services related to the app.
class AppServices extends GetxService {
  static AppServices instance = Get.find();

  late final FirebaseApp firebaseApp;
  late final AuthHelper authHelper;

  Future<AppServices> init() async {
    firebaseApp = await Firebase.initializeApp();

    return this;
  }

  void initFirebaseServices() {
    authHelper = AuthHelper();
    //.... Initialize other helpers such as cloud storage or fire store database
  }
}
