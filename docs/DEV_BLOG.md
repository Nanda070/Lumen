# Lumen — Dev Blog / Changelog

Канонический дневник разработки. **Свежие записи сверху.**  
Обновлять **наравне** с [`TECHNICAL.md`](TECHNICAL.md) и [`TODOS.md`](TODOS.md) после каждой существенной порции кода/фич.

Формат записи:

```
## YYYY-MM-DD — короткий заголовок
- что изменилось
- зачем (1 строка)
```

Контакты: **Nanda** · Cheterin Group · adnan.huseynli1@gmail.com · Telegram/Discord nanda070 · [discord.gg/cheterin](https://discord.gg/cheterin)

---

## 2026-09-12 — Live Habits + Routine + Kebo Finance Overview

- **Habits** (`lib/features/habits/`): Today cards (check-in + streak) и All (7-day dots) — UX в духе mhabit; вход из More.
- **Routine** (`lib/features/routine/`): список с временем/днями/switch + today's slots mark-done — UX в духе FocusForcePlus.
- **Finance Overview**: Kebo hero (tint balance card + 4 purple quick actions + lavender progress); ring сохранён с clip текста.
- Schema v6 API уже в Drift; i18n EN/RU для новых строк.
- **Зачем:** комнаты More перестают быть заглушками; Finance ближе к kebo mobile 1:1 по hero/карточкам.

---

## 2026-09-12 — Habits/Routine schema + Kebo tokens + DEV_BLOG

- Drift **schema v6**: `habits`, `habit_logs`, `routines`, `routine_slots`, `routine_slot_logs` + CRUD/toggle/streak API.
- `LumenColors`: Kebo finance tokens (`keboPrimary` `#6934D2`, lavender, overspend coral).
- Заведён этот файл; rule: TECHNICAL + DEV_BLOG (+ TODOS) при фичах.
- **Зачем:** живые Habits/Routine (ориентиры mhabit + FocusForcePlus) и Finance presentation → Kebo; дневник для владельца.

---

## 2026-09-12 — Today density, Upcoming, tile navigation, Tasks width

- Today: `slotHeight` 104, gutters 12; layout **v:3**; `events_list` height/minHeight 2.
- Upcoming: до **2** следующих событий, title+time, **без inner scroll**.
- Tap вне edit: finance-виджеты → Finance tab; events → Calendar; spend_today → add tx sheet (`LumenTabs` + `onNavigateToTab`).
- Tasks: тот же chrome что Calendar/Finance (`pagePadding` + full-width pill filters).
- Finance medium balance: ring ~204, charts ~205–220; текст ring внутри круга.
- **Зачем:** пользователь жаловался на сжатый UI, nested scroll Upcoming и узкие Tasks.

---

## 2026-09-11…12 — Google Calendar sync scaffold + live Tasks

- `GoogleCalendarSync` + `GoogleSyncCard` на More; OAuth placeholders в `GoogleConfig` / Info.plist.
- Tables: Google columns on calendars/events; `google_sync_state`; **tasks**.
- Tasks tab: Inbox / Today / Done + CRUD sheet.
- Schema **v5**.
- **Зачем:** optional linked calendar + task inbox без сервера Lumen.

---

## 2026-09 — Today dashboard (drag/resize)

- Пакет `dashboard`; layout JSON в `today_preferences`; Edit / Add widgets.
- Tiles: budget ring, spent, remaining, spend today, events count/list (+ catalog donut/cashflow/accounts).
- Schema **v4** (`layout_json`).
- **Зачем:** пульс дня одним экраном, настраиваемый board.

---

## 2026-09 — Finance module (live)

- Tabs Overview · Plan · Insights · Ledger; Drift money in minor units.
- Budget ring, donut, cashflow, weekly bars (`fl_chart`); accounts/categories managers.
- Schema **v3** finance tables + category flags.
- **Зачем:** локальный бюджет и ledger как ядро life OS.

---

## 2026-09 — Calendar local

- Day / Week / Month; event editor; seeded Personal/Lumen calendars.
- Schema **v2** `events`.
- **Зачем:** локальный холст расписания до Google sync.

---

## 2026-09 — Onboarding + AppShell + design system

- Onboarding: name / locale / region / currency → profile seed.
- Shell: phone glass tabs / wide NavigationRail; AtmosphereBackground.
- Design tokens: charcoal, violet, Outfit, Phosphor, GlowCard / GlassSurface.
- Schema **v1** profiles + calendars + preferences seed.
- **Зачем:** база продукта Lumen (локальный SQLite, EN/RU).

---

## Earlier — Plan & scaffolding

- `docs/PLAN.md`, `STYLE.md`, initial Flutter project, Drift web wasm worker.
- **Зачем:** product vision и runnable skeleton.
