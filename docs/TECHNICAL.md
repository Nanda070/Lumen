# Lumen — technical documentation

Канонический tech/dev документ. Продуктовый план: [PLAN.md](PLAN.md). Стиль: [STYLE.md](STYLE.md). Чеклист: [TODOS.md](TODOS.md).

---

## Owner / Contacts

| | |
|---|---|
| Owner & Developer | **Nanda** |
| Company | **Cheterin Group** |
| Email | adnan.huseynli1@gmail.com |
| Telegram | nanda070 |
| Discord | nandak070 |
| Discord server | [discord.gg/cheterin](https://discord.gg/cheterin) |
| GitHub | [nanda070](https://github.com/nanda070) |

Эти контакты дублируются в README, More → About и project rules. При правках документации/About держать в синхроне.

---

## Product

**Lumen** — локальный life OS: календарь и финансы живые первыми, остальные модули — «комнаты». Без сервера Lumen, без аккаунта: источник правды — SQLite на устройстве.

Аудитория: Nanda и близкие (TestFlight / IPA / APK / Flutter Web). Язык: EN по умолчанию, RU в онбординге и More.

---

## Stack & dependencies

| Layer | Choice |
|---|---|
| UI | Flutter (iOS-first, Android + Web) |
| Local DB | Drift + SQLite (`drift`, `drift_flutter`) |
| Web SQLite | `web/sqlite3.wasm` + `web/drift_worker.js` |
| Charts | `fl_chart` — donut + daily bars on Finance |
| i18n | `flutter gen-l10n` — `lib/l10n/app_en.arb` / `app_ru.arb` |
| Fonts | `google_fonts` → Outfit |
| Icons | `phosphor_icons` |
| Paths | `path_provider` (native; web via drift_flutter) |

Dev: `drift_dev`, `build_runner`, `flutter_lints`, `flutter_test`.

Нет: Riverpod/Provider, SharedPreferences (пока), Google Sign-In (позже).

---

## Folder map

```
lib/
  main.dart
  app.dart
  core/
    region_options.dart
    world_currencies.dart
  data/
    tables.dart             # Drift tables (schema v3)
    app_database.dart       # CRUD + seed + migrations + month summary
    app_database.g.dart
  design_system/
  features/
    onboarding/
    today/                  # hub widgets + prefs sheet
    calendar/
    finance/                # page, charts, tx/budget/managers sheets
    tasks/ more/
  shell/
  l10n/
docs/
web/
```

---

## Architecture

1. **`LumenApp`** opens `AppDatabase`, loads profile.
2. No profile → **`OnboardingFlow`** → seed calendars / categories / Cash account / Today prefs.
3. Profile exists → **`AppShell`**: phone floating glass tabs / wide left rail.
4. Today, Calendar, Finance, More receive `AppDatabase` for live streams.
5. Amounts stored as **minor units** (cents); account balance updated on tx insert/update/delete.

### Safe area

- Phone: `AppShell` wraps body in `SafeArea(bottom: false)` — top clears Dynamic Island/status bar; bottom left for floating tab bar.
- Wide: `SafeArea` around rail + content.
- Onboarding / loading / error: own `SafeArea`.
- Module titles use `LumenSpacing.lg` air **after** SafeArea.

---

## Database

**Schema version:** 3  
**Name:** `lumen` (Drift / sqlite)

| Table | Purpose |
|---|---|
| `profiles` | displayName, localeCode, countryCode, currencyCode, createdAt |
| `calendars` | Named calendars + colorArgb; seed Personal / Lumen |
| `events` | title, startsAt, endsAt, calendarId, createdAt, updatedAt |
| `finance_categories` | nameKey, displayName?, kind expense\|income, color, isSystem, isArchived |
| `finance_accounts` | name, balanceMinor, currencyCode, sortOrder, isArchived |
| `monthly_budgets` | year, month, totalLimitMinor |
| `category_allocations` | year, month, categoryId, allocatedMinor |
| `finance_transactions` | amountMinor, kind, categoryId, accountId, occurredAt, note |
| `today_preferences` | showFinanceSummary / Budget / Spend / Events + widgetOrder |

**Seed** (onboarding + `beforeOpen` bootstrap for upgrades): Personal/Lumen calendars, default expense/income categories, one **Cash** account in profile currency, default Today prefs (all on).

**Migration**

- &lt;2 → create `events`
- &lt;3 → add category columns; create accounts / budgets / allocations / transactions / today_preferences; mark seeded categories `is_system`

**Storage:** native SQLite via `driftDatabase(name: 'lumen')`; web Wasm + IndexedDb.

---

## Finance (shipped)

- Month switcher; spent / remaining / budget / income metrics (gradient + glow).
- Monthly budget + per-category allocations with vs-plan progress.
- Accounts CRUD (archive; at least one kept); category create/edit/archive.
- Transactions CRUD (amount, kind, category, account, date, note); balance sync.
- Filters: all / expense / income / category chips.
- Charts: donut by category, bar trend by day (`fl_chart`).
- Budget status chip: ok / warning / overspend / none.

---

## Today (shipped)

Live hub widgets (order via `widgetOrder`, visibility toggles in Drift):

1. Finance summary (month spent + budget left)
2. Budget status bar
3. Spent today + upcoming count
4. Today’s calendar events

Configure: Today trailing sliders icon, or More → Settings → Widgets.

---

## Calendar (shipped)

- Day / Week / Month, now-line, cream Quick Add, CRUD sheet.
- No Google sync in this layer.

---

## Navigation & i18n

Tabs: Today · Calendar · Tasks · Finance · More.  
Locale from profile; switch in More. ARB → `AppLocalizations` (category labels + finance/today strings EN/RU).

---

## Design system

Tokens in `lib/design_system/` per STYLE.md: charcoal, violet bloom, glass, glow cards, gradient metrics, Outfit, Phosphor.

---

## Platforms & run

```bash
flutter pub get
dart run build_runner build   # after Drift schema changes
flutter gen-l10n              # after ARB changes
flutter analyze
flutter test

flutter run -d chrome
flutter run -d <ios-simulator-id>   # e.g. iPhone 17
```

After features: stop old `flutter run`, restart **web + iOS**, update this file (see `.cursor/rules/`).

---

## Implemented vs stubs

| Area | Status |
|---|---|
| Design system + shell | Live |
| Onboarding + profile + seed | Live |
| Base currency (154 ISO, searchable) | Live |
| Calendar local Day/Week/Month + CRUD | Live |
| Finance core (accounts, budget, txs, charts) | Live |
| Today hub widgets + prefs | Live |
| Tasks / Habits / Routine / Nutrition / Training | Stub rooms |
| Google Calendar sync | Not started |
| `.lumen` backup | Not started |

---

## Key decisions

- Local-first SQLite over cloud account.
- Money as integer minor units; profile currency on accounts.
- Custom calendar canvas (not `table_calendar` as final UI).
- EN default; RU first-class ARB.
- Premium charcoal/violet language intentional (STYLE over generic anti-purple rules).
- Full ISO currency list + search.
- Contacts stay human-facing (docs + More), bundle id unchanged.
