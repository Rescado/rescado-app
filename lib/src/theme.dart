import 'package:flutter/material.dart';

class RescadoTheme {
  RescadoTheme._();

  static ThemeData get light => ThemeData(
        backgroundColor: const Color(0xFFFFFFFF),
        scaffoldBackgroundColor: const Color(0xFFFAFAFA),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Color(0xFFFBD45C),
        ),
        textTheme: const TextTheme(
          headline1: TextStyle(
            // for main titles at the top of a view
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
          headline2: TextStyle(
            // for big titles in an inverted color (eg. on photos)
            fontSize: 34.0,
            fontWeight: FontWeight.w900,
            color: Color(0xFFFFFFFF),
          ),
          subtitle2: TextStyle(
            // for subtitles in an inverted color (eg. on photos)
            fontSize: 14.0,
            fontWeight: FontWeight.w400,
            color: Color(0x90FFFFFF),
          ),
        ),
        fontFamily: 'M+ Rounded 1c',
      );

  static ThemeData get dark => RescadoTheme.light.copyWith(
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.purple,
        ),
        backgroundColor: Colors.black54,
      );
}
