# Lumen — technical documentation

Канонический tech/dev документ. Продуктовый план: [PLAN.md](PLAN.md). Стиль: [STYLE.md](STYLE.md). Чеклист: [TODOS.md](TODOS.md). Дневник изменений: [DEV_BLOG.md](DEV_BLOG.md).

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

**Lumen** — локальный life OS: календарь, финансы, задачи, **привычки и распорядок** живые; Nutrition/Training — комнаты. Без сервера Lumen: источник правды — SQLite на устройстве. Google Calendar — опциональный linked sync.

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
    google_config.dart
    region_options.dart
    world_currencies.dart
  data/
    tables.dart             # schema v6
    app_database.dart
  design_system/            # + Kebo finance tokens
  features/
    onboarding/
    today/                  # layout v3; Upcoming×2; tile → tabs
    calendar/
    finance/                # Kebo Overview hero + ring
    tasks/
    habits/                 # mhabit-inspired
    routine/                # FocusForce-inspired
    more/                   # Habits/Routine live; Nutrition/Training stub
  shell/
    lumen_tabs.dart
  l10n/
docs/
  TECHNICAL.md · DEV_BLOG.md · TODOS.md · PLAN.md · STYLE.md
```

---

## Architecture

1. **`LumenApp`** opens `AppDatabase`, loads profile.
2. No profile → **`OnboardingFlow`** → seed.
3. Profile → **`AppShell`** (phone glass tabs / wide rail).
4. Live modules: Today, Calendar, **Tasks**, Finance, More (+ **Habits** / **Routine** from More) — all get `AppDatabase`.
5. Money in **minor units**. Local events mark `dirty` for Google push.

### Density / depth

Средний баланс (не простыня, не «зажато»):
- Headers: Calendar/Finance/Tasks/Habits/Routine top air = `lg` + `pagePadding` 24.
- Today: `slotHeight` **104**, gutters **12**; layout JSON **v:3**; Upcoming ≤2 без inner scroll.
- Finance: Kebo balance hero + quick actions; budget ring ~204 (текст внутри круга); charts ~205–220.
- Tasks/Habits: full-width GlassSurface pill filters.

### Docs sync

После фич обновлять **TECHNICAL.md + DEV_BLOG.md + TODOS.md** (см. `.cursor/rules/restart-web-ios.mdc`).

### Safe area

Phone `SafeArea(bottom: false)` on shell content; titles after SafeArea.

---

## Database

**Schema version:** **6**  
**Name:** `lumen`

| Table | Purpose |
|---|---|
| `profiles` | name, locale, country, currency |
| `calendars` | + `googleCalendarId`, `googleSyncToken` |
| `events` | + `googleEventId`, `googleEtag`, `dirty` |
| `google_sync_state` | connected, accountEmail, lastSyncAt, lastError |
| `tasks` | title, isDone, dueDate?, notes, sortOrder |
| `habits` / `habit_logs` | frequency, color, daily check-ins |
| `routines` / `routine_slots` / `routine_slot_logs` | timed templates + per-day slot done |
| `finance_*` | categories, accounts, budgets, allocations, transactions |
| `today_preferences` | legacy toggles + `layoutJson` (`{v, "2"|"4":…}`) |

**Migration**

- &lt;2 → `events`
- &lt;3 → finance tables + category columns
- &lt;4 → `layout_json`
- &lt;5 → Google columns; `tasks`; `google_sync_state`
- &lt;6 → habits + routines tables

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

## Habits

More → Habits. Tabs **Today** (card + check + streak) / **All** (7-day dots). Create/edit sheet: frequency daily|weekly, color. Orientir: **mhabit**.

## Routine

More → Routine. Today's slots mark-done + template list (start time, weekday chips, enable switch). Editor: ordered slots with duration steppers. Orientir: **FocusForcePlus**.

## Finance

Tabs Overview · Plan · Insights · Ledger. Overview: **Kebo**-style tint balance hero + 4 purple quick actions + lavender progress; `BudgetHeroRing` still clips center text. Further Plan/Insights Kebo bar language — in progress.

---

## Run

```bash
flutter pub get
dart run build_runner build
flutter run -d chrome
flutter run -d <ios-simulator>
```

After feature work: restart **web + iOS**, update **TECHNICAL + DEV_BLOG + TODOS**.

---

## Implemented vs stub

| Area | Status |
|---|---|
| Design system / shell / onboarding | shipped |
| Calendar local | shipped |
| Google Calendar sync | shipped (needs your OAuth IDs) |
| Finance | shipped (Kebo Overview hero; ring kept) |
| Today dashboard | shipped (layout v3) |
| Tasks | shipped |
| Habits | shipped (from More) |
| Routine | shipped (from More) |
| Backup `.lumen` | stub |
| Nutrition / Training | rooms |
