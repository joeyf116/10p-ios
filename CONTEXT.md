# CONTEXT — 10th Planet Greenville Member Ecosystem

## What this app is

A mobile-first (iOS, Android, web) Flutter app for 10th Planet Greenville BJJ gym members, coaches, and the gym owner. It handles everything a member needs day-to-day: checking in to class, viewing the schedule, learning technique, paying for membership, and staying connected with the team.

## Who uses it

| Role | What they do |
|---|---|
| **Member** | Check in, view schedule, browse technique library, read announcements, view competitions |
| **Coach** | Everything a member can do, plus claim class slots on the Coaches Schedule |
| **Owner** | Everything a coach can do, plus manage members, post announcements, manage class templates |

Roles are stored on `AppUser.role` as `UserRole { member, coach, owner }`.

## Brand

10th Planet Greenville. Dark-first aesthetic.

- Background: `#0A0A0A`
- Primary / accent: `#CC0000` (red)
- On-primary text: `#FFFFFF`
- Surface: `#1A1A1A`
- Secondary text: `#A0A0A0`

## Core domain concepts

### Member
A registered user of the app. Has a `BeltRank` (white → black), a `UserRole`, a waiver status, and an optional Stripe customer ID for billing.

### Check-In
The act of a member recording their attendance at a training session. A check-in is valid when the member is physically within 500 m of the gym (verified via `geolocator`). Members tap a single "Check In" button; the app writes a `CheckInRecord` to Firestore with their `uid`, `timestamp`, and optional `classId` if a class is currently in session. QR code (via `qr_flutter`) is the staff-scan fallback for members without location access.

### Class / ScheduleClass
A scheduled training session. Has a `title`, `startTime`, `durationMinutes`, `capacityLimit`, and a list of `attendee` UIDs. Linked to a `coachUid` (not a raw name string — always resolved to an `AppUser`). Classes can be one-off or marked `isRecurring` (weekly on the same day/time).

### Coaches Schedule
A coach-facing view of upcoming class slots. Open slots (no `coachUid` assigned) are claimable. Coaches tap "I'm teaching this" to assign themselves. Owners can override any assignment. This is not a separate data model — it is a filtered, editable view of `ScheduleClass`.

### Technique
A single BJJ move. Organized in a three-level hierarchy: **System → Position → Technique**. Systems are 10th Planet-specific (Rubber Guard, Lockdown, Electric Chair, Truck, Coyote Guard, etc.). A technique has a `title`, optional `videoUrl`, `description`, and `beltLevel` (the belt at which it's typically introduced).

### Waiver
A liability waiver that every new member must sign before accessing the app's main features. Stored as a signed PDF or a Firestore document with a `signedAt` timestamp and a base64-encoded signature image. `AppUser.waiverSigned` is the fast-path flag; the full record lives in the `waivers` Firestore collection.

### Membership Plan
The billing relationship between a member and the gym. Four tiers: **Drop-in**, **Monthly**, **Student Monthly**, **Annual**. Processed via Stripe (`flutter_stripe`). A member's active plan is tracked in the `memberships` Firestore collection linked to their `stripeCustomerId`.

### Announcement
A broadcast message from coaches or the owner to all members (or a filtered subset by role/belt). Has a `title`, `body`, `postedAt`, `authorUid`, and `targetAudience` (all / members / coaches). Each member's read status is tracked in a subcollection to support unread badges. Push delivery via Firebase Cloud Messaging (`firebase_messaging`).

### Competition
An upcoming BJJ tournament the gym is attending. Has `name`, `date`, `location`, `registrationDeadline`, and `registrationUrl` (external link). Members can flag themselves as `isCompeting` — stored as a subcollection of competitor UIDs. The app does not handle registration directly; it links out.

## Onboarding flow

New user path (enforced by router guard):

1. **Auth** — Firebase Auth, Google Sign-In
2. **Waiver** — must sign before proceeding; sets `waiverSigned = true`
3. **Membership** — choose a plan and complete Stripe payment
4. **Home** — full app access unlocked

Router reads `AppUser.waiverSigned` and `AppUser.stripeCustomerId` to enforce the gate.

## Navigation structure

Bottom navigation bar, tabs vary by role:

| Tab | Member | Coach | Owner |
|---|---|---|---|
| Home | ✓ | ✓ | ✓ |
| Schedule | ✓ | ✓ | ✓ |
| Check In | ✓ | ✓ | ✓ |
| Library | ✓ | ✓ | ✓ |
| Announcements | ✓ | ✓ | ✓ |
| Coaches | — | ✓ | ✓ |
| Admin | — | — | ✓ |

## Platform targets

iOS, Android, Web. Responsive layout via `AdaptiveScaffold` (already in `lib/core/layout/`). Bottom nav on mobile; side rail on tablet/web.

## Tech stack

| Concern | Library |
|---|---|
| UI framework | Flutter (Material 3, dark-first) |
| State management | Riverpod |
| Navigation | go_router |
| DI | GetIt |
| Backend | Firebase (Auth, Firestore, Cloud Messaging) |
| Payments | Stripe (`flutter_stripe`) |
| Video | `video_player` + `chewie` |
| QR | `qr_flutter` |
| Location | `geolocator` |
| Serialization | `json_serializable` |

## Terms to avoid

- Do not call it "gym management software" — it is a **member ecosystem**
- Do not say "user" when you mean a specific role — say **member**, **coach**, or **owner**
- Do not say "class list" — say **schedule**
- Do not say "video" when you mean a specific technique — say **technique** (it may have a video)
- Do not say "competition" and "tournament" interchangeably — the domain term is **competition** (the event the gym attends); a competition may be held at a **tournament** venue but we call the domain object a Competition
