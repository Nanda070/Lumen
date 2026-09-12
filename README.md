# Lumen

Local life OS — calendar, tasks, habits, routine, finance, nutrition, workouts.

**iOS-first** Flutter app (also Android + web). All data local, with `.lumen` backup planned.

**Owner:** Nanda · **Company:** Cheterin Group  
Email: adnan.huseynli1@gmail.com · Telegram: nanda070 · Discord: nandak070 · Server: [discord.gg/cheterin](https://discord.gg/cheterin) · GitHub: [nanda070](https://github.com/nanda070)

## Docs in this repo

| File | What |
|---|---|
| [docs/PLAN.md](docs/PLAN.md) | Product plan, modules, stack, build order |
| [docs/STYLE.md](docs/STYLE.md) | Design tokens, motion, navigation |
| [docs/TODOS.md](docs/TODOS.md) | Implementation checklist |
| [docs/TECHNICAL.md](docs/TECHNICAL.md) | Canonical tech/dev reference |

## Start on Mac

```bash
# Install Flutter + Xcode, then:
cd /path/to/app
flutter create --org com.lumen --project-name lumen --platforms=ios,android,web .
# Keep docs/ and README.md; merge carefully if flutter create overwrites README.
```

Then open this folder in Cursor and continue from `docs/PLAN.md` / `docs/TECHNICAL.md`.

## Decisions locked in

- Name: **Lumen**
- Stack: **Flutter**
- Audience: personal + friends (no store yet)
- Language: **EN default**, RU available
- v1 live: shell + **local Calendar** + (next) Finance; Google sync later
- Motion: quiet premium + liquid-glass gestures
- Theme: charcoal / violet bloom / cream CTA
