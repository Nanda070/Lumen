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

  /// No description provided for @todayEventsMore.
  ///
  /// In en, this message translates to:
  /// **'+{count} more'**
  String todayEventsMore(int count);

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

  /// No description provided for @catFood.
  ///
  /// In en, this message translates to:
  /// **'Food'**
  String get catFood;

  /// No description provided for @catTransport.
  ///
  /// In en, this message translates to:
  /// **'Transport'**
  String get catTransport;

  /// No description provided for @catHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get catHome;

  /// No description provided for @catShopping.
  ///
  /// In en, this message translates to:
  /// **'Shopping'**
  String get catShopping;

  /// No description provided for @catHealth.
  ///
  /// In en, this message translates to:
  /// **'Health'**
  String get catHealth;

  /// No description provided for @catOtherExpense.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get catOtherExpense;

  /// No description provided for @catSalary.
  ///
  /// In en, this message translates to:
  /// **'Salary'**
  String get catSalary;

  /// No description provided for @catOtherIncome.
  ///
  /// In en, this message translates to:
  /// **'Other income'**
  String get catOtherIncome;

  /// No description provided for @financeSpent.
  ///
  /// In en, this message translates to:
  /// **'Spent'**
  String get financeSpent;

  /// No description provided for @financeRemaining.
  ///
  /// In en, this message translates to:
  /// **'Remaining'**
  String get financeRemaining;

  /// No description provided for @financeBudget.
  ///
  /// In en, this message translates to:
  /// **'Budget'**
  String get financeBudget;

  /// No description provided for @financeIncome.
  ///
  /// In en, this message translates to:
  /// **'Income'**
  String get financeIncome;

  /// No description provided for @financeNoBudget.
  ///
  /// In en, this message translates to:
  /// **'No budget set'**
  String get financeNoBudget;

  /// No description provided for @financeSetBudget.
  ///
  /// In en, this message translates to:
  /// **'Set budget'**
  String get financeSetBudget;

  /// No description provided for @financeEditBudget.
  ///
  /// In en, this message translates to:
  /// **'Edit budget'**
  String get financeEditBudget;

  /// No description provided for @financeBudgetHint.
  ///
  /// In en, this message translates to:
  /// **'Monthly spending limit'**
  String get financeBudgetHint;

  /// No description provided for @financeBudgetTotal.
  ///
  /// In en, this message translates to:
  /// **'Total monthly limit'**
  String get financeBudgetTotal;

  /// No description provided for @financeAllocations.
  ///
  /// In en, this message translates to:
  /// **'Category plan'**
  String get financeAllocations;

  /// No description provided for @financeAllocationsHint.
  ///
  /// In en, this message translates to:
  /// **'Allocate within your budget'**
  String get financeAllocationsHint;

  /// No description provided for @financeAllocationFor.
  ///
  /// In en, this message translates to:
  /// **'{category}'**
  String financeAllocationFor(String category);

  /// No description provided for @financeStatusOk.
  ///
  /// In en, this message translates to:
  /// **'On track'**
  String get financeStatusOk;

  /// No description provided for @financeStatusWarning.
  ///
  /// In en, this message translates to:
  /// **'Almost there'**
  String get financeStatusWarning;

  /// No description provided for @financeStatusOver.
  ///
  /// In en, this message translates to:
  /// **'Overspent'**
  String get financeStatusOver;

  /// No description provided for @financeStatusNone.
  ///
  /// In en, this message translates to:
  /// **'Set a budget'**
  String get financeStatusNone;

  /// No description provided for @financeVsPlan.
  ///
  /// In en, this message translates to:
  /// **'vs plan'**
  String get financeVsPlan;

  /// No description provided for @financeOverBy.
  ///
  /// In en, this message translates to:
  /// **'Over by {amount}'**
  String financeOverBy(String amount);

  /// No description provided for @financeUnderBy.
  ///
  /// In en, this message translates to:
  /// **'{amount} left in plan'**
  String financeUnderBy(String amount);

  /// No description provided for @financeByCategory.
  ///
  /// In en, this message translates to:
  /// **'By category'**
  String get financeByCategory;

  /// No description provided for @financeTrend.
  ///
  /// In en, this message translates to:
  /// **'Daily spend'**
  String get financeTrend;

  /// No description provided for @financeTransactions.
  ///
  /// In en, this message translates to:
  /// **'Transactions'**
  String get financeTransactions;

  /// No description provided for @financeEmptyTx.
  ///
  /// In en, this message translates to:
  /// **'No transactions this month.'**
  String get financeEmptyTx;

  /// No description provided for @financeAddTx.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get financeAddTx;

  /// No description provided for @financeNewTx.
  ///
  /// In en, this message translates to:
  /// **'New transaction'**
  String get financeNewTx;

  /// No description provided for @financeEditTx.
  ///
  /// In en, this message translates to:
  /// **'Edit transaction'**
  String get financeEditTx;

  /// No description provided for @financeAmount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get financeAmount;

  /// No description provided for @financeAmountRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter an amount.'**
  String get financeAmountRequired;

  /// No description provided for @financeNote.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get financeNote;

  /// No description provided for @financeNoteHint.
  ///
  /// In en, this message translates to:
  /// **'Optional note'**
  String get financeNoteHint;

  /// No description provided for @financeCategory.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get financeCategory;

  /// No description provided for @financeAccount.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get financeAccount;

  /// No description provided for @financeDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get financeDate;

  /// No description provided for @financeTypeExpense.
  ///
  /// In en, this message translates to:
  /// **'Expense'**
  String get financeTypeExpense;

  /// No description provided for @financeTypeIncome.
  ///
  /// In en, this message translates to:
  /// **'Income'**
  String get financeTypeIncome;

  /// No description provided for @financeFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get financeFilterAll;

  /// No description provided for @financeSaveError.
  ///
  /// In en, this message translates to:
  /// **'Could not save.'**
  String get financeSaveError;

  /// No description provided for @financeDeleteTxTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete transaction?'**
  String get financeDeleteTxTitle;

  /// No description provided for @financeDeleteTxBody.
  ///
  /// In en, this message translates to:
  /// **'This removes it from your ledger and updates the account balance.'**
  String get financeDeleteTxBody;

  /// No description provided for @financeAccounts.
  ///
  /// In en, this message translates to:
  /// **'Accounts'**
  String get financeAccounts;

  /// No description provided for @financeCategories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get financeCategories;

  /// No description provided for @financeManageAccounts.
  ///
  /// In en, this message translates to:
  /// **'Manage accounts'**
  String get financeManageAccounts;

  /// No description provided for @financeManageCategories.
  ///
  /// In en, this message translates to:
  /// **'Manage categories'**
  String get financeManageCategories;

  /// No description provided for @financeNewAccount.
  ///
  /// In en, this message translates to:
  /// **'New account'**
  String get financeNewAccount;

  /// No description provided for @financeEditAccount.
  ///
  /// In en, this message translates to:
  /// **'Edit account'**
  String get financeEditAccount;

  /// No description provided for @financeAccountName.
  ///
  /// In en, this message translates to:
  /// **'Account name'**
  String get financeAccountName;

  /// No description provided for @financeAccountBalance.
  ///
  /// In en, this message translates to:
  /// **'Balance'**
  String get financeAccountBalance;

  /// No description provided for @financeAccountRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter a name.'**
  String get financeAccountRequired;

  /// No description provided for @financeArchiveAccount.
  ///
  /// In en, this message translates to:
  /// **'Archive'**
  String get financeArchiveAccount;

  /// No description provided for @financeCannotArchiveLastAccount.
  ///
  /// In en, this message translates to:
  /// **'Keep at least one account.'**
  String get financeCannotArchiveLastAccount;

  /// No description provided for @financeNewCategory.
  ///
  /// In en, this message translates to:
  /// **'New category'**
  String get financeNewCategory;

  /// No description provided for @financeEditCategory.
  ///
  /// In en, this message translates to:
  /// **'Edit category'**
  String get financeEditCategory;

  /// No description provided for @financeCategoryName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get financeCategoryName;

  /// No description provided for @financeCategoryNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter a name.'**
  String get financeCategoryNameRequired;

  /// No description provided for @financeArchiveCategory.
  ///
  /// In en, this message translates to:
  /// **'Archive'**
  String get financeArchiveCategory;

  /// No description provided for @financeDeleteCategory.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get financeDeleteCategory;

  /// No description provided for @financeBalance.
  ///
  /// In en, this message translates to:
  /// **'Balance'**
  String get financeBalance;

  /// No description provided for @financeSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get financeSave;

  /// No description provided for @financeCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get financeCancel;

  /// No description provided for @financeDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get financeDelete;

  /// No description provided for @financeColor.
  ///
  /// In en, this message translates to:
  /// **'Color'**
  String get financeColor;

  /// No description provided for @todayEditWidgets.
  ///
  /// In en, this message translates to:
  /// **'Widgets'**
  String get todayEditWidgets;

  /// No description provided for @todayWidgetsTitle.
  ///
  /// In en, this message translates to:
  /// **'Add widget'**
  String get todayWidgetsTitle;

  /// No description provided for @todayWidgetsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Pick a tile for your Today board.'**
  String get todayWidgetsSubtitle;

  /// No description provided for @todayWidgetFinance.
  ///
  /// In en, this message translates to:
  /// **'Month finance summary'**
  String get todayWidgetFinance;

  /// No description provided for @todayWidgetBudget.
  ///
  /// In en, this message translates to:
  /// **'Budget status'**
  String get todayWidgetBudget;

  /// No description provided for @todayWidgetSpend.
  ///
  /// In en, this message translates to:
  /// **'Spent today'**
  String get todayWidgetSpend;

  /// No description provided for @todayWidgetEvents.
  ///
  /// In en, this message translates to:
  /// **'Today’s events'**
  String get todayWidgetEvents;

  /// No description provided for @todayBudgetLeft.
  ///
  /// In en, this message translates to:
  /// **'Budget left'**
  String get todayBudgetLeft;

  /// No description provided for @todayMonthSpent.
  ///
  /// In en, this message translates to:
  /// **'Month spent'**
  String get todayMonthSpent;

  /// No description provided for @todayMonthBudget.
  ///
  /// In en, this message translates to:
  /// **'Month budget'**
  String get todayMonthBudget;

  /// No description provided for @todayEditLayout.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get todayEditLayout;

  /// No description provided for @todayDoneEditing.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get todayDoneEditing;

  /// No description provided for @todayAddWidget.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get todayAddWidget;

  /// No description provided for @todayWidgetBudgetRing.
  ///
  /// In en, this message translates to:
  /// **'Budget ring'**
  String get todayWidgetBudgetRing;

  /// No description provided for @todayWidgetCategoryDonut.
  ///
  /// In en, this message translates to:
  /// **'Category donut'**
  String get todayWidgetCategoryDonut;

  /// No description provided for @todayWidgetCashflow.
  ///
  /// In en, this message translates to:
  /// **'Cashflow'**
  String get todayWidgetCashflow;

  /// No description provided for @todayWidgetAccounts.
  ///
  /// In en, this message translates to:
  /// **'Accounts'**
  String get todayWidgetAccounts;

  /// No description provided for @todayWidgetEventsCount.
  ///
  /// In en, this message translates to:
  /// **'Events count'**
  String get todayWidgetEventsCount;

  /// No description provided for @todayResizeHint.
  ///
  /// In en, this message translates to:
  /// **'Edit to drag & resize'**
  String get todayResizeHint;

  /// No description provided for @todayWidgetSpent.
  ///
  /// In en, this message translates to:
  /// **'Month spent'**
  String get todayWidgetSpent;

  /// No description provided for @todayWidgetRemaining.
  ///
  /// In en, this message translates to:
  /// **'Remaining'**
  String get todayWidgetRemaining;

  /// No description provided for @todayAllWidgetsAdded.
  ///
  /// In en, this message translates to:
  /// **'Every widget is already on the board.'**
  String get todayAllWidgetsAdded;

  /// No description provided for @financeTabOverview.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get financeTabOverview;

  /// No description provided for @financeTabPlan.
  ///
  /// In en, this message translates to:
  /// **'Plan'**
  String get financeTabPlan;

  /// No description provided for @financeTabInsights.
  ///
  /// In en, this message translates to:
  /// **'Insights'**
  String get financeTabInsights;

  /// No description provided for @financeTabLedger.
  ///
  /// In en, this message translates to:
  /// **'Ledger'**
  String get financeTabLedger;

  /// No description provided for @financeCashflow.
  ///
  /// In en, this message translates to:
  /// **'Cashflow'**
  String get financeCashflow;

  /// No description provided for @financeOfBudget.
  ///
  /// In en, this message translates to:
  /// **'of budget'**
  String get financeOfBudget;

  /// No description provided for @financeLeft.
  ///
  /// In en, this message translates to:
  /// **'left'**
  String get financeLeft;

  /// No description provided for @financeNet.
  ///
  /// In en, this message translates to:
  /// **'Net'**
  String get financeNet;

  /// No description provided for @financeEqualSplit.
  ///
  /// In en, this message translates to:
  /// **'Equal split'**
  String get financeEqualSplit;

  /// No description provided for @googleCalendarTitle.
  ///
  /// In en, this message translates to:
  /// **'Google Calendar'**
  String get googleCalendarTitle;

  /// No description provided for @googleConnect.
  ///
  /// In en, this message translates to:
  /// **'Connect'**
  String get googleConnect;

  /// No description provided for @googleDisconnect.
  ///
  /// In en, this message translates to:
  /// **'Disconnect'**
  String get googleDisconnect;

  /// No description provided for @googleSyncNow.
  ///
  /// In en, this message translates to:
  /// **'Sync now'**
  String get googleSyncNow;

  /// No description provided for @googleConnected.
  ///
  /// In en, this message translates to:
  /// **'Connected'**
  String get googleConnected;

  /// No description provided for @googleDisconnected.
  ///
  /// In en, this message translates to:
  /// **'Not connected'**
  String get googleDisconnected;

  /// No description provided for @googleNeedsConfig.
  ///
  /// In en, this message translates to:
  /// **'Add OAuth client IDs in GoogleConfig (see TECHNICAL.md).'**
  String get googleNeedsConfig;

  /// No description provided for @googleSyncOk.
  ///
  /// In en, this message translates to:
  /// **'Google Calendar synced.'**
  String get googleSyncOk;

  /// No description provided for @googleSyncError.
  ///
  /// In en, this message translates to:
  /// **'Sync failed. Check connection and OAuth setup.'**
  String get googleSyncError;

  /// No description provided for @tasksInbox.
  ///
  /// In en, this message translates to:
  /// **'Inbox'**
  String get tasksInbox;

  /// No description provided for @tasksToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get tasksToday;

  /// No description provided for @tasksDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get tasksDone;

  /// No description provided for @tasksEmpty.
  ///
  /// In en, this message translates to:
  /// **'No tasks here yet.'**
  String get tasksEmpty;

  /// No description provided for @tasksNew.
  ///
  /// In en, this message translates to:
  /// **'New task'**
  String get tasksNew;

  /// No description provided for @tasksEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit task'**
  String get tasksEdit;

  /// No description provided for @tasksTitleHint.
  ///
  /// In en, this message translates to:
  /// **'What needs doing?'**
  String get tasksTitleHint;

  /// No description provided for @tasksNotesHint.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get tasksNotesHint;

  /// No description provided for @tasksTitleRequired.
  ///
  /// In en, this message translates to:
  /// **'Add a title.'**
  String get tasksTitleRequired;

  /// No description provided for @tasksDue.
  ///
  /// In en, this message translates to:
  /// **'Due date'**
  String get tasksDue;

  /// No description provided for @tasksClearDue.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get tasksClearDue;

  /// No description provided for @habitsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Streaks and daily check-ins.'**
  String get habitsSubtitle;

  /// No description provided for @habitsTabToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get habitsTabToday;

  /// No description provided for @habitsTabAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get habitsTabAll;

  /// No description provided for @habitsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No habits yet — add one.'**
  String get habitsEmpty;

  /// No description provided for @habitsNew.
  ///
  /// In en, this message translates to:
  /// **'New habit'**
  String get habitsNew;

  /// No description provided for @habitsEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit habit'**
  String get habitsEdit;

  /// No description provided for @habitsTitleHint.
  ///
  /// In en, this message translates to:
  /// **'Habit name'**
  String get habitsTitleHint;

  /// No description provided for @habitsNotesHint.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get habitsNotesHint;

  /// No description provided for @habitsTitleRequired.
  ///
  /// In en, this message translates to:
  /// **'Add a name.'**
  String get habitsTitleRequired;

  /// No description provided for @habitsStreak.
  ///
  /// In en, this message translates to:
  /// **'Kept it up for {count} days'**
  String habitsStreak(int count);

  /// No description provided for @habitsFreqDaily.
  ///
  /// In en, this message translates to:
  /// **'Daily'**
  String get habitsFreqDaily;

  /// No description provided for @habitsFreqWeekly.
  ///
  /// In en, this message translates to:
  /// **'N× / week'**
  String get habitsFreqWeekly;

  /// No description provided for @habitsCheckIn.
  ///
  /// In en, this message translates to:
  /// **'Check in'**
  String get habitsCheckIn;

  /// No description provided for @habitsDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete habit'**
  String get habitsDelete;

  /// No description provided for @routineSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Timed day slots — mark done as you go.'**
  String get routineSubtitle;

  /// No description provided for @routineEmpty.
  ///
  /// In en, this message translates to:
  /// **'No routines yet — create a morning or evening flow.'**
  String get routineEmpty;

  /// No description provided for @routineNew.
  ///
  /// In en, this message translates to:
  /// **'New routine'**
  String get routineNew;

  /// No description provided for @routineEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit routine'**
  String get routineEdit;

  /// No description provided for @routineTitleHint.
  ///
  /// In en, this message translates to:
  /// **'Routine name'**
  String get routineTitleHint;

  /// No description provided for @routineSlots.
  ///
  /// In en, this message translates to:
  /// **'Slots'**
  String get routineSlots;

  /// No description provided for @routineAddSlot.
  ///
  /// In en, this message translates to:
  /// **'Add slot'**
  String get routineAddSlot;

  /// No description provided for @routineSlotHint.
  ///
  /// In en, this message translates to:
  /// **'Slot title'**
  String get routineSlotHint;

  /// No description provided for @routineMinutes.
  ///
  /// In en, this message translates to:
  /// **'{count} min'**
  String routineMinutes(int count);

  /// No description provided for @routineStart.
  ///
  /// In en, this message translates to:
  /// **'Start time'**
  String get routineStart;

  /// No description provided for @routineToday.
  ///
  /// In en, this message translates to:
  /// **'Today\'s slots'**
  String get routineToday;

  /// No description provided for @routineNoSlotsToday.
  ///
  /// In en, this message translates to:
  /// **'Nothing scheduled for today.'**
  String get routineNoSlotsToday;

  /// No description provided for @routineTitleRequired.
  ///
  /// In en, this message translates to:
  /// **'Add a title.'**
  String get routineTitleRequired;

  /// No description provided for @routineDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete routine'**
  String get routineDelete;

  /// No description provided for @routineWeekdays.
  ///
  /// In en, this message translates to:
  /// **'Days'**
  String get routineWeekdays;

  /// No description provided for @nutritionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Daily calories and macros.'**
  String get nutritionSubtitle;

  /// No description provided for @nutritionToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get nutritionToday;

  /// No description provided for @nutritionSupplied.
  ///
  /// In en, this message translates to:
  /// **'Supplied'**
  String get nutritionSupplied;

  /// No description provided for @nutritionGoal.
  ///
  /// In en, this message translates to:
  /// **'Goal kcal'**
  String get nutritionGoal;

  /// No description provided for @nutritionKcalLeft.
  ///
  /// In en, this message translates to:
  /// **'kcal left'**
  String get nutritionKcalLeft;

  /// No description provided for @nutritionKcalOver.
  ///
  /// In en, this message translates to:
  /// **'kcal over'**
  String get nutritionKcalOver;

  /// No description provided for @nutritionKcal.
  ///
  /// In en, this message translates to:
  /// **'kcal'**
  String get nutritionKcal;

  /// No description provided for @nutritionCarbs.
  ///
  /// In en, this message translates to:
  /// **'Carbs'**
  String get nutritionCarbs;

  /// No description provided for @nutritionFat.
  ///
  /// In en, this message translates to:
  /// **'Fat'**
  String get nutritionFat;

  /// No description provided for @nutritionProtein.
  ///
  /// In en, this message translates to:
  /// **'Protein'**
  String get nutritionProtein;

  /// No description provided for @nutritionBreakfast.
  ///
  /// In en, this message translates to:
  /// **'Breakfast'**
  String get nutritionBreakfast;

  /// No description provided for @nutritionLunch.
  ///
  /// In en, this message translates to:
  /// **'Lunch'**
  String get nutritionLunch;

  /// No description provided for @nutritionDinner.
  ///
  /// In en, this message translates to:
  /// **'Dinner'**
  String get nutritionDinner;

  /// No description provided for @nutritionSnack.
  ///
  /// In en, this message translates to:
  /// **'Snack'**
  String get nutritionSnack;

  /// No description provided for @nutritionEmptyHint.
  ///
  /// In en, this message translates to:
  /// **'Log your first meal with + on a section.'**
  String get nutritionEmptyHint;

  /// No description provided for @nutritionAddEntry.
  ///
  /// In en, this message translates to:
  /// **'Add food'**
  String get nutritionAddEntry;

  /// No description provided for @nutritionEditEntry.
  ///
  /// In en, this message translates to:
  /// **'Edit food'**
  String get nutritionEditEntry;

  /// No description provided for @nutritionFoodName.
  ///
  /// In en, this message translates to:
  /// **'Food name'**
  String get nutritionFoodName;

  /// No description provided for @nutritionNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Add a food name.'**
  String get nutritionNameRequired;

  /// No description provided for @nutritionEditGoals.
  ///
  /// In en, this message translates to:
  /// **'Daily goals'**
  String get nutritionEditGoals;

  /// No description provided for @trainingTodayLabel.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get trainingTodayLabel;

  /// No description provided for @trainingTodaysFocus.
  ///
  /// In en, this message translates to:
  /// **'Today\'s focus'**
  String get trainingTodaysFocus;

  /// No description provided for @trainingFocusTitle.
  ///
  /// In en, this message translates to:
  /// **'Train'**
  String get trainingFocusTitle;

  /// No description provided for @trainingFocusSubtitle.
  ///
  /// In en, this message translates to:
  /// **'{count} routines ready'**
  String trainingFocusSubtitle(int count);

  /// No description provided for @trainingFirstHint.
  ///
  /// In en, this message translates to:
  /// **'Create a routine, then hit play.'**
  String get trainingFirstHint;

  /// No description provided for @trainingStartWorkout.
  ///
  /// In en, this message translates to:
  /// **'Start workout'**
  String get trainingStartWorkout;

  /// No description provided for @trainingThisWeek.
  ///
  /// In en, this message translates to:
  /// **'This week'**
  String get trainingThisWeek;

  /// No description provided for @trainingSessions.
  ///
  /// In en, this message translates to:
  /// **'Sessions'**
  String get trainingSessions;

  /// No description provided for @trainingTodaySessions.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get trainingTodaySessions;

  /// No description provided for @trainingYourWorkouts.
  ///
  /// In en, this message translates to:
  /// **'Your workouts'**
  String get trainingYourWorkouts;

  /// No description provided for @trainingEmpty.
  ///
  /// In en, this message translates to:
  /// **'No workouts yet — build one below.'**
  String get trainingEmpty;

  /// No description provided for @trainingNewWorkout.
  ///
  /// In en, this message translates to:
  /// **'New workout'**
  String get trainingNewWorkout;

  /// No description provided for @trainingEditWorkout.
  ///
  /// In en, this message translates to:
  /// **'Edit workout'**
  String get trainingEditWorkout;

  /// No description provided for @trainingTitleHint.
  ///
  /// In en, this message translates to:
  /// **'Workout name'**
  String get trainingTitleHint;

  /// No description provided for @trainingTitleRequired.
  ///
  /// In en, this message translates to:
  /// **'Add a title.'**
  String get trainingTitleRequired;

  /// No description provided for @trainingExercises.
  ///
  /// In en, this message translates to:
  /// **'Exercises'**
  String get trainingExercises;

  /// No description provided for @trainingExerciseHint.
  ///
  /// In en, this message translates to:
  /// **'Exercise name'**
  String get trainingExerciseHint;

  /// No description provided for @trainingAddExercise.
  ///
  /// In en, this message translates to:
  /// **'Add exercise'**
  String get trainingAddExercise;

  /// No description provided for @trainingAddExerciseHint.
  ///
  /// In en, this message translates to:
  /// **'Add an exercise to start logging sets.'**
  String get trainingAddExerciseHint;

  /// No description provided for @trainingExerciseCount.
  ///
  /// In en, this message translates to:
  /// **'{count} exercises'**
  String trainingExerciseCount(int count);

  /// No description provided for @trainingSetsShort.
  ///
  /// In en, this message translates to:
  /// **'Sets'**
  String get trainingSetsShort;

  /// No description provided for @trainingRepsShort.
  ///
  /// In en, this message translates to:
  /// **'Reps'**
  String get trainingRepsShort;

  /// No description provided for @trainingReps.
  ///
  /// In en, this message translates to:
  /// **'reps'**
  String get trainingReps;

  /// No description provided for @trainingWeightKg.
  ///
  /// In en, this message translates to:
  /// **'kg'**
  String get trainingWeightKg;

  /// No description provided for @trainingLogSet.
  ///
  /// In en, this message translates to:
  /// **'Log set'**
  String get trainingLogSet;

  /// No description provided for @trainingInProgress.
  ///
  /// In en, this message translates to:
  /// **'In progress'**
  String get trainingInProgress;

  /// No description provided for @trainingFinish.
  ///
  /// In en, this message translates to:
  /// **'Finish workout'**
  String get trainingFinish;

  /// No description provided for @trainingQuickSession.
  ///
  /// In en, this message translates to:
  /// **'Quick session'**
  String get trainingQuickSession;

  /// No description provided for @trainingDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete workout'**
  String get trainingDelete;

  /// No description provided for @financeSeeMore.
  ///
  /// In en, this message translates to:
  /// **'See more'**
  String get financeSeeMore;

  /// No description provided for @financeQuickExpense.
  ///
  /// In en, this message translates to:
  /// **'Expense'**
  String get financeQuickExpense;

  /// No description provided for @financeQuickIncome.
  ///
  /// In en, this message translates to:
  /// **'Income'**
  String get financeQuickIncome;

  /// No description provided for @financeQuickBudget.
  ///
  /// In en, this message translates to:
  /// **'Budget'**
  String get financeQuickBudget;

  /// No description provided for @financeQuickAccounts.
  ///
  /// In en, this message translates to:
  /// **'Accounts'**
  String get financeQuickAccounts;

  /// No description provided for @financeRecentTx.
  ///
  /// In en, this message translates to:
  /// **'Transactions'**
  String get financeRecentTx;
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
