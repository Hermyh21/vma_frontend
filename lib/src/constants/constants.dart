import 'package:flutter/material.dart';

// const kPrimaryBaseUrl = "http://localhost:8000";
class Constants {
  static String uri = 'http://localhost:4000';
  static final MaterialColor customColor = MaterialColor(
    0xFF191970,
    <int, Color>{
      50: Color(0xFFE0E0F0),
      100: Color(0xFFB3B3D1),
      200: Color(0xFF8585B3),
      300: Color(0xFF585882),
      400: Color(0xFF3D3D6E),
      500: Color(0xFF222255),
      600: Color(0xFF1E1E4D),
      700: Color(0xFF191970),
      800: Color(0xFF15153F),
      900: Color(0xFF0F0F1F),
    },
  );
}
