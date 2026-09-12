import 'package:drift/drift.dart';
import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/calendar/v3.dart' as gcal;

import '../../core/google_config.dart';
import '../../data/app_database.dart';

/// Two-way Google Calendar sync (last-write-wins).
///
/// Requires [GoogleConfig] client IDs. Without them, [connect] throws
/// [GoogleNotConfiguredException].
class GoogleCalendarSync {
  GoogleCalendarSync(this.database);

  final AppDatabase database;

  bool _initialized = false;
  GoogleSignInAccount? _user;
  gcal.CalendarApi? _api;

  Future<void> _ensureInit() async {
    if (_initialized) return;
    if (!GoogleConfig.isConfigured) {
      throw GoogleNotConfiguredException();
    }
    await GoogleSignIn.instance.initialize(
      clientId: GoogleConfig.clientIdForPlatform,
      // Web client as serverClientId on mobile (id token / backend-style flows).
      serverClientId: (!kIsWeb && GoogleConfig.webClientId.isNotEmpty)
          ? GoogleConfig.webClientId
          : null,
    );
    _initialized = true;
  }

  Future<void> connect() async {
    await _ensureInit();
    try {
      final lightweight =
          await GoogleSignIn.instance.attemptLightweightAuthentication();
      _user = lightweight;
      if (_user == null && GoogleSignIn.instance.supportsAuthenticate()) {
        _user = await GoogleSignIn.instance.authenticate(
          scopeHint: GoogleConfig.calendarScopes,
        );
      }
      if (_user == null) {
        await database.setGoogleConnected(connected: false, error: 'cancelled');
        return;
      }
      await _buildApi();
      await database.setGoogleConnected(
        connected: true,
        email: _user!.email,
      );
      await syncNow();
    } catch (e) {
      await database.setGoogleConnected(
        connected: false,
        error: e.toString(),
      );
      rethrow;
    }
  }

  Future<void> disconnect() async {
    if (_initialized) {
      await GoogleSignIn.instance.signOut();
    }
    _user = null;
    _api = null;
    await database.setGoogleConnected(connected: false, email: null);
  }

  Future<void> syncNow() async {
    await _ensureInit();
    try {
      if (_user == null) {
        final lightweight =
            await GoogleSignIn.instance.attemptLightweightAuthentication();
        _user = lightweight;
      }
      if (_user == null) {
        await connect();
        return;
      }
      await _buildApi();
      await _pullPrimary();
      await _pushDirty();
      await database.markGoogleSynced();
    } catch (e, st) {
      debugPrint('Google sync failed: $e\n$st');
      await database.markGoogleSynced(error: e.toString());
      rethrow;
    }
  }

  Future<void> _buildApi() async {
    final user = _user;
    if (user == null) throw StateError('not signed in');
    final auth = await user.authorizationClient.authorizeScopes(
      GoogleConfig.calendarScopes,
    );
    final client = auth.authClient(scopes: GoogleConfig.calendarScopes);
    _api = gcal.CalendarApi(client);
  }

  Future<void> _pullPrimary() async {
    final api = _api;
    if (api == null) return;

    final calId = await database.ensureGoogleCalendar(
      googleCalendarId: 'primary',
      name: 'Google',
      colorArgb: 0xFF5B7CFF,
    );

    final list = await api.events.list(
      'primary',
      singleEvents: true,
      orderBy: 'startTime',
      timeMin: DateTime.now().toUtc().subtract(const Duration(days: 30)),
      timeMax: DateTime.now().toUtc().add(const Duration(days: 90)),
      maxResults: 250,
    );

    for (final item in list.items ?? const <gcal.Event>[]) {
      final id = item.id;
      if (id == null || id.isEmpty) continue;
      final start = _parseGoogleDate(item.start);
      final end = _parseGoogleDate(item.end) ??
          start?.add(const Duration(hours: 1));
      if (start == null || end == null) continue;
      final title = (item.summary ?? '').trim();
      await database.upsertGoogleEvent(
        calendarId: calId,
        googleEventId: id,
        title: title.isEmpty ? '(No title)' : title,
        startsAt: start,
        endsAt: end,
        etag: item.etag,
      );
    }

    await (database.update(database.calendars)
          ..where((t) => t.id.equals(calId)))
        .write(
      CalendarsCompanion(
        googleSyncToken: Value(list.nextSyncToken),
      ),
    );
  }

  Future<void> _pushDirty() async {
    final api = _api;
    if (api == null) return;
    final dirty = await database.dirtyEvents();
    for (final event in dirty) {
      final cal = await (database.select(database.calendars)
            ..where((t) => t.id.equals(event.calendarId)))
          .getSingleOrNull();
      final googleCalId = cal?.googleCalendarId ?? 'primary';

      final body = gcal.Event(
        summary: event.title,
        start: gcal.EventDateTime(
          dateTime: event.startsAt.toUtc(),
          timeZone: 'UTC',
        ),
        end: gcal.EventDateTime(
          dateTime: event.endsAt.toUtc(),
          timeZone: 'UTC',
        ),
      );

      final gcal.Event remote;
      final gid = event.googleEventId;
      if (gid != null && gid.isNotEmpty) {
        remote = await api.events.update(body, googleCalId, gid);
      } else {
        remote = await api.events.insert(body, googleCalId);
      }
      final rid = remote.id;
      if (rid != null) {
        await database.markEventSynced(
          id: event.id,
          googleEventId: rid,
          etag: remote.etag,
        );
      }
    }
  }

  DateTime? _parseGoogleDate(gcal.EventDateTime? value) {
    if (value == null) return null;
    if (value.dateTime != null) return value.dateTime!.toLocal();
    if (value.date != null) {
      final d = value.date!;
      return DateTime(d.year, d.month, d.day);
    }
    return null;
  }
}

class GoogleNotConfiguredException implements Exception {
  @override
  String toString() =>
      'Google OAuth client IDs missing — set GoogleConfig in lib/core/google_config.dart';
}
