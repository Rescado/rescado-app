import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:rescado/src/constants/rescado_constants.dart';
import 'package:rescado/src/data/custom_theme.dart';

class Settings {
  late ThemeMode themeMode;
  late CustomTheme lightTheme;
  late CustomTheme darkTheme;
  late bool invertedStatusBar;

  CustomTheme get activeTheme {
    switch (themeMode) {
      case ThemeMode.light:
        return lightTheme;
      case ThemeMode.dark:
        return darkTheme;
      default:
        switch (SchedulerBinding.instance!.window.platformBrightness) {
          case Brightness.light:
            return lightTheme;
          case Brightness.dark:
            return darkTheme;
        }
    }
  }

  Settings({
    ThemeMode? themeMode,
    CustomThemeIdentifier? lightThemeIdentifier,
    CustomThemeIdentifier? darkThemeIdentifier,
    bool? invertedStatusBar,
  }) {
    this.themeMode = themeMode ?? ThemeMode.system;
    lightTheme = CustomTheme.fromId(lightThemeIdentifier ?? RescadoConstants.defaultLightTheme);
    darkTheme = CustomTheme.fromId(darkThemeIdentifier ?? RescadoConstants.defaultDarkTheme);
    this.invertedStatusBar = invertedStatusBar ?? false;
  }

  Settings copyWith({
    ThemeMode? themeMode,
    CustomThemeIdentifier? lightThemeIdentifier,
    CustomThemeIdentifier? darkThemeIdentifier,
    bool? invertedStatusBar,
  }) =>
      Settings(
        themeMode: themeMode ?? this.themeMode,
        lightThemeIdentifier: lightThemeIdentifier ?? lightTheme.identifier,
        darkThemeIdentifier: darkThemeIdentifier ?? darkTheme.identifier,
        invertedStatusBar: invertedStatusBar ?? this.invertedStatusBar,
      );
}
