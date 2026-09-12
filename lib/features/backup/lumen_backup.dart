import 'dart:convert';

import 'package:archive/archive.dart';
import 'package:drift/drift.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb, Uint8List;
import 'package:share_plus/share_plus.dart';

import '../../data/app_database.dart';
import 'lumen_backup_download.dart';

/// Backup format version inside `.lumen` (zip: manifest.json + data.json).
const lumenBackupFormatVersion = 1;

enum LumenRestoreMode { replace, merge }

/// Export / restore local DB as a portable `.lumen` zip.
class LumenBackup {
  LumenBackup(this.db);

  final AppDatabase db;

  Future<Uint8List> buildArchiveBytes() async {
    final payload = await _exportPayload();
    final archive = Archive();
    final manifest = utf8.encode(
      jsonEncode({
        'format': 'lumen',
        'formatVersion': lumenBackupFormatVersion,
        'schemaVersion': db.schemaVersion,
        'exportedAt': DateTime.now().toUtc().toIso8601String(),
        'app': 'Lumen',
      }),
    );
    final data = utf8.encode(jsonEncode(payload));
    archive.addFile(ArchiveFile('manifest.json', manifest.length, manifest));
    archive.addFile(ArchiveFile('data.json', data.length, data));
    final encoded = ZipEncoder().encode(archive);
    return Uint8List.fromList(encoded);
  }

  /// Download (web) or share sheet (mobile) current DB as `.lumen`.
  Future<void> exportAndShare() async {
    final bytes = await buildArchiveBytes();
    final stamp = DateTime.now()
        .toIso8601String()
        .substring(0, 10)
        .replaceAll('-', '');
    final name = 'lumen-$stamp.lumen';

    if (kIsWeb) {
      await downloadBytes(bytes, name);
      return;
    }

    await SharePlus.instance.share(
      ShareParams(
        files: [
          XFile.fromData(
            bytes,
            mimeType: 'application/zip',
            name: name,
          ),
        ],
        subject: 'Lumen backup',
      ),
    );
  }

  Future<LumenRestoreResult> pickAndRestore(LumenRestoreMode mode) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: const ['lumen', 'zip'],
      withData: true,
    );
    if (result == null || result.files.isEmpty) {
      return const LumenRestoreResult.cancelled();
    }
    final bytes = result.files.single.bytes;
    if (bytes == null) {
      return const LumenRestoreResult.failed('Could not read backup file');
    }
    return restoreFromBytes(bytes, mode);
  }

  Future<LumenRestoreResult> restoreFromBytes(
    Uint8List bytes,
    LumenRestoreMode mode,
  ) async {
    try {
      final archive = ZipDecoder().decodeBytes(bytes);
      final dataFile = archive.findFile('data.json');
      final manifestFile = archive.findFile('manifest.json');
      if (dataFile == null) {
        return const LumenRestoreResult.failed(
          'Invalid .lumen — missing data.json',
        );
      }
      if (manifestFile != null) {
        final manifest = jsonDecode(
          utf8.decode(manifestFile.content as List<int>),
        ) as Map<String, dynamic>;
        if (manifest['format'] != null && manifest['format'] != 'lumen') {
          return const LumenRestoreResult.failed('Not a Lumen backup');
        }
      }
      final payload = jsonDecode(utf8.decode(dataFile.content as List<int>))
          as Map<String, dynamic>;
      await db.importBackupPayload(
        payload,
        replace: mode == LumenRestoreMode.replace,
      );
      return LumenRestoreResult.ok(mode);
    } catch (e) {
      return LumenRestoreResult.failed('$e');
    }
  }

  Future<Map<String, dynamic>> _exportPayload() async {
    Object? jsonSafe(Object? v) {
      if (v == null || v is num || v is String || v is bool) return v;
      if (v is DateTime) return v.toUtc().toIso8601String();
      if (v is Uint8List) return base64Encode(v);
      return v.toString();
    }

    Future<List<Map<String, Object?>>> dump(TableInfo table) async {
      final rows = await db
          .customSelect(
            'SELECT * FROM ${table.actualTableName}',
            readsFrom: {table},
          )
          .get();
      return [
        for (final r in rows)
          {
            for (final e in r.data.entries) e.key: jsonSafe(e.value),
          },
      ];
    }

    return {
      'profiles': await dump(db.profiles),
      'calendars': await dump(db.calendars),
      'events': await dump(db.events),
      'google_sync_state': await dump(db.googleSyncState),
      'tasks': await dump(db.tasks),
      'finance_categories': await dump(db.financeCategories),
      'finance_accounts': await dump(db.financeAccounts),
      'monthly_budgets': await dump(db.monthlyBudgets),
      'category_allocations': await dump(db.categoryAllocations),
      'finance_transactions': await dump(db.financeTransactions),
      'today_preferences': await dump(db.todayPreferences),
      'habits': await dump(db.habits),
      'habit_logs': await dump(db.habitLogs),
      'routines': await dump(db.routines),
      'routine_slots': await dump(db.routineSlots),
      'routine_slot_logs': await dump(db.routineSlotLogs),
      'nutrition_targets': await dump(db.nutritionTargets),
      'food_entries': await dump(db.foodEntries),
      'workouts': await dump(db.workouts),
      'workout_exercises': await dump(db.workoutExercises),
      'workout_sessions': await dump(db.workoutSessions),
      'session_sets': await dump(db.sessionSets),
    };
  }
}

class LumenRestoreResult {
  const LumenRestoreResult._({
    required this.ok,
    this.cancelled = false,
    this.mode,
    this.error,
  });

  const LumenRestoreResult.ok(LumenRestoreMode mode)
      : this._(ok: true, mode: mode);

  const LumenRestoreResult.cancelled() : this._(ok: false, cancelled: true);

  const LumenRestoreResult.failed(String error)
      : this._(ok: false, error: error);

  final bool ok;
  final bool cancelled;
  final LumenRestoreMode? mode;
  final String? error;
}
