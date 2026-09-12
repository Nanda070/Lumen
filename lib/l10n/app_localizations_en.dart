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
  String todayEventsMore(int count) {
    return '+$count more';
  }

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

  @override
  String get catFood => 'Food';

  @override
  String get catTransport => 'Transport';

  @override
  String get catHome => 'Home';

  @override
  String get catShopping => 'Shopping';

  @override
  String get catHealth => 'Health';

  @override
  String get catOtherExpense => 'Other';

  @override
  String get catSalary => 'Salary';

  @override
  String get catOtherIncome => 'Other income';

  @override
  String get financeSpent => 'Spent';

  @override
  String get financeRemaining => 'Remaining';

  @override
  String get financeBudget => 'Budget';

  @override
  String get financeIncome => 'Income';

  @override
  String get financeNoBudget => 'No budget set';

  @override
  String get financeSetBudget => 'Set budget';

  @override
  String get financeEditBudget => 'Edit budget';

  @override
  String get financeBudgetHint => 'Monthly spending limit';

  @override
  String get financeBudgetTotal => 'Total monthly limit';

  @override
  String get financeAllocations => 'Category plan';

  @override
  String get financeAllocationsHint => 'Allocate within your budget';

  @override
  String financeAllocationFor(String category) {
    return '$category';
  }

  @override
  String get financeStatusOk => 'On track';

  @override
  String get financeStatusWarning => 'Almost there';

  @override
  String get financeStatusOver => 'Overspent';

  @override
  String get financeStatusNone => 'Set a budget';

  @override
  String get financeVsPlan => 'vs plan';

  @override
  String financeOverBy(String amount) {
    return 'Over by $amount';
  }

  @override
  String financeUnderBy(String amount) {
    return '$amount left in plan';
  }

  @override
  String get financeByCategory => 'By category';

  @override
  String get financeTrend => 'Daily spend';

  @override
  String get financeTransactions => 'Transactions';

  @override
  String get financeEmptyTx => 'No transactions this month.';

  @override
  String get financeAddTx => 'Add';

  @override
  String get financeNewTx => 'New transaction';

  @override
  String get financeEditTx => 'Edit transaction';

  @override
  String get financeAmount => 'Amount';

  @override
  String get financeAmountRequired => 'Enter an amount.';

  @override
  String get financeNote => 'Note';

  @override
  String get financeNoteHint => 'Optional note';

  @override
  String get financeCategory => 'Category';

  @override
  String get financeAccount => 'Account';

  @override
  String get financeDate => 'Date';

  @override
  String get financeTypeExpense => 'Expense';

  @override
  String get financeTypeIncome => 'Income';

  @override
  String get financeFilterAll => 'All';

  @override
  String get financeSaveError => 'Could not save.';

  @override
  String get financeDeleteTxTitle => 'Delete transaction?';

  @override
  String get financeDeleteTxBody =>
      'This removes it from your ledger and updates the account balance.';

  @override
  String get financeAccounts => 'Accounts';

  @override
  String get financeCategories => 'Categories';

  @override
  String get financeManageAccounts => 'Manage accounts';

  @override
  String get financeManageCategories => 'Manage categories';

  @override
  String get financeNewAccount => 'New account';

  @override
  String get financeEditAccount => 'Edit account';

  @override
  String get financeAccountName => 'Account name';

  @override
  String get financeAccountBalance => 'Balance';

  @override
  String get financeAccountRequired => 'Enter a name.';

  @override
  String get financeArchiveAccount => 'Archive';

  @override
  String get financeCannotArchiveLastAccount => 'Keep at least one account.';

  @override
  String get financeNewCategory => 'New category';

  @override
  String get financeEditCategory => 'Edit category';

  @override
  String get financeCategoryName => 'Name';

  @override
  String get financeCategoryNameRequired => 'Enter a name.';

  @override
  String get financeArchiveCategory => 'Archive';

  @override
  String get financeDeleteCategory => 'Delete';

  @override
  String get financeBalance => 'Balance';

  @override
  String get financeSave => 'Save';

  @override
  String get financeCancel => 'Cancel';

  @override
  String get financeDelete => 'Delete';

  @override
  String get financeColor => 'Color';

  @override
  String get todayEditWidgets => 'Widgets';

  @override
  String get todayWidgetsTitle => 'Add widget';

  @override
  String get todayWidgetsSubtitle => 'Pick a tile for your Today board.';

  @override
  String get todayWidgetFinance => 'Month finance summary';

  @override
  String get todayWidgetBudget => 'Budget status';

  @override
  String get todayWidgetSpend => 'Spent today';

  @override
  String get todayWidgetEvents => 'Today’s events';

  @override
  String get todayBudgetLeft => 'Budget left';

  @override
  String get todayMonthSpent => 'Month spent';

  @override
  String get todayMonthBudget => 'Month budget';

  @override
  String get todayEditLayout => 'Edit';

  @override
  String get todayDoneEditing => 'Done';

  @override
  String get todayAddWidget => 'Add';

  @override
  String get todayWidgetBudgetRing => 'Budget ring';

  @override
  String get todayWidgetCategoryDonut => 'Category donut';

  @override
  String get todayWidgetCashflow => 'Cashflow';

  @override
  String get todayWidgetAccounts => 'Accounts';

  @override
  String get todayWidgetEventsCount => 'Events count';

  @override
  String get todayResizeHint => 'Edit to drag & resize';

  @override
  String get todayWidgetSpent => 'Month spent';

  @override
  String get todayWidgetRemaining => 'Remaining';

  @override
  String get todayAllWidgetsAdded => 'Every widget is already on the board.';

  @override
  String get financeTabOverview => 'Overview';

  @override
  String get financeTabPlan => 'Plan';

  @override
  String get financeTabInsights => 'Insights';

  @override
  String get financeTabLedger => 'Ledger';

  @override
  String get financeCashflow => 'Cashflow';

  @override
  String get financeOfBudget => 'of budget';

  @override
  String get financeLeft => 'left';

  @override
  String get financeNet => 'Net';

  @override
  String get financeEqualSplit => 'Equal split';

  @override
  String get googleCalendarTitle => 'Google Calendar';

  @override
  String get googleConnect => 'Connect';

  @override
  String get googleDisconnect => 'Disconnect';

  @override
  String get googleSyncNow => 'Sync now';

  @override
  String get googleConnected => 'Connected';

  @override
  String get googleDisconnected => 'Not connected';

  @override
  String get googleNeedsConfig =>
      'Add OAuth client IDs in GoogleConfig (see TECHNICAL.md).';

  @override
  String get googleSyncOk => 'Google Calendar synced.';

  @override
  String get googleSyncError =>
      'Sync failed. Check connection and OAuth setup.';

  @override
  String get tasksInbox => 'Inbox';

  @override
  String get tasksToday => 'Today';

  @override
  String get tasksDone => 'Done';

  @override
  String get tasksEmpty => 'No tasks here yet.';

  @override
  String get tasksNew => 'New task';

  @override
  String get tasksEdit => 'Edit task';

  @override
  String get tasksTitleHint => 'What needs doing?';

  @override
  String get tasksNotesHint => 'Notes';

  @override
  String get tasksTitleRequired => 'Add a title.';

  @override
  String get tasksDue => 'Due date';

  @override
  String get tasksClearDue => 'Clear';

  @override
  String get habitsSubtitle => 'Streaks and daily check-ins.';

  @override
  String get habitsTabToday => 'Today';

  @override
  String get habitsTabAll => 'All';

  @override
  String get habitsEmpty => 'No habits yet — add one.';

  @override
  String get habitsNew => 'New habit';

  @override
  String get habitsEdit => 'Edit habit';

  @override
  String get habitsTitleHint => 'Habit name';

  @override
  String get habitsNotesHint => 'Notes';

  @override
  String get habitsTitleRequired => 'Add a name.';

  @override
  String habitsStreak(int count) {
    return 'Kept it up for $count days';
  }

  @override
  String get habitsFreqDaily => 'Daily';

  @override
  String get habitsFreqWeekly => 'N× / week';

  @override
  String get habitsCheckIn => 'Check in';

  @override
  String get habitsDelete => 'Delete habit';

  @override
  String get routineSubtitle => 'Timed day slots — mark done as you go.';

  @override
  String get routineEmpty =>
      'No routines yet — create a morning or evening flow.';

  @override
  String get routineNew => 'New routine';

  @override
  String get routineEdit => 'Edit routine';

  @override
  String get routineTitleHint => 'Routine name';

  @override
  String get routineSlots => 'Slots';

  @override
  String get routineAddSlot => 'Add slot';

  @override
  String get routineSlotHint => 'Slot title';

  @override
  String routineMinutes(int count) {
    return '$count min';
  }

  @override
  String get routineStart => 'Start time';

  @override
  String get routineToday => 'Today\'s slots';

  @override
  String get routineNoSlotsToday => 'Nothing scheduled for today.';

  @override
  String get routineTitleRequired => 'Add a title.';

  @override
  String get routineDelete => 'Delete routine';

  @override
  String get routineWeekdays => 'Days';

  @override
  String get nutritionSubtitle => 'Daily calories and macros.';

  @override
  String get nutritionToday => 'Today';

  @override
  String get nutritionSupplied => 'Supplied';

  @override
  String get nutritionGoal => 'Goal kcal';

  @override
  String get nutritionKcalLeft => 'kcal left';

  @override
  String get nutritionKcalOver => 'kcal over';

  @override
  String get nutritionKcal => 'kcal';

  @override
  String get nutritionCarbs => 'Carbs';

  @override
  String get nutritionFat => 'Fat';

  @override
  String get nutritionProtein => 'Protein';

  @override
  String get nutritionBreakfast => 'Breakfast';

  @override
  String get nutritionLunch => 'Lunch';

  @override
  String get nutritionDinner => 'Dinner';

  @override
  String get nutritionSnack => 'Snack';

  @override
  String get nutritionEmptyHint => 'Log your first meal with + on a section.';

  @override
  String get nutritionAddEntry => 'Add food';

  @override
  String get nutritionEditEntry => 'Edit food';

  @override
  String get nutritionFoodName => 'Food name';

  @override
  String get nutritionNameRequired => 'Add a food name.';

  @override
  String get nutritionEditGoals => 'Daily goals';

  @override
  String get trainingTodayLabel => 'Today';

  @override
  String get trainingTodaysFocus => 'Today\'s focus';

  @override
  String get trainingFocusTitle => 'Train';

  @override
  String trainingFocusSubtitle(int count) {
    return '$count routines ready';
  }

  @override
  String get trainingFirstHint => 'Create a routine, then hit play.';

  @override
  String get trainingStartWorkout => 'Start workout';

  @override
  String get trainingThisWeek => 'This week';

  @override
  String get trainingSessions => 'Sessions';

  @override
  String get trainingTodaySessions => 'Today';

  @override
  String get trainingYourWorkouts => 'Your workouts';

  @override
  String get trainingEmpty => 'No workouts yet — build one below.';

  @override
  String get trainingNewWorkout => 'New workout';

  @override
  String get trainingEditWorkout => 'Edit workout';

  @override
  String get trainingTitleHint => 'Workout name';

  @override
  String get trainingTitleRequired => 'Add a title.';

  @override
  String get trainingExercises => 'Exercises';

  @override
  String get trainingExerciseHint => 'Exercise name';

  @override
  String get trainingAddExercise => 'Add exercise';

  @override
  String get trainingAddExerciseHint =>
      'Add an exercise to start logging sets.';

  @override
  String trainingExerciseCount(int count) {
    return '$count exercises';
  }

  @override
  String get trainingSetsShort => 'Sets';

  @override
  String get trainingRepsShort => 'Reps';

  @override
  String get trainingReps => 'reps';

  @override
  String get trainingWeightKg => 'kg';

  @override
  String get trainingLogSet => 'Log set';

  @override
  String get trainingInProgress => 'In progress';

  @override
  String get trainingFinish => 'Finish workout';

  @override
  String get trainingQuickSession => 'Quick session';

  @override
  String get trainingDelete => 'Delete workout';

  @override
  String get financeSeeMore => 'See more';

  @override
  String get financeQuickExpense => 'Expense';

  @override
  String get financeQuickIncome => 'Income';

  @override
  String get financeQuickBudget => 'Budget';

  @override
  String get financeQuickAccounts => 'Accounts';

  @override
  String get financeRecentTx => 'Transactions';
}
