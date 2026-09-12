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

**Lumen** — локальный life OS: календарь, финансы и задачи живые; Habits/Routine/Nutrition/Training — комнаты. Без сервера Lumen: источник правды — SQLite на устройстве. Google Calendar — опциональный linked sync.

Аудитория: Nanda и близкие. Язык: EN по умолчанию, RU в онбординге и More.

---

## Stack & dependencies

| Layer | Choice |
|---|---|
| UI | Flutter (iOS-first, Android + Web) |
| Local DB | Drift + SQLite (`drift`, `drift_flutter`) |
| Web SQLite | `web/sqlite3.wasm` + `web/drift_worker.js` |
| Charts | `fl_chart` — budget ring, donut, cashflow line, weekly bars |
| Dashboard | `dashboard` ^0.0.4 — drag/resize Today widgets |
| Google | `google_sign_in` ^7, `googleapis`, `extension_google_sign_in_as_googleapis_auth`, `http` |
| i18n | `flutter gen-l10n` — `lib/l10n/app_en.arb` / `app_ru.arb` |
| Fonts | `google_fonts` → Outfit |
| Icons | `phosphor_icons` |

Dev: `drift_dev`, `build_runner`, `flutter_lints`, `flutter_test`.

---

## Folder map

```
lib/
  main.dart / app.dart
  core/
    google_config.dart      # OAuth client ID placeholders
    region_options.dart
    world_currencies.dart
  data/
    tables.dart             # schema v5
    app_database.dart
  design_system/
  features/
    onboarding/
    today/                  # compact dashboard (layout v2)
    calendar/               # local + google_calendar_sync + GoogleSyncCard
    finance/                # denser Overview/Plan/Insights/Ledger
    tasks/                  # live Inbox / Today / Done
    more/                   # settings + Google + About
  shell/
  l10n/
```

---

## Architecture

1. **`LumenApp`** opens `AppDatabase`, loads profile.
2. No profile → **`OnboardingFlow`** → seed.
3. Profile → **`AppShell`** (phone glass tabs / wide rail).
4. Live modules: Today, Calendar, **Tasks**, Finance, More — all get `AppDatabase`.
5. Money in **minor units**. Local events mark `dirty` for Google push.

### Density / depth

Средний баланс (не простыня, не «зажато»):
- Headers: Calendar/Finance/Tasks top air = `lg` + `pagePadding` 24; `ModuleScaffold` = `md`.
- Today: `slotHeight` **104**, gutters **12**; layout JSON **v:3** — `events_list` height/minHeight **2** (до 2 upcoming, без inner scroll).
- Finance: hero ring ~204px (max side ~164); insights charts ~205–220px.
- Tasks: full-width GlassSurface pill filters (как Calendar/Finance).
- Budget ring: center text clipped (`LayoutBuilder` + `ClipOval` + `FittedBox`).
- Today tile tap (не edit): finance-виджеты → Finance tab; events → Calendar; spend_today → add tx sheet.

### Safe area

Phone `SafeArea(bottom: false)` on shell content; titles after SafeArea.

---

## Database

**Schema version:** **5**  
**Name:** `lumen`

| Table | Purpose |
|---|---|
| `profiles` | name, locale, country, currency |
| `calendars` | + `googleCalendarId`, `googleSyncToken` |
| `events` | + `googleEventId`, `googleEtag`, `dirty` |
| `google_sync_state` | connected, accountEmail, lastSyncAt, lastError |
| `tasks` | title, isDone, dueDate?, notes, sortOrder |
| `finance_*` | categories, accounts, budgets, allocations, transactions |
| `today_preferences` | legacy toggles + `layoutJson` (`{v, "2":…, "4":…}`) |

**Migration**

- &lt;2 → `events`
- &lt;3 → finance tables + category columns
- &lt;4 → `layout_json`
- &lt;5 → Google columns on calendars/events; `tasks`; `google_sync_state`

---

## Google Calendar sync

**Config:** `lib/core/google_config.dart` — paste OAuth client IDs (`iosClientId`, `androidClientId`, `webClientId`).

**Cloud setup**

1. Google Cloud → enable **Calendar API**.
2. OAuth consent + clients (iOS / Android / Web).
3. iOS: set `GIDClientID` + URL scheme in `ios/Runner/Info.plist` (placeholders present).
4. Rebuild.

**Engine:** `GoogleCalendarSync` — connect / disconnect / syncNow; pull primary (30d back / 90d forward); push `dirty` local events; last-write-wins (skip remote overwrite if local dirty).

**UI:** `GoogleSyncCard` on **More**. Without client IDs → snackbar «нужен Cloud / GoogleConfig».

Local calendar works without Google.

---

## Tasks

Live tab: full-width filters **Inbox / Today / Done** (тот же chrome/`pagePadding`, что Calendar/Finance), CRUD sheet, due date optional. Today = incomplete with due ≤ end of today (includes overdue).

---

## Today dashboard

- Drag/resize via `dashboard`; Edit + Add.
- Layout version **3** (`events_list` taller for 2 upcoming cards).
- Tap (outside edit): finance tiles → Finance; events → Calendar; spend_today → transaction sheet.
- Tiles: budget_ring, spent, remaining, spend_today, events_count, events_list (+ catalog: donut, cashflow, accounts).
- `events_list`: до **2** следующих upcoming (title+time), без nested scroll.

---

## Finance

Tabs Overview · Plan · Insights · Ledger. `BudgetHeroRing` clips center text (`LayoutBuilder` + `ClipOval` + `FittedBox`; compact uses `—` not long «Бюджет не задан»).

---

## Run

```bash
flutter pub get
dart run build_runner build
flutter run -d chrome
flutter run -d <ios-simulator>
```

After feature work: restart **web + iOS**, update this file + TODOS.

---

## Implemented vs stub

| Area | Status |
|---|---|
| Design system / shell / onboarding | shipped |
| Calendar local | shipped |
| Google Calendar sync | shipped (needs your OAuth IDs) |
| Finance premium | shipped (denser) |
| Today dashboard | shipped (compact v2) |
| Tasks | shipped |
| Backup `.lumen` | stub |
| Habits / Routine / Nutrition / Training | rooms |
