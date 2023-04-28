import 'package:advanced_flutter_firebase_authentication/core/constants.dart';
import 'package:advanced_flutter_firebase_authentication/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'core/helper/preload_image.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      systemStatusBarContrastEnforced: false,
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarDividerColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  // Fixed Portrait mode
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Preload background Image
  await preLoadImage(const AssetImage(BACKGROUND_ASSET));

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(builder: (_, __) {
      return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Advanced Flutter & Firebase Authentication',
        getPages: AppPages.pages,
        initialRoute: AppRoutes.SPLASH,
        theme: ThemeData(useMaterial3: true).copyWith(
          primaryColor: const Color(0xFFE58742),
          primaryColorLight: const Color(0xFFEDA53F),
        ),
      );
    });
  }
}
