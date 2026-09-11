# macOS bootstrap

1. Install Xcode from App Store, open once, accept license.
2. Install Flutter: https://docs.flutter.dev/get-started/install/macos
3. `flutter doctor` — fix iOS toolchain until green.
4. Copy this `app` folder to the Mac (or clone git if you push it).
5. In the project folder:

```bash
flutter create --org com.lumen --project-name lumen --platforms=ios,android,web .
```

Keep `docs/` and the plan README. If `flutter create` overwrites `README.md`, restore from git or rewrite from `docs/PLAN.md`.

6. Open the folder in Cursor on Mac and say: implement from `docs/PLAN.md`.
