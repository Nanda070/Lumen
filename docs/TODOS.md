# Lumen — implementation todos

Статус: **в работе** — Flutter foundation + **premium visual language** (рефы `@martin_ouvre`).

- [x] **design-system** — charcoal + violet bloom, Outfit, glass / glow / gradient metrics, floating island tab bar
- [x] **app-shell** _(foundation)_ — 5 табов Today / Calendar / Tasks / Finance / More, rail на wide, EN/RU в More, Today hub
  - [ ] онбординг + локальный профиль в SQLite (Drift)
- [ ] **calendar-local** — живой локальный календарь Day / Week / Month (уровень Notion Calendar)
- [ ] **finance-core** — живые финансы: счета, категории, таблица, валюта, обзор месяца
- [ ] **google-sync** — двусторонняя синхронизация с Google Calendar (нужен твой Google Cloud проект)
- [ ] **backup** — локальный бэкап `.lumen`: скачать и восстановить
- [ ] **later-modules** — после каркаса: Tasks, Habits, Routine, Nutrition, Training

Порядок = сверху вниз. Детали: [PLAN.md](PLAN.md). Стиль: [STYLE.md](STYLE.md).
