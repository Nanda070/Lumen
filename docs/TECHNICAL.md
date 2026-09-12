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
| Charts | `fl_chart` — budget ring, interactive donut, smooth cashflow line, weekly bars |
| Dashboard | `dashboard` ^0.0.4 — drag/resize Today widgets |
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
    tables.dart             # Drift tables (schema v4)
    app_database.dart       # CRUD + seed + migrations + month summary + dashboard layout
    app_database.g.dart
  design_system/
  features/
    onboarding/
    today/                  # dashboard grid + tiles + add-widget sheet
    calendar/
    finance/                # Overview/Plan/Insights/Ledger + premium charts
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
| `today_preferences` | legacy toggles + `widgetOrder` + **`layoutJson`** (dashboard grid) |

**Seed** (onboarding + `beforeOpen` bootstrap for upgrades): Personal/Lumen calendars, default expense/income categories, one **Cash** account in profile currency, default Today prefs (all on).

**Migration**

- &lt;2 → create `events`
- &lt;3 → add category columns; create accounts / budgets / allocations / transactions / today_preferences; mark seeded categories `is_system`
- &lt;4 → add `today_preferences.layout_json` for drag/resize dashboard layouts

**Storage:** native SQLite via `driftDatabase(name: 'lumen')`; web Wasm + IndexedDb.

---

## Finance (shipped)

Tabs: **Overview · Plan · Insights · Ledger**

- Overview: month switcher, budget hero ring, spent/remaining/income/budget/net metrics, accounts strip, status chip.
- Plan: total budget editor CTA, envelope rows with progress + leftover/over, equal-split, link to category manager.
- Insights: interactive donut, smooth cashflow line (area gradient + tooltip), weekly bars.
- Ledger: filters + transaction list.
- Shared sheets: budget / transaction / category / account managers.
- Overflow-safe: FittedBox + ellipsis on metric/allocation rows.

---

## Today (shipped)

Custom **dashboard** grid (`package:dashboard`) with drag + resize:

- Phone `slotCount: 2`, wide (`width > 700`) `slotCount: 4`; `slotHeight ≈ 108`.
- Layout persisted in `today_preferences.layoutJson` (map of slotCount → item layouts).
- Default tiles: budget ring, spent, remaining, spend today, events count, events list, category donut, cashflow.
- Catalog extras: accounts.
- Edit mode: long-press, violet grid lines, trash on tiles; Add sheet for missing widgets.
- Configure: Today Edit/Add, or More → Settings → Widgets (catalog persists into `layoutJson`).

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
| Finance core (accounts, budget, txs, charts) | Live — Overview/Plan/Insights/Ledger + premium charts |
| Today hub widgets + prefs | Live — drag/resize dashboard + layoutJson |
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
