import 'package:advanced_flutter_firebase_authentication/core/extensions/custom_dialog_extension.dart';
import 'package:advanced_flutter_firebase_authentication/core/extensions/getx_custom_snackbar.dart';
import 'package:advanced_flutter_firebase_authentication/core/helper/text_helper.dart';
import 'package:advanced_flutter_firebase_authentication/core/services/app_services.dart';
import 'package:advanced_flutter_firebase_authentication/widgets/background_scaffold.dart';
import 'package:advanced_flutter_firebase_authentication/widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

part 'home_controller.dart';
part 'home_bindings.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final globalKey = GlobalKey<NavigatorState>();
    return BackgroundScaffold(
      backgroundBlur: 0,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: null,
          icon: FaIcon(
            FontAwesomeIcons.barsStaggered,
            color: Colors.white.withOpacity(0.8),
            size: 22,
          ),
        ),
        centerTitle: true,
        title: Text('Camping', style: TextHelper.appBarTextStyle),
        actions: [
          IconButton(
            onPressed: null,
            icon: Icon(
              Icons.person_outline_rounded,
              color: Colors.white.withOpacity(0.8),
            ),
          )
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 200),
            child: ElevatedGradButton(
              key: globalKey,
              text: 'TEST',
              onTap: () async {
                // await Get.countrySelectDropDown(
                //   navigatorKey: globalKey,
                // );
                Get.customSnackBar(
                  statusType: StatusType.error,
                  designType: SnackDesign.line,
                  title: 'Reset email sent.',
                  compact: true,
                );
              },
            ),
          ),
          SizedBox(height: 20.r),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: 'Find new\nplaces\nto ',
              style: TextHelper.homeTextStyle,
              children: [
                TextSpan(
                  text: 'Camp',
                  style: TextHelper.homeTextStyle
                      .copyWith(color: Get.theme.primaryColor),
                )
              ],
            ),
          ),
          SizedBox(height: 50.r),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 200),
            child: ElevatedGradButton(
              onTap: controller.signOutHandler,
              text: 'Sign Out',
            ),
          ),
        ],
      ),
    );
  }
}
