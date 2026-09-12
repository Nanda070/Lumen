/// Google OAuth client IDs for Calendar sync.
///
/// Fill these from your Google Cloud Console (OAuth 2.0 Client IDs):
/// 1. Enable **Google Calendar API**
/// 2. Create OAuth clients: iOS, Android, Web (as needed)
/// 3. Paste IDs below and rebuild
///
/// Until configured, Connect UI shows a setup hint and sign-in is blocked.
abstract final class GoogleConfig {
  /// iOS OAuth client ID (…apps.googleusercontent.com)
  static const iosClientId = '';

  /// Android OAuth client ID (optional if using default SHA-1 setup)
  static const androidClientId = '';

  /// Web client ID (also used as serverClientId for some flows)
  static const webClientId = '';

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
