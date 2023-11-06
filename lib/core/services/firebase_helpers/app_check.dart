part of '../app_services.dart';

class AppCheckHelper {
  late final FirebaseAppCheck _appCheck;

  Future<AppCheckHelper> init() async {
    _appCheck = FirebaseAppCheck.instance;

    await _appCheck.activate(
      androidProvider: AndroidProvider.debug,
    );

    return this;
  }
}
