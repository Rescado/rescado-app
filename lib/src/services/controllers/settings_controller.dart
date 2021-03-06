import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rescado/src/data/custom_theme.dart';
import 'package:rescado/src/data/models/settings.dart';
import 'package:rescado/src/services/providers/device_storage.dart';
import 'package:rescado/src/utils/logger.dart';

final settingsControllerProvider = StateNotifierProvider<SettingsController, Settings>(
  (ref) => SettingsController(ref.read).._initialize(),
);

// Controller to manage the user's app preferences.
class SettingsController extends StateNotifier<Settings> {
  static final _logger = addLogger('SettingsController');

  final Reader _read;

  SettingsController(this._read) : super(Settings());

  void _initialize() async {
    _logger.d('initialize()');

    // Fetch the user's UI preferences
    final futures = await Future.wait([
      _read(deviceStorageProvider).getThemeMode(),
      _read(deviceStorageProvider).getLightThemeIdentifier(),
      _read(deviceStorageProvider).getDarkThemeIdentifier(),
    ]);

    // Do nothing if the user has no preferences
    if (futures.every((preference) => preference == null)) {
      return;
    }

    state = Settings(
      themeMode: futures[0] as ThemeMode?,
      lightThemeIdentifier: futures[1] as CustomThemeIdentifier?,
      darkThemeIdentifier: futures[2] as CustomThemeIdentifier?,
    );

    // Correct status bar colors
    _correctStatusBarColors();
  }

  void setThemeMode(ThemeMode themeMode) {
    _logger.d('setThemeMode()');

    if (themeMode == state.themeMode) {
      // If the change is a lie, do nothing.
      return;
    }
    _read(deviceStorageProvider).saveThemeMode(themeMode);
    _correctStatusBarColors();

    state = state.copyWith(
      themeMode: themeMode,
    );
  }

  void setLightTheme(CustomThemeIdentifier lightThemeIdentifier) {
    _logger.d('setLightTheme()');

    if (lightThemeIdentifier == state.lightTheme.identifier) {
      // If the change is a lie, do nothing.
      return;
    }
    _read(deviceStorageProvider).saveLightThemeIdentifier(lightThemeIdentifier);

    state = state.copyWith(
      lightThemeIdentifier: lightThemeIdentifier,
    );
  }

  void setDarkTheme(CustomThemeIdentifier darkThemeIdentifier) {
    _logger.d('setDarkTheme()');

    if (darkThemeIdentifier == state.darkTheme.identifier) {
      // If the change is a lie, do nothing.
      return;
    }
    _read(deviceStorageProvider).saveLightThemeIdentifier(darkThemeIdentifier);

    state = state.copyWith(
      lightThemeIdentifier: darkThemeIdentifier,
    );
  }

  void invertStatusBarColors() {
    _logger.d('invertStatusBarColors()');

    state = state.copyWith(
      invertedStatusBar: true,
    );
    _correctStatusBarColors();
  }

  void resetStatusBarColors() {
    _logger.d('resetStatusBarColors()');

    state = state.copyWith(
      invertedStatusBar: false,
    );
    _correctStatusBarColors();
  }

  void _correctStatusBarColors() {
    if (state.invertedStatusBar) {
      SystemChrome.setSystemUIOverlayStyle(state.activeTheme.brightness == Brightness.light ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark);
    } else {
      SystemChrome.setSystemUIOverlayStyle(state.activeTheme.brightness == Brightness.light ? SystemUiOverlayStyle.dark : SystemUiOverlayStyle.light);
    }
  }
}
