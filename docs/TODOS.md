# Lumen — implementation todos

Статус: **в работе** — foundation + premium UI + онбординг + **локальный календарь** + полный ISO currency picker.

- [x] **design-system** — charcoal + violet bloom, Outfit, glass / glow / gradient metrics, floating island tab bar
- [x] **app-shell** _(foundation)_ — 5 табов Today / Calendar / Tasks / Finance / More, rail на wide, EN/RU в More, Today hub + SafeArea
  - [x] онбординг + локальный профиль в SQLite (Drift) — seed Personal/Lumen + finance categories
  - [x] base currency — 154 ISO 4217 + searchable picker (EN/RU names)
- [x] **calendar-local** — живой локальный календарь Day / Week / Month, CRUD событий в Drift (без Google)
- [ ] **finance-core** — живые финансы: счета, категории, таблица, валюта, обзор месяца
- [ ] **google-sync** — двусторонняя синхронизация с Google Calendar (нужен твой Google Cloud проект)
- [ ] **backup** — локальный бэкап `.lumen`: скачать и восстановить
- [ ] **later-modules** — после каркаса: Tasks, Habits, Routine, Nutrition, Training

Порядок = сверху вниз. Детали: [PLAN.md](PLAN.md). Стиль: [STYLE.md](STYLE.md). Техдок: [TECHNICAL.md](TECHNICAL.md).
