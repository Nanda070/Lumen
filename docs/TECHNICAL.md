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
  main.dart                 # entry, system UI chrome
  app.dart                  # LumenApp: bootstrap DB → onboarding or shell
  core/
    region_options.dart     # countries → suggested currency
    world_currencies.dart    # 154 ISO 4217 currencies EN/RU
  data/
    tables.dart             # Drift table defs
    app_database.dart       # CRUD + seed + migrations
    app_database.g.dart     # generated
  design_system/            # colors, type, glass, glow, metrics, tab bar
  features/
    onboarding/             # 5-step flow + currency searchable picker
    today/                  # hub with live today’s events
    calendar/               # Day/Week/Month + event CRUD sheet
    tasks/ finance/ more/   # rooms / settings / about
  shell/
    app_shell.dart          # tabs + SafeArea + rail
    module_scaffold.dart    # shared large-title chrome
  l10n/
docs/                       # PLAN, STYLE, TODOS, TECHNICAL, MAC
web/                        # index + sqlite3.wasm + drift_worker.js
```

---

## Architecture

1. **`LumenApp`** opens `AppDatabase`, loads profile.
2. No profile → **`OnboardingFlow`** (name, locale+country, base currency, Google skip, ready) → seed calendars/categories.
3. Profile exists → **`AppShell`**: phone floating glass tabs / wide left rail.
4. Pages receive `AppDatabase` where they need live data (Today, Calendar).
5. Streams via Drift `watch*` for reactive UI.

### Safe area

- Phone: `AppShell` wraps body in `SafeArea(bottom: false)` — top clears Dynamic Island/status bar; bottom left for floating tab bar.
- Wide: `SafeArea` around rail + content.
- Onboarding / loading / error: own `SafeArea`.
- Module titles use `LumenSpacing.lg` air **after** SafeArea (no magic status-bar pixels).

---

## Database

**Schema version:** 2  
**Name:** `lumen` (Drift / sqlite)

| Table | Purpose |
|---|---|
| `profiles` | Single local profile: displayName, localeCode, countryCode, currencyCode, createdAt |
| `calendars` | Named calendars + colorArgb; seed Personal / Lumen |
| `events` | title, startsAt, endsAt, calendarId → calendars, createdAt, updatedAt |
| `finance_categories` | nameKey, kind expense\|income, color; seeded defaults |

Seed on first `completeOnboarding`: Personal (`#8B6CFF`), Lumen (`#5B7CFF`), expense/income categories.

**Storage**

- Native: platform SQLite via `driftDatabase(name: 'lumen')` (app support dir).
- Web: Wasm / shared IndexedDb (`sqlite3.wasm`, `drift_worker.js`).
- No SharedPreferences yet; locale/currency live on `profiles`.

Migration: `onUpgrade` from &lt;2 creates `events`.

---

## Calendar (shipped)

- Views: Day / Week / Month, now-line, cream Quick Add.
- CRUD sheet: title, date, start/end, calendar chip; delete on edit.
- Today hub lists today’s events from Drift.
- No Google sync in this layer (`google-sync` later).

---

## Navigation & i18n

Tabs: Today · Calendar · Tasks · Finance · More.  
Locale from profile; switch in More. ARB → `AppLocalizations`.

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
| Today live events | Live |
| Tasks / Habits / Routine / Nutrition / Training | Stub rooms |
| Finance UI | Placeholder metrics |
| Google Calendar sync | Not started |
| `.lumen` backup | Not started |

---

## Key decisions

- Local-first SQLite over cloud account.
- Custom calendar canvas (not `table_calendar` as final UI).
- EN default; RU first-class ARB.
- Premium charcoal/violet language intentional (STYLE over generic anti-purple rules).
- Full ISO currency list + search (not a short curated chip row).
- Contacts stay human-facing (docs + More), bundle id unchanged.
