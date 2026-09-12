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

  /// Web client ID (also used as serverClientId for some flows)
  static const webClientId =
      '445364111690-kkdv6g7jrivqdq4j7bl6jv08koa79uh6.apps.googleusercontent.com';

  /// True when at least one platform client id is set.
  static bool get isConfigured =>
      iosClientId.isNotEmpty ||
      androidClientId.isNotEmpty ||
      webClientId.isNotEmpty;

  static const calendarScopes = <String>[
    'email',
    'https://www.googleapis.com/auth/calendar',
  ];
}
