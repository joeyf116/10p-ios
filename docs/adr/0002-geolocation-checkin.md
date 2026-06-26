# ADR-0002 — Geolocation-verified self-check-in

## Status
Accepted

## Decision
Check-in is self-serve: the member taps one button. The app verifies they are within 500 m of the gym before writing the CheckInRecord to Firestore. QR code (staff-scan) is the fallback for members without location permissions.

## Reason
Staff-scan QR requires a coach present with a scanning device at every check-in moment. Self-serve with geolocation is lower friction and works for open mat sessions with no coach present. 500 m radius is tight enough to prevent remote check-ins, loose enough for parking lot arrivals.
