import 'package:flutter/material.dart';

// const kPrimaryBaseUrl = "http://localhost:8000";
class Constants {
  static String uri = 'http://localhost:4000';
  static final MaterialColor customColor = const MaterialColor(
    0xFF191970,
    <int, Color>{
      50: const Color(0xFFE0E0F0),
      100: const Color(0xFFB3B3D1),
      200: const Color(0xFF8585B3),
      300: const Color(0xFF585882),
      400: const Color(0xFF3D3D6E),
      500: const Color(0xFF222255),
      600: const Color(0xFF1E1E4D),
      700: const Color(0xFF191970),
      800: const Color(0xFF15153F),
      900: const Color(0xFF0F0F1F),
    },
  );
}
