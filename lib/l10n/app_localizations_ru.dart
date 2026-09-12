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
  String moreProfileMeta(String currency) {
    return 'Локальный профиль · $currency';
  }

  @override
  String get language => 'Язык';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageRussian => 'Русский';

  @override
  String get onboardingContinue => 'Далее';

  @override
  String get onboardingFinish => 'Войти в Lumen';

  @override
  String get onboardingSaveError =>
      'Не удалось сохранить профиль. Попробуйте ещё раз.';

  @override
  String get onboardingNameTitle => 'Как к вам обращаться?';

  @override
  String get onboardingNameSubtitle =>
      'Имя или ник — всё остаётся только на этом устройстве.';

  @override
  String get onboardingNameHint => 'Ваше имя';

  @override
  String get onboardingLocaleTitle => 'Язык и место';

  @override
  String get onboardingLocaleSubtitle =>
      'По умолчанию English. Выберите страну — подскажем валюту.';

  @override
  String get onboardingCountryLabel => 'Страна / регион';

  @override
  String get onboardingCurrencyTitle => 'Базовая валюта';

  @override
  String get onboardingCurrencySubtitle =>
      'Предложена по региону — потом можно сменить.';

  @override
  String get onboardingGoogleTitle => 'Google Calendar';

  @override
  String get onboardingGoogleSubtitle =>
      'По желанию. Двусторонняя синхронизация — после живого локального календаря.';

  @override
  String get onboardingGoogleCardTitle => 'Пока пропустить';

  @override
  String get onboardingGoogleCardBody =>
      'Google можно подключить позже в Календаре. Сначала Lumen полностью офлайн.';

  @override
  String get onboardingReadyTitle => 'Готово';

  @override
  String onboardingReadyTitleNamed(String name) {
    return 'Добро пожаловать, $name';
  }

  @override
  String get onboardingReadySubtitle =>
      'Локальный профиль создан. Календари Personal и Lumen и стартовые категории денег уже на месте.';

  @override
  String get onboardingReadySeedTitle => 'Что уже есть';

  @override
  String get onboardingReadySeedBody =>
      'Календари Personal и Lumen · базовые категории расходов и доходов · ваш язык и валюта.';
}
