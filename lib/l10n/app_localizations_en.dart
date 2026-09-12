// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Lumen';

  @override
  String get navToday => 'Today';

  @override
  String get navCalendar => 'Calendar';

  @override
  String get navTasks => 'Tasks';

  @override
  String get navFinance => 'Finance';

  @override
  String get navMore => 'More';

  @override
  String get todayGreeting => 'Today';

  @override
  String get todaySubtitle => 'Your day at a glance.';

  @override
  String get todayUpcoming => 'Upcoming';

  @override
  String get todaySpend => 'Spent today';

  @override
  String get todayEmptyEvents => 'No events today — add one in Calendar.';

  @override
  String get todaySampleEvent => 'Morning focus';

  @override
  String get todaySampleTime => '09:00 – 10:30';

  @override
  String get roomComingSoon => 'Coming soon';

  @override
  String get calendarSubtitle => 'Day, week, and month — your local canvas.';

  @override
  String get calendarViewDay => 'Day';

  @override
  String get calendarViewWeek => 'Week';

  @override
  String get calendarViewMonth => 'Month';

  @override
  String get eventQuickAdd => 'Add';

  @override
  String get eventNewTitle => 'New event';

  @override
  String get eventEditTitle => 'Edit event';

  @override
  String get eventTitleHint => 'Title';

  @override
  String get eventTitleRequired => 'Add a title.';

  @override
  String get eventCalendarRequired => 'Pick a calendar.';

  @override
  String get eventTimeInvalid => 'End time must be after start.';

  @override
  String get eventSaveError => 'Could not save the event.';

  @override
  String get eventDate => 'Date';

  @override
  String get eventStart => 'Starts';

  @override
  String get eventEnd => 'Ends';

  @override
  String get eventCalendar => 'Calendar';

  @override
  String get eventCreate => 'Create';

  @override
  String get eventSave => 'Save';

  @override
  String get eventCancel => 'Cancel';

  @override
  String get eventDelete => 'Delete';

  @override
  String get eventDeleteTitle => 'Delete event?';

  @override
  String get eventDeleteBody =>
      'This removes the event from your local calendar.';

  @override
  String get weekdayMon => 'Mon';

  @override
  String get weekdayTue => 'Tue';

  @override
  String get weekdayWed => 'Wed';

  @override
  String get weekdayThu => 'Thu';

  @override
  String get weekdayFri => 'Fri';

  @override
  String get weekdaySat => 'Sat';

  @override
  String get weekdaySun => 'Sun';

  @override
  String get monthJan => 'January';

  @override
  String get monthFeb => 'February';

  @override
  String get monthMar => 'March';

  @override
  String get monthApr => 'April';

  @override
  String get monthMay => 'May';

  @override
  String get monthJun => 'June';

  @override
  String get monthJul => 'July';

  @override
  String get monthAug => 'August';

  @override
  String get monthSep => 'September';

  @override
  String get monthOct => 'October';

  @override
  String get monthNov => 'November';

  @override
  String get monthDec => 'December';

  @override
  String get tasksSubtitle => 'Inbox, Today, and day plans — room for later.';

  @override
  String get financeSubtitle => 'Accounts, categories, and the month ledger.';

  @override
  String get moreSubtitle => 'Habits, routine, nutrition, training, settings.';

  @override
  String get moreHabits => 'Habits';

  @override
  String get moreRoutine => 'Routine';

  @override
  String get moreNutrition => 'Nutrition';

  @override
  String get moreTraining => 'Training';

  @override
  String get moreSettings => 'Settings';

  @override
  String moreProfileMeta(String currency) {
    return 'Local profile · $currency';
  }

  @override
  String get language => 'Language';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageRussian => 'Русский';

  @override
  String get onboardingContinue => 'Continue';

  @override
  String get onboardingFinish => 'Enter Lumen';

  @override
  String get onboardingSaveError => 'Could not save your profile. Try again.';

  @override
  String get onboardingNameTitle => 'What should we call you?';

  @override
  String get onboardingNameSubtitle =>
      'Just a name or nickname — it stays on this device.';

  @override
  String get onboardingNameHint => 'Your name';

  @override
  String get onboardingLocaleTitle => 'Language & place';

  @override
  String get onboardingLocaleSubtitle =>
      'English by default. Pick where you live so currency feels right.';

  @override
  String get onboardingCountryLabel => 'Country / region';

  @override
  String get onboardingCurrencyTitle => 'Base currency';

  @override
  String get onboardingCurrencySubtitle =>
      'Suggested from your region — search any world currency.';

  @override
  String get currencySelectedLabel => 'Selected';

  @override
  String get currencyPickerHint => 'Tap to search all ISO currencies.';

  @override
  String get currencySearchHint => 'Search code or name';

  @override
  String get currencySearchEmpty => 'No currencies match.';

  @override
  String get moreAbout => 'About';

  @override
  String get moreAboutBody => 'Lumen by Nanda · Cheterin Group';

  @override
  String get moreContactEmail => 'Email';

  @override
  String get moreContactTelegram => 'Telegram';

  @override
  String get moreContactDiscord => 'Discord';

  @override
  String get moreContactGithub => 'GitHub';

  @override
  String get moreContactServer => 'Discord server';

  @override
  String get onboardingGoogleTitle => 'Google Calendar';

  @override
  String get onboardingGoogleSubtitle =>
      'Optional. Two-way sync comes after the local calendar feels great.';

  @override
  String get onboardingGoogleCardTitle => 'Skip for now';

  @override
  String get onboardingGoogleCardBody =>
      'You can connect Google later from Calendar. Lumen works fully offline first.';

  @override
  String get onboardingReadyTitle => 'You\'re set';

  @override
  String onboardingReadyTitleNamed(String name) {
    return 'You\'re in, $name';
  }

  @override
  String get onboardingReadySubtitle =>
      'A local profile is ready. Personal & Lumen calendars and starter money categories are waiting.';

  @override
  String get onboardingReadySeedTitle => 'What\'s ready';

  @override
  String get onboardingReadySeedBody =>
      'Personal + Lumen calendars · default expense & income categories · your language and currency.';
}
