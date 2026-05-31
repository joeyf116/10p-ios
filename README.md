# 10th Planet Jiu Jitsu Member Ecosystem (Flutter)

This repository now contains a production-oriented Flutter foundation aligned to the PRD:

- Cross-platform app shell for iOS, Android, and Web
- Riverpod state-management entrypoint and `go_router` declarative navigation
- `get_it` dependency injection bootstrap
- Neutral light/dark design system with Theme-based token usage
- Firestore-aligned `users` and `schedules` models via `json_serializable` patterns
- Feature module structure for auth, check-in, scheduling, content, tournaments, waivers, membership, and announcements
- Focused tests for breakpoints, theming, and schema model behavior

## Packages (LTS/stable stream)

Core dependencies are pinned to stable major versions in `pubspec.yaml` for long-term maintenance and compatibility.

## Local setup

```bash
flutter pub get
flutter test
flutter run
```
