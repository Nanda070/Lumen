import 'dart:typed_data';

/// Web download stub — no-op on VM; real impl in `lumen_backup_download_web.dart`.
Future<void> downloadBytes(Uint8List bytes, String filename) async {
  throw UnsupportedError('Web download not available on this platform');
}
