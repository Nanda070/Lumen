// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Lumen';

  @override
  String get navToday => 'Сегодня';

  @override
  String get navCalendar => 'Календарь';

  @override
  String get navTasks => 'Задачи';

  @override
  String get navFinance => 'Финансы';

  @override
  String get navMore => 'Ещё';

  @override
  String get todayGreeting => 'Сегодня';

  @override
  String get todaySubtitle => 'Пульс дня одним взглядом.';

  @override
  String get todayUpcoming => 'Ближайшее';

  @override
  String get todaySpend => 'Расход за день';

  @override
  String get todayEmptyEvents => 'Пока пусто — календарь следующий шаг.';

  @override
  String get todaySampleEvent => 'Утренний фокус';

  @override
  String get todaySampleTime => '09:00 – 10:30';

  @override
  String get roomComingSoon => 'Скоро';

  @override
  String get calendarSubtitle => 'День, неделя и месяц появятся здесь.';

  @override
  String get tasksSubtitle => 'Inbox, Сегодня и планы дня — комната позже.';

  @override
  String get financeSubtitle => 'Счета, категории и таблица месяца.';

  @override
  String get moreSubtitle =>
      'Привычки, распорядок, питание, тренировки, настройки.';

  @override
  String get moreHabits => 'Привычки';

  @override
  String get moreRoutine => 'Распорядок';

  @override
  String get moreNutrition => 'Питание';

  @override
  String get moreTraining => 'Тренировки';

  @override
  String get moreSettings => 'Настройки';

  @override
  String get language => 'Язык';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageRussian => 'Русский';
}
