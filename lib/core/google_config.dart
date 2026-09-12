import 'package:flutter/foundation.dart';

/// Google OAuth client IDs for Calendar sync.
///
/// Cloud project: My First Project (`project-df5ba602-8fb8-4915-974`).
/// Consent: External / Testing — test user `adnan.huseynli1@gmail.com`.
/// Calendar API enabled. Client secret is NOT stored here (web-only secret
/// stays in Cloud Console).
abstract final class GoogleConfig {
  /// iOS OAuth client ID (bundle `com.lumen.lumen`)
  static const iosClientId =
      '445364111690-4f1p41ingckci1ejpf3o1cvqktp79hk0.apps.googleusercontent.com';

  /// Android OAuth client ID (package `com.lumen.lumen`, debug SHA-1)
  static const androidClientId =
      '445364111690-nd1ubnpadg732nbn3avb89hrd9qj1bp2.apps.googleusercontent.com';

  /// Web client ID (also used as serverClientId for mobile id-token flows)
  static const webClientId =
      '445364111690-kkdv6g7jrivqdq4j7bl6jv08koa79uh6.apps.googleusercontent.com';

  /// Client ID for the current platform (web / iOS / Android).
  static String? get clientIdForPlatform {
    if (kIsWeb) {
      return webClientId.isNotEmpty ? webClientId : null;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.iOS:
        return iosClientId.isNotEmpty ? iosClientId : null;
      case TargetPlatform.android:
        return androidClientId.isNotEmpty ? androidClientId : null;
      default:
        return webClientId.isNotEmpty ? webClientId : null;
    }
  }

  /// True when the **current** platform has a non-empty OAuth client id.
  static bool get isConfigured => clientIdForPlatform != null;

  static const calendarScopes = <String>[
    'email',
    'https://www.googleapis.com/auth/calendar',
  ];
}
