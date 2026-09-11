# Lumen

Local life OS — calendar, tasks, habits, routine, finance, nutrition, workouts.

**iOS-first** Flutter app (also Android + web). All data local, with `.lumen` backup.

## Docs in this repo

| File | What |
|---|---|
| [docs/PLAN.md](docs/PLAN.md) | Product plan, modules, stack, build order |
| [docs/STYLE.md](docs/STYLE.md) | Design tokens, motion, navigation |
| [docs/TODOS.md](docs/TODOS.md) | Implementation checklist |

## Start on Mac

```bash
# Install Flutter + Xcode, then:
cd /path/to/app
flutter create --org com.lumen --project-name lumen --platforms=ios,android,web .
# Keep docs/ and README.md; merge carefully if flutter create overwrites README.
```

Then open this folder in Cursor and continue from `docs/PLAN.md` step 1 (design system).

## Decisions locked in

- Name: **Lumen**
- Stack: **Flutter**
- Audience: personal + friends (no store yet)
- Language: **EN default**, RU available
- v1 live: shell + **Calendar** (Google two-way) + **Finance**
- Motion: quiet premium + liquid-glass gestures
- Theme: charcoal / red / blue
