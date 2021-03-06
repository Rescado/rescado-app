import 'package:firebase_crashlytics/firebase_crashlytics.dart';

class ApiException implements Exception {
  late final List<String> _messages;
  late final List<String> _keys;

  List<String> get messages => _messages;

  List<String> get keys => _keys;

  ApiException(List<String> messages) {
    _messages = messages;
    _keys = messages.map<String>((message) => message.substring(1, message.indexOf(']'))).toList();

    FirebaseCrashlytics.instance.recordError(
      this,
      StackTrace.current,
      reason: 'ApiException',
    );
  }

  @override
  String toString() => 'ApiException:\n • ${messages.join('\n • ')}';

  List<String> getKeys() => messages.map<String>((message) => message.substring(1, message.indexOf(']'))).toList();
}
