import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app.dart';
import 'design_system/lumen_colors.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: LumenColors.bgElevated,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const LumenApp());
}
