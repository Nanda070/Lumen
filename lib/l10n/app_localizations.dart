import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ru.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ru'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Lumen'**
  String get appTitle;

  /// No description provided for @navToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get navToday;

  /// No description provided for @navCalendar.
  ///
  /// In en, this message translates to:
  /// **'Calendar'**
  String get navCalendar;

  /// No description provided for @navTasks.
  ///
  /// In en, this message translates to:
  /// **'Tasks'**
  String get navTasks;

  /// No description provided for @navFinance.
  ///
  /// In en, this message translates to:
  /// **'Finance'**
  String get navFinance;

  /// No description provided for @navMore.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get navMore;

  /// No description provided for @todayGreeting.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get todayGreeting;

  /// No description provided for @todaySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your day at a glance.'**
  String get todaySubtitle;

  /// No description provided for @todayUpcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get todayUpcoming;

  /// No description provided for @todaySpend.
  ///
  /// In en, this message translates to:
  /// **'Spent today'**
  String get todaySpend;

  /// No description provided for @todayEmptyEvents.
  ///
  /// In en, this message translates to:
  /// **'No events today — add one in Calendar.'**
  String get todayEmptyEvents;

  /// No description provided for @todaySampleEvent.
  ///
  /// In en, this message translates to:
  /// **'Morning focus'**
  String get todaySampleEvent;

  /// No description provided for @todaySampleTime.
  ///
  /// In en, this message translates to:
  /// **'09:00 – 10:30'**
  String get todaySampleTime;

  /// No description provided for @roomComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming soon'**
  String get roomComingSoon;

  /// No description provided for @calendarSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Day, week, and month — your local canvas.'**
  String get calendarSubtitle;

  /// No description provided for @calendarViewDay.
  ///
  /// In en, this message translates to:
  /// **'Day'**
  String get calendarViewDay;

  /// No description provided for @calendarViewWeek.
  ///
  /// In en, this message translates to:
  /// **'Week'**
  String get calendarViewWeek;

  /// No description provided for @calendarViewMonth.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get calendarViewMonth;

  /// No description provided for @eventQuickAdd.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get eventQuickAdd;

  /// No description provided for @eventNewTitle.
  ///
  /// In en, this message translates to:
  /// **'New event'**
  String get eventNewTitle;

  /// No description provided for @eventEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit event'**
  String get eventEditTitle;

  /// No description provided for @eventTitleHint.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get eventTitleHint;

  /// No description provided for @eventTitleRequired.
  ///
  /// In en, this message translates to:
  /// **'Add a title.'**
  String get eventTitleRequired;

  /// No description provided for @eventCalendarRequired.
  ///
  /// In en, this message translates to:
  /// **'Pick a calendar.'**
  String get eventCalendarRequired;

  /// No description provided for @eventTimeInvalid.
  ///
  /// In en, this message translates to:
  /// **'End time must be after start.'**
  String get eventTimeInvalid;

  /// No description provided for @eventSaveError.
  ///
  /// In en, this message translates to:
  /// **'Could not save the event.'**
  String get eventSaveError;

  /// No description provided for @eventDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get eventDate;

  /// No description provided for @eventStart.
  ///
  /// In en, this message translates to:
  /// **'Starts'**
  String get eventStart;

  /// No description provided for @eventEnd.
  ///
  /// In en, this message translates to:
  /// **'Ends'**
  String get eventEnd;

  /// No description provided for @eventCalendar.
  ///
  /// In en, this message translates to:
  /// **'Calendar'**
  String get eventCalendar;

  /// No description provided for @eventCreate.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get eventCreate;

  /// No description provided for @eventSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get eventSave;

  /// No description provided for @eventCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get eventCancel;

  /// No description provided for @eventDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get eventDelete;

  /// No description provided for @eventDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete event?'**
  String get eventDeleteTitle;

  /// No description provided for @eventDeleteBody.
  ///
  /// In en, this message translates to:
  /// **'This removes the event from your local calendar.'**
  String get eventDeleteBody;

  /// No description provided for @weekdayMon.
  ///
  /// In en, this message translates to:
  /// **'Mon'**
  String get weekdayMon;

  /// No description provided for @weekdayTue.
  ///
  /// In en, this message translates to:
  /// **'Tue'**
  String get weekdayTue;

  /// No description provided for @weekdayWed.
  ///
  /// In en, this message translates to:
  /// **'Wed'**
  String get weekdayWed;

  /// No description provided for @weekdayThu.
  ///
  /// In en, this message translates to:
  /// **'Thu'**
  String get weekdayThu;

  /// No description provided for @weekdayFri.
  ///
  /// In en, this message translates to:
  /// **'Fri'**
  String get weekdayFri;

  /// No description provided for @weekdaySat.
  ///
  /// In en, this message translates to:
  /// **'Sat'**
  String get weekdaySat;

  /// No description provided for @weekdaySun.
  ///
  /// In en, this message translates to:
  /// **'Sun'**
  String get weekdaySun;

  /// No description provided for @monthJan.
  ///
  /// In en, this message translates to:
  /// **'January'**
  String get monthJan;

  /// No description provided for @monthFeb.
  ///
  /// In en, this message translates to:
  /// **'February'**
  String get monthFeb;

  /// No description provided for @monthMar.
  ///
  /// In en, this message translates to:
  /// **'March'**
  String get monthMar;

  /// No description provided for @monthApr.
  ///
  /// In en, this message translates to:
  /// **'April'**
  String get monthApr;

  /// No description provided for @monthMay.
  ///
  /// In en, this message translates to:
  /// **'May'**
  String get monthMay;

  /// No description provided for @monthJun.
  ///
  /// In en, this message translates to:
  /// **'June'**
  String get monthJun;

  /// No description provided for @monthJul.
  ///
  /// In en, this message translates to:
  /// **'July'**
  String get monthJul;

  /// No description provided for @monthAug.
  ///
  /// In en, this message translates to:
  /// **'August'**
  String get monthAug;

  /// No description provided for @monthSep.
  ///
  /// In en, this message translates to:
  /// **'September'**
  String get monthSep;

  /// No description provided for @monthOct.
  ///
  /// In en, this message translates to:
  /// **'October'**
  String get monthOct;

  /// No description provided for @monthNov.
  ///
  /// In en, this message translates to:
  /// **'November'**
  String get monthNov;

  /// No description provided for @monthDec.
  ///
  /// In en, this message translates to:
  /// **'December'**
  String get monthDec;

  /// No description provided for @tasksSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Inbox, Today, and day plans — room for later.'**
  String get tasksSubtitle;

  /// No description provided for @financeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Accounts, categories, and the month ledger.'**
  String get financeSubtitle;

  /// No description provided for @moreSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Habits, routine, nutrition, training, settings.'**
  String get moreSubtitle;

  /// No description provided for @moreHabits.
  ///
  /// In en, this message translates to:
  /// **'Habits'**
  String get moreHabits;

  /// No description provided for @moreRoutine.
  ///
  /// In en, this message translates to:
  /// **'Routine'**
  String get moreRoutine;

  /// No description provided for @moreNutrition.
  ///
  /// In en, this message translates to:
  /// **'Nutrition'**
  String get moreNutrition;

  /// No description provided for @moreTraining.
  ///
  /// In en, this message translates to:
  /// **'Training'**
  String get moreTraining;

  /// No description provided for @moreSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get moreSettings;

  /// No description provided for @moreProfileMeta.
  ///
  /// In en, this message translates to:
  /// **'Local profile · {currency}'**
  String moreProfileMeta(String currency);

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageRussian.
  ///
  /// In en, this message translates to:
  /// **'Русский'**
  String get languageRussian;

  /// No description provided for @onboardingContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get onboardingContinue;

  /// No description provided for @onboardingFinish.
  ///
  /// In en, this message translates to:
  /// **'Enter Lumen'**
  String get onboardingFinish;

  /// No description provided for @onboardingSaveError.
  ///
  /// In en, this message translates to:
  /// **'Could not save your profile. Try again.'**
  String get onboardingSaveError;

  /// No description provided for @onboardingNameTitle.
  ///
  /// In en, this message translates to:
  /// **'What should we call you?'**
  String get onboardingNameTitle;

  /// No description provided for @onboardingNameSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Just a name or nickname — it stays on this device.'**
  String get onboardingNameSubtitle;

  /// No description provided for @onboardingNameHint.
  ///
  /// In en, this message translates to:
  /// **'Your name'**
  String get onboardingNameHint;

  /// No description provided for @onboardingLocaleTitle.
  ///
  /// In en, this message translates to:
  /// **'Language & place'**
  String get onboardingLocaleTitle;

  /// No description provided for @onboardingLocaleSubtitle.
  ///
  /// In en, this message translates to:
  /// **'English by default. Pick where you live so currency feels right.'**
  String get onboardingLocaleSubtitle;

  /// No description provided for @onboardingCountryLabel.
  ///
  /// In en, this message translates to:
  /// **'Country / region'**
  String get onboardingCountryLabel;

  /// No description provided for @onboardingCurrencyTitle.
  ///
  /// In en, this message translates to:
  /// **'Base currency'**
  String get onboardingCurrencyTitle;

  /// No description provided for @onboardingCurrencySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Suggested from your region — search any world currency.'**
  String get onboardingCurrencySubtitle;

  /// No description provided for @currencySelectedLabel.
  ///
  /// In en, this message translates to:
  /// **'Selected'**
  String get currencySelectedLabel;

  /// No description provided for @currencyPickerHint.
  ///
  /// In en, this message translates to:
  /// **'Tap to search all ISO currencies.'**
  String get currencyPickerHint;

  /// No description provided for @currencySearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search code or name'**
  String get currencySearchHint;

  /// No description provided for @currencySearchEmpty.
  ///
  /// In en, this message translates to:
  /// **'No currencies match.'**
  String get currencySearchEmpty;

  /// No description provided for @moreAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get moreAbout;

  /// No description provided for @moreAboutBody.
  ///
  /// In en, this message translates to:
  /// **'Lumen by Nanda · Cheterin Group'**
  String get moreAboutBody;

  /// No description provided for @moreContactEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get moreContactEmail;

  /// No description provided for @moreContactTelegram.
  ///
  /// In en, this message translates to:
  /// **'Telegram'**
  String get moreContactTelegram;

  /// No description provided for @moreContactDiscord.
  ///
  /// In en, this message translates to:
  /// **'Discord'**
  String get moreContactDiscord;

  /// No description provided for @moreContactGithub.
  ///
  /// In en, this message translates to:
  /// **'GitHub'**
  String get moreContactGithub;

  /// No description provided for @moreContactServer.
  ///
  /// In en, this message translates to:
  /// **'Discord server'**
  String get moreContactServer;

  /// No description provided for @onboardingGoogleTitle.
  ///
  /// In en, this message translates to:
  /// **'Google Calendar'**
  String get onboardingGoogleTitle;

  /// No description provided for @onboardingGoogleSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Optional. Two-way sync comes after the local calendar feels great.'**
  String get onboardingGoogleSubtitle;

  /// No description provided for @onboardingGoogleCardTitle.
  ///
  /// In en, this message translates to:
  /// **'Skip for now'**
  String get onboardingGoogleCardTitle;

  /// No description provided for @onboardingGoogleCardBody.
  ///
  /// In en, this message translates to:
  /// **'You can connect Google later from Calendar. Lumen works fully offline first.'**
  String get onboardingGoogleCardBody;

  /// No description provided for @onboardingReadyTitle.
  ///
  /// In en, this message translates to:
  /// **'You\'re set'**
  String get onboardingReadyTitle;

  /// No description provided for @onboardingReadyTitleNamed.
  ///
  /// In en, this message translates to:
  /// **'You\'re in, {name}'**
  String onboardingReadyTitleNamed(String name);

  /// No description provided for @onboardingReadySubtitle.
  ///
  /// In en, this message translates to:
  /// **'A local profile is ready. Personal & Lumen calendars and starter money categories are waiting.'**
  String get onboardingReadySubtitle;

  /// No description provided for @onboardingReadySeedTitle.
  ///
  /// In en, this message translates to:
  /// **'What\'s ready'**
  String get onboardingReadySeedTitle;

  /// No description provided for @onboardingReadySeedBody.
  ///
  /// In en, this message translates to:
  /// **'Personal + Lumen calendars · default expense & income categories · your language and currency.'**
  String get onboardingReadySeedBody;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ru':
      return AppLocalizationsRu();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
