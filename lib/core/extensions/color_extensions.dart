import 'package:flutter/material.dart';

extension ColorParsing on Color {
  String toRGBACode() {
    return 'rgba($red,$green,$blue,$opacity)';
  }
}
