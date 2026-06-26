# ADR-0004 — Coaches Schedule is a view of ScheduleClass, not a separate model

## Status
Accepted

## Decision
The Coaches Schedule feature does not introduce a new Firestore collection. It is a role-gated, editable view of the existing `ScheduleClass` documents, filtered to show upcoming slots and allowing coaches to assign themselves via `coachUid`.

## Reason
Avoids duplication and sync bugs between two collections representing the same scheduled class. A separate "coaching assignment" collection would require join logic everywhere ScheduleClass is displayed.
