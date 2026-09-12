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
  String get todayEmptyEvents => 'На сегодня пусто — добавьте в Календаре.';

  @override
  String get todaySampleEvent => 'Утренний фокус';

  @override
  String get todaySampleTime => '09:00 – 10:30';

  @override
  String get roomComingSoon => 'Скоро';

  @override
  String get calendarSubtitle => 'День, неделя и месяц — локальный холст.';

  @override
  String get calendarViewDay => 'День';

  @override
  String get calendarViewWeek => 'Неделя';

  @override
  String get calendarViewMonth => 'Месяц';

  @override
  String get eventQuickAdd => 'Добавить';

  @override
  String get eventNewTitle => 'Новое событие';

  @override
  String get eventEditTitle => 'Событие';

  @override
  String get eventTitleHint => 'Название';

  @override
  String get eventTitleRequired => 'Введите название.';

  @override
  String get eventCalendarRequired => 'Выберите календарь.';

  @override
  String get eventTimeInvalid => 'Конец должен быть позже начала.';

  @override
  String get eventSaveError => 'Не удалось сохранить событие.';

  @override
  String get eventDate => 'Дата';

  @override
  String get eventStart => 'Начало';

  @override
  String get eventEnd => 'Конец';

  @override
  String get eventCalendar => 'Календарь';

  @override
  String get eventCreate => 'Создать';

  @override
  String get eventSave => 'Сохранить';

  @override
  String get eventCancel => 'Отмена';

  @override
  String get eventDelete => 'Удалить';

  @override
  String get eventDeleteTitle => 'Удалить событие?';

  @override
  String get eventDeleteBody =>
      'Событие будет удалено из локального календаря.';

  @override
  String get weekdayMon => 'пн';

  @override
  String get weekdayTue => 'вт';

  @override
  String get weekdayWed => 'ср';

  @override
  String get weekdayThu => 'чт';

  @override
  String get weekdayFri => 'пт';

  @override
  String get weekdaySat => 'сб';

  @override
  String get weekdaySun => 'вс';

  @override
  String get monthJan => 'Январь';

  @override
  String get monthFeb => 'Февраль';

  @override
  String get monthMar => 'Март';

  @override
  String get monthApr => 'Апрель';

  @override
  String get monthMay => 'Май';

  @override
  String get monthJun => 'Июнь';

  @override
  String get monthJul => 'Июль';

  @override
  String get monthAug => 'Август';

  @override
  String get monthSep => 'Сентябрь';

  @override
  String get monthOct => 'Октябрь';

  @override
  String get monthNov => 'Ноябрь';

  @override
  String get monthDec => 'Декабрь';

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
      'Предложена по региону — можно найти любую валюту мира.';

  @override
  String get currencySelectedLabel => 'Выбрано';

  @override
  String get currencyPickerHint =>
      'Нажмите, чтобы искать среди всех ISO-валют.';

  @override
  String get currencySearchHint => 'Код или название';

  @override
  String get currencySearchEmpty => 'Ничего не найдено.';

  @override
  String get moreAbout => 'О приложении';

  @override
  String get moreAboutBody => 'Lumen · Nanda · Cheterin Group';

  @override
  String get moreContactEmail => 'Email';

  @override
  String get moreContactTelegram => 'Telegram';

  @override
  String get moreContactDiscord => 'Discord';

  @override
  String get moreContactGithub => 'GitHub';

  @override
  String get moreContactServer => 'Discord-сервер';

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

  @override
  String get catFood => 'Еда';

  @override
  String get catTransport => 'Транспорт';

  @override
  String get catHome => 'Дом';

  @override
  String get catShopping => 'Покупки';

  @override
  String get catHealth => 'Здоровье';

  @override
  String get catOtherExpense => 'Другое';

  @override
  String get catSalary => 'Зарплата';

  @override
  String get catOtherIncome => 'Прочий доход';

  @override
  String get financeSpent => 'Потрачено';

  @override
  String get financeRemaining => 'Остаток';

  @override
  String get financeBudget => 'Бюджет';

  @override
  String get financeIncome => 'Доход';

  @override
  String get financeNoBudget => 'Бюджет не задан';

  @override
  String get financeSetBudget => 'Задать бюджет';

  @override
  String get financeEditBudget => 'Изменить бюджет';

  @override
  String get financeBudgetHint => 'Лимит трат на месяц';

  @override
  String get financeBudgetTotal => 'Общий лимит месяца';

  @override
  String get financeAllocations => 'План по категориям';

  @override
  String get financeAllocationsHint => 'Распределите в рамках бюджета';

  @override
  String financeAllocationFor(String category) {
    return '$category';
  }

  @override
  String get financeStatusOk => 'В плане';

  @override
  String get financeStatusWarning => 'Почти на пределе';

  @override
  String get financeStatusOver => 'Перерасход';

  @override
  String get financeStatusNone => 'Задайте бюджет';

  @override
  String get financeVsPlan => 'к плану';

  @override
  String financeOverBy(String amount) {
    return 'Сверх плана на $amount';
  }

  @override
  String financeUnderBy(String amount) {
    return 'В плане ещё $amount';
  }

  @override
  String get financeByCategory => 'По категориям';

  @override
  String get financeTrend => 'Расход по дням';

  @override
  String get financeTransactions => 'Операции';

  @override
  String get financeEmptyTx => 'В этом месяце операций нет.';

  @override
  String get financeAddTx => 'Добавить';

  @override
  String get financeNewTx => 'Новая операция';

  @override
  String get financeEditTx => 'Операция';

  @override
  String get financeAmount => 'Сумма';

  @override
  String get financeAmountRequired => 'Введите сумму.';

  @override
  String get financeNote => 'Заметка';

  @override
  String get financeNoteHint => 'Необязательно';

  @override
  String get financeCategory => 'Категория';

  @override
  String get financeAccount => 'Счёт';

  @override
  String get financeDate => 'Дата';

  @override
  String get financeTypeExpense => 'Расход';

  @override
  String get financeTypeIncome => 'Доход';

  @override
  String get financeFilterAll => 'Все';

  @override
  String get financeSaveError => 'Не удалось сохранить.';

  @override
  String get financeDeleteTxTitle => 'Удалить операцию?';

  @override
  String get financeDeleteTxBody =>
      'Она исчезнет из журнала, баланс счёта обновится.';

  @override
  String get financeAccounts => 'Счета';

  @override
  String get financeCategories => 'Категории';

  @override
  String get financeManageAccounts => 'Счета';

  @override
  String get financeManageCategories => 'Категории';

  @override
  String get financeNewAccount => 'Новый счёт';

  @override
  String get financeEditAccount => 'Счёт';

  @override
  String get financeAccountName => 'Название';

  @override
  String get financeAccountBalance => 'Баланс';

  @override
  String get financeAccountRequired => 'Введите название.';

  @override
  String get financeArchiveAccount => 'Архив';

  @override
  String get financeCannotArchiveLastAccount => 'Нужен хотя бы один счёт.';

  @override
  String get financeNewCategory => 'Новая категория';

  @override
  String get financeEditCategory => 'Категория';

  @override
  String get financeCategoryName => 'Название';

  @override
  String get financeCategoryNameRequired => 'Введите название.';

  @override
  String get financeArchiveCategory => 'Архив';

  @override
  String get financeDeleteCategory => 'Удалить';

  @override
  String get financeBalance => 'Баланс';

  @override
  String get financeSave => 'Сохранить';

  @override
  String get financeCancel => 'Отмена';

  @override
  String get financeDelete => 'Удалить';

  @override
  String get financeColor => 'Цвет';

  @override
  String get todayEditWidgets => 'Виджеты';

  @override
  String get todayWidgetsTitle => 'Добавить виджет';

  @override
  String get todayWidgetsSubtitle => 'Выберите плитку для доски Today.';

  @override
  String get todayWidgetFinance => 'Сводка финансов месяца';

  @override
  String get todayWidgetBudget => 'Статус бюджета';

  @override
  String get todayWidgetSpend => 'Расход за день';

  @override
  String get todayWidgetEvents => 'События сегодня';

  @override
  String get todayBudgetLeft => 'Остаток бюджета';

  @override
  String get todayMonthSpent => 'Потрачено за месяц';

  @override
  String get todayMonthBudget => 'Бюджет месяца';

  @override
  String get todayEditLayout => 'Изменить';

  @override
  String get todayDoneEditing => 'Готово';

  @override
  String get todayAddWidget => 'Добавить';

  @override
  String get todayWidgetBudgetRing => 'Кольцо бюджета';

  @override
  String get todayWidgetCategoryDonut => 'Донат по категориям';

  @override
  String get todayWidgetCashflow => 'Кэшфлоу';

  @override
  String get todayWidgetAccounts => 'Счета';

  @override
  String get todayWidgetEventsCount => 'Число событий';

  @override
  String get todayResizeHint => 'Измените, чтобы перетаскивать и менять размер';

  @override
  String get todayWidgetSpent => 'Потрачено';

  @override
  String get todayWidgetRemaining => 'Остаток';

  @override
  String get todayAllWidgetsAdded => 'Все виджеты уже на доске.';

  @override
  String get financeTabOverview => 'Обзор';

  @override
  String get financeTabPlan => 'План';

  @override
  String get financeTabInsights => 'Аналитика';

  @override
  String get financeTabLedger => 'Леджер';

  @override
  String get financeCashflow => 'Кэшфлоу';

  @override
  String get financeOfBudget => 'от бюджета';

  @override
  String get financeLeft => 'осталось';

  @override
  String get financeNet => 'Нетто';

  @override
  String get financeEqualSplit => 'Поровну';
}
