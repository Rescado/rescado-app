import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rescado/src/data/custom_theme.dart';
import 'package:rescado/src/data/models/api_token.dart';
import 'package:rescado/src/utils/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

final deviceStorageProvider = Provider<DeviceStorage>(
  (ref) => DeviceStorage._(),
);

class DeviceStorage {
  static final _logger = addLogger('DeviceStorage');

  DeviceStorage._();

  /* region themeMode */

  final _themeModeKey = 'themeMode';
  ThemeMode? _themeModeCache;

  Future<ThemeMode?> getThemeMode() async {
    _logger.d('getThemeMode()');

    if (_themeModeCache == null) {
      String? themeMode = (await SharedPreferences.getInstance()).getString(_themeModeKey);
      _themeModeCache = themeMode == null ? null : ThemeMode.values.byName(themeMode);
    }
    return _themeModeCache;
  }

  void saveThemeMode(ThemeMode? themeMode) async {
    _logger.d('saveThemeMode()');

    _themeModeCache = themeMode;
    final sharedPreferences = await SharedPreferences.getInstance();
    if (themeMode == null) {
      sharedPreferences.remove(_themeModeKey);
    } else {
      sharedPreferences.setString(_themeModeKey, themeMode.name);
    }
  }

  /* endregion */
  /* region lightThemeIdentifier */

  final _lightThemeIdentifierKey = 'lightThemeIdentifier';
  CustomThemeIdentifier? _lightThemeIdentifierCache;

  Future<CustomThemeIdentifier?> getLightThemeIdentifier() async {
    _logger.d('getLightThemeIdentifier()');

    if (_lightThemeIdentifierCache == null) {
      String? lightThemeIdentifier = (await SharedPreferences.getInstance()).getString(_lightThemeIdentifierKey);
      _lightThemeIdentifierCache = lightThemeIdentifier == null ? null : CustomThemeIdentifier.values.byName(lightThemeIdentifier);
    }
    return _lightThemeIdentifierCache;
  }

  void saveLightThemeIdentifier(CustomThemeIdentifier? lightThemeIdentifier) async {
    _logger.d('saveLightThemeIdentifier()');

    _lightThemeIdentifierCache = lightThemeIdentifier;
    final sharedPreferences = await SharedPreferences.getInstance();
    if (lightThemeIdentifier == null) {
      sharedPreferences.remove(_lightThemeIdentifierKey);
    } else {
      sharedPreferences.setString(_lightThemeIdentifierKey, lightThemeIdentifier.name);
    }
  }

  /* endregion */
  /* region darkThemeIdentifier */

  final _darkThemeIdentifierKey = 'darkThemeIdentifier';
  CustomThemeIdentifier? _darkThemeIdentifierCache;

  Future<CustomThemeIdentifier?> getDarkThemeIdentifier() async {
    _logger.d('getDarkThemeIdentifier()');

    if (_darkThemeIdentifierCache == null) {
      String? darkThemeIdentifier = (await SharedPreferences.getInstance()).getString(_darkThemeIdentifierKey);
      _darkThemeIdentifierCache = darkThemeIdentifier == null ? null : CustomThemeIdentifier.values.byName(darkThemeIdentifier);
    }
    return _darkThemeIdentifierCache;
  }

  void saveDarkThemeIdentifier(CustomThemeIdentifier? darkThemeIdentifier) async {
    _logger.d('saveDarkThemeIdentifier()');

    _darkThemeIdentifierCache = darkThemeIdentifier;
    final sharedPreferences = await SharedPreferences.getInstance();
    if (darkThemeIdentifier == null) {
      sharedPreferences.remove(_darkThemeIdentifierKey);
    } else {
      sharedPreferences.setString(_darkThemeIdentifierKey, darkThemeIdentifier.name);
    }
  }

  /* endregion */
  /* region token */

  final _apiTokenKey = 'apiToken';
  ApiToken? _apiTokenCache;

  Future<ApiToken?> getApiToken() async {
    _logger.d('getApiToken()');

    if (_apiTokenCache == null) {
      String? apiToken = (await SharedPreferences.getInstance()).getString(_apiTokenKey);
      _apiTokenCache = apiToken == null ? null : ApiToken.fromJwt(apiToken);
    }
    return _apiTokenCache;
  }

  void saveApiToken(ApiToken? apiToken) async {
    _logger.d('saveApiToken()');

    _apiTokenCache = apiToken;
    final sharedPreferences = await SharedPreferences.getInstance();
    if (apiToken == null) {
      sharedPreferences.remove(_apiTokenKey);
    } else {
      sharedPreferences.setString(_apiTokenKey, apiToken.jwt);
    }
  }

  /* endregion */
}
