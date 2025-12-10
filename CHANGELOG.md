## 1.0.9
- Fix: Resolved `part of` import errors in generated tests (`profile_screen_test.dart`).
- Fix: Corrected mismatched state names in tests (`UserError` → `UserFailure`).
- Fix: Gracefully handle audit failures in CLI without unhandled exceptions.

## 1.0.8
- Fix: Hardcoded file naming in `mcf_new` template to prevent `_cubit.dart` generation errors.
- Fix: Resolved strict linter errors in generated Data Layer files (`user_model.dart`, `user_repository_impl.dart`).
- Fix: Added global error handling to CLI to prevent crashes during failed audits.
- Improvement: `mcf new` now correctly wires up `main.dart` with Dependency Injection.

## 1.0.7
- Update: RREADME.md.

## 1.0.6
- Fix: Solved Windows PATH latency by using direct Dart package execution (`dart pub global run`) as a fallback.

## 1.0.5
- Fix: Enhanced Windows detection for missing Mason CLI (checks exit code).

## 1.0.4
- Fix: Auto-installs `mason_cli` if missing from the user's system.

## 1.0.3
- Fix: Solved "Bad state: No terminal attached" crash by enabling interactive mode during brick installation.

## 1.0.2
- Fix: Updated GitHub repository URL to point to the correct brick location.

## 1.0.1
- Fix: Windows compatibility issue where `mason` command was not found.

## 1.0.0
- Initial release.