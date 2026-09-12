import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'data/app_database.dart';
import 'design_system/design_system.dart';
import 'features/onboarding/onboarding_flow.dart';
import 'l10n/app_localizations.dart';
import 'shell/app_shell.dart';

class LumenApp extends StatefulWidget {
  const LumenApp({super.key, this.database});

  /// Optional inject for tests; production opens the default local DB.
  final AppDatabase? database;

  @override
  State<LumenApp> createState() => _LumenAppState();
}

class _LumenAppState extends State<LumenApp> {
  late final AppDatabase _database;
  Locale _locale = const Locale('en');
  Profile? _profile;
  bool _loading = true;
  Object? _error;

  @override
  void initState() {
    super.initState();
    _database = widget.database ?? AppDatabase();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    try {
      final profile = await _database.getProfile();
      if (!mounted) return;
      setState(() {
        _profile = profile;
        if (profile != null) {
          _locale = Locale(profile.localeCode);
        }
        _loading = false;
        _error = null;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = e;
      });
    }
  }

  Future<void> _setLocale(Locale locale) async {
    setState(() => _locale = locale);
    await _database.updateLocale(locale.languageCode);
  }

  Future<void> _onOnboardingCompleted() async {
    final profile = await _database.getProfile();
    if (!mounted) return;
    setState(() {
      _profile = profile;
      if (profile != null) {
        _locale = Locale(profile.localeCode);
      }
    });
  }

  @override
  void dispose() {
    if (widget.database == null) {
      _database.close();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      debugShowCheckedModeBanner: false,
      theme: LumenTheme.dark(),
      locale: _locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: _home,
    );
  }

  Widget get _home {
    if (_loading) {
      return const AtmosphereBackground(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: CircularProgressIndicator(color: LumenColors.accentViolet),
          ),
        ),
      );
    }

    if (_error != null) {
      return AtmosphereBackground(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(LumenSpacing.pagePadding),
              child: Text(
                'Could not open local database.\n$_error',
                textAlign: TextAlign.center,
                style: const TextStyle(color: LumenColors.textMuted),
              ),
            ),
          ),
        ),
      );
    }

    if (_profile == null) {
      return OnboardingFlow(
        database: _database,
        locale: _locale,
        onLocaleChanged: (locale) => setState(() => _locale = locale),
        onCompleted: _onOnboardingCompleted,
      );
    }

    return AppShell(
      locale: _locale,
      onLocaleChanged: _setLocale,
      currencyCode: _profile!.currencyCode,
      displayName: _profile!.displayName,
    );
  }
}
