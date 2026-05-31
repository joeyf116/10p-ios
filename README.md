# 10th Planet Jiu Jitsu Member Ecosystem (Flutter)

This app now includes Firestore-backed feature flows for:

- Auth
- Schedule
- Check-in
- Waivers
- Membership payments
- Announcements

The app runs on iOS, Android, and Web with `go_router` navigation and `get_it` dependency injection.

## Implemented Feature Paths

- `/auth`: Email/password + Google sign-in, user profile bootstrap in `users`
- `/schedule`: Realtime classes from `schedules`, reserve a spot
- `/check-in`: Rotating QR payload + write attendance records to `check_ins`
- `/waivers`: Waiver status check and signed waiver record in `waivers`
- `/membership`: Plan updates in `memberships` plus payment event records in `payments`
- `/announcements`: Publish and list latest announcements from `announcements`

## Local Setup

```bash
flutter pub get
flutter test
flutter run
```

## Firebase and Firestore Integration

You must provide Firebase project configuration before these features work.

Required Firebase products:

- Authentication (Email/Password and Google provider enabled)
- Cloud Firestore

### What You Need to Provide

For mobile (iOS/Android):

- Native Firebase app setup files from your Firebase project
- iOS: `GoogleService-Info.plist`
- Android: `google-services.json`

For web (local build or GitHub Actions deploy), provide these values as `--dart-define` variables:

- `FIREBASE_API_KEY`
- `FIREBASE_APP_ID`
- `FIREBASE_MESSAGING_SENDER_ID`
- `FIREBASE_PROJECT_ID`
- `FIREBASE_AUTH_DOMAIN`
- `FIREBASE_STORAGE_BUCKET`
- Optional: `FIREBASE_MEASUREMENT_ID`

Local web run example:

```bash
flutter run -d chrome \
  --dart-define FIREBASE_API_KEY=... \
  --dart-define FIREBASE_APP_ID=... \
  --dart-define FIREBASE_MESSAGING_SENDER_ID=... \
  --dart-define FIREBASE_PROJECT_ID=... \
  --dart-define FIREBASE_AUTH_DOMAIN=... \
  --dart-define FIREBASE_STORAGE_BUCKET=... \
  --dart-define FIREBASE_MEASUREMENT_ID=...
```

## Firestore Collections Used

Create these collections (documents are created by app flows as users interact):

- `users`
- `schedules`
- `check_ins`
- `waivers`
- `memberships`
- `payments`
- `announcements`

Suggested key fields:

- `users/{uid}`: `display_name`, `role`, `belt_rank`, `waiver_signed`, `stripe_customer_id`
- `schedules/{classId}`: `title`, `coach_name`, `start_time` (Timestamp), `capacity_limit`, `attendees` (array)
- `check_ins/{autoId}`: `user_id`, `checked_in_at`
- `waivers/{autoId}`: `user_id`, `is_active`, `signed_at`, `signature_png_base64`
- `memberships/{uid}`: `user_id`, `plan_id`, `provider`, `status`, `updated_at`
- `payments/{autoId}`: `user_id`, `plan_id`, `event`, `created_at`
- `announcements/{autoId}`: `title`, `body`, `created_at`

## Minimum Firestore Rules (Starter)

Use this as a starting point and tighten for production role logic.

```text
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    function signedIn() {
      return request.auth != null;
    }

    match /users/{uid} {
      allow read, write: if signedIn() && request.auth.uid == uid;
    }

    match /schedules/{classId} {
      allow read: if true;
      allow update: if signedIn();
      allow create: if signedIn();
    }

    match /check_ins/{docId} {
      allow create: if signedIn();
      allow read: if signedIn();
    }

    match /waivers/{docId} {
      allow create: if signedIn();
      allow read: if signedIn();
    }

    match /memberships/{uid} {
      allow read, write: if signedIn() && request.auth.uid == uid;
    }

    match /payments/{docId} {
      allow create: if signedIn();
      allow read: if signedIn();
    }

    match /announcements/{docId} {
      allow read: if true;
      allow create: if signedIn();
    }
  }
}
```

## Firestore Indexes You May Need

If Firestore prompts for indexes, create at least:

- `announcements` on `created_at` descending
- `schedules` on `start_time` ascending
- `waivers` composite index on `user_id` + `is_active`

## GitHub Pages Deployment

Workflow file: `.github/workflows/deploy-web.yml`

What to configure in GitHub:

1. Settings -> Pages -> Source: GitHub Actions
2. Repository secrets:
3. `FIREBASE_API_KEY`
4. `FIREBASE_APP_ID`
5. `FIREBASE_MESSAGING_SENDER_ID`
6. `FIREBASE_PROJECT_ID`
7. `FIREBASE_AUTH_DOMAIN`
8. `FIREBASE_STORAGE_BUCKET`
9. Optional `FIREBASE_MEASUREMENT_ID`
10. Optional repository variable `GH_PAGES_BASE_HREF` (default is `/<repo-name>/`)

After secrets are set, push to `main` or run the deploy workflow manually.
