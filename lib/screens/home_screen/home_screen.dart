import 'package:advanced_flutter_firebase_authentication/core/helper/text_helper.dart';
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
    return BackgroundScaffold(
      backgroundBlur: 0,
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
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
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
              child: ElevatedGradButton(onTap: () {}, text: 'Sign Out'),
            ),
          ],
        ),
      ),
    );
  }
}
