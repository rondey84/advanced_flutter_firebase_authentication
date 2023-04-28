import 'dart:ui';

import 'package:advanced_flutter_firebase_authentication/core/constants.dart';
import 'package:advanced_flutter_firebase_authentication/core/helper/text_helper.dart';
import 'package:advanced_flutter_firebase_authentication/routes/app_pages.dart';
import 'package:advanced_flutter_firebase_authentication/widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../widgets/background_scaffold.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  // =========== ANIMATIONS ============
  // Animation Durations
  static final _welcomeAniDuration = 600.ms;
  Duration get _modalAniDelay {
    return _welcomeAniDuration * 0.8;
  }

  Duration get _modalContentDelay {
    return _welcomeAniDuration * 0.8 * 2;
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundScaffold(
      backgroundBlur: 0.0,
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Align(
                alignment: const Alignment(0, 0.085),
                child: Hero(
                  tag: DISPLAY_HERO_TAG,
                  child: Text(
                    'Welcome',
                    style: TextHelper.displayTextStyle,
                    textAlign: TextAlign.center,
                  ),
                )
                    .animate()
                    .moveY(
                      begin: TextHelper.textSize(
                            'Welcome',
                            TextHelper.displayTextStyle,
                          ).height *
                          0.7,
                      duration: _welcomeAniDuration,
                    )
                    .fadeIn(begin: 0.0, duration: _welcomeAniDuration),
              ),
            ),
            Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(32),
                ),
                border: Border.all(
                  width: 1,
                  color: Colors.black.withOpacity(0.2),
                  strokeAlign: BorderSide.strokeAlignOutside,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Get.theme.primaryColor.withOpacity(0.07),
                    blurRadius: 20,
                    blurStyle: BlurStyle.outer,
                  ),
                ],
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 8.0,
                  sigmaY: 8.0,
                ),
                child: Container(
                  width: 1.sw,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.4),
                  ),
                  padding: const EdgeInsets.fromLTRB(12, 32, 12, 42),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Get Started',
                        style: TextHelper.headerTextStyle,
                      )
                          .animate(delay: _modalContentDelay)
                          .fadeIn(
                            duration: _welcomeAniDuration * 0.68,
                          )
                          .moveY(
                            begin: 50,
                            duration: _welcomeAniDuration * 0.68,
                          ),
                      const SizedBox(height: 30),
                      Row(
                        children: [
                          Expanded(
                            child: PrimaryButton(
                              onTap: () {
                                Get.offAllNamed(
                                  AppRoutes.AUTH,
                                  arguments: 'Sign In',
                                );
                              },
                              text: 'Sign In',
                            ),
                          )
                              .animate(delay: _modalContentDelay)
                              .fadeIn(
                                duration: _welcomeAniDuration * 0.68,
                              )
                              .moveY(
                                begin: 30,
                                duration: _welcomeAniDuration * 0.68,
                              ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: SecondaryButton(
                              onTap: () {
                                Get.offAllNamed(
                                  AppRoutes.AUTH,
                                  arguments: 'Sign Up',
                                );
                              },
                              text: 'Sign Up',
                            ),
                          )
                              .animate(
                                delay: _modalContentDelay * 1.1,
                              )
                              .fadeIn(
                                duration: _welcomeAniDuration * 0.68,
                              )
                              .moveY(
                                begin: 30,
                                duration: _welcomeAniDuration * 0.68,
                              ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      Text(
                        'By sign in or sign up you agree to accept our\nterms and conditions',
                        textAlign: TextAlign.center,
                        style: TextHelper.captionTextStyle.copyWith(
                          fontStyle: FontStyle.italic,
                        ),
                      ).animate(delay: _modalContentDelay * 1.2).fadeIn(),
                    ],
                  ),
                ),
              ),
            )
                .animate(
                  delay: _modalAniDelay,
                )
                .moveY(
                  duration: _welcomeAniDuration,
                  begin: 300,
                  end: 0,
                ),
          ],
        ),
      ),
    );
  }
}
