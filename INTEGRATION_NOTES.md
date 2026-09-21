# FleetFlow — Step 2 integrated

Unzip and run:

```bash
flutter pub get
flutter run
```

All four roles are reachable from the login screen's role selector: **User,
Driver, Dispatcher, Admin.**

## What's new in this batch

| Role | Screen | Status |
|---|---|---|
| Driver | Dashboard | Built — stats + Next Trip card, wired to `DriverDashboardProvider` |
| Dispatcher | Profile | Built — read-only directory card, wired to `DispatcherProfileProvider` |
| Admin | Profile | Built — account/security info, wired to `AdminProfileProvider` |
| Admin | Vehicle Assignment | Built — filterable fleet grid + confirm flow, wired to `VehicleAssignmentProvider` |
| — | Register screen | Updated — role selector + reordered fields |
| — | Login screen | Updated — added the Admin role tab |

The **Admin role and shell are new** — there was no admin feature at all
before this batch. `AdminShell` mirrors `DispatcherShell`'s sidebar pattern,
with five menu entries; two are real (`Vehicle Assignment`, `Profile`), three
render the same "coming soon" panel `DispatcherShell` uses for its unbuilt
screens (`Fleet Overview`, `Drivers`, `Reports`) so the full navigation model
is visible even before those exist.

## Files touched in your existing code

| File | Change |
|---|---|
| `lib/main.dart` | added `DriverRepository` and `AdminRepository` providers, plus five new `ChangeNotifierProvider`s |
| `lib/features/user/screens/login_screen.dart` | added the `Admin` role tab and its navigation branch |
| `lib/features/user/screens/register_screen.dart` | rebuilt — role selector (User/Driver) + field order Name → Phone → Email → Password → Confirm, button now reads "Sign up" |
| `lib/features/driver/screens/driver_shell.dart` | `case 0` now returns `DriverDashboardScreen()`; the old `_DriverDashboardPlaceholder` class is removed |
| `lib/features/dispatcher/widgets/dispatcher_shell.dart` | added a `Profile` menu entry (`case 5`) |
| `lib/features/dispatcher/data/dispatcher_repository.dart` | added `fetchProfile()` to the abstract contract + mock |

## New files

```
lib/features/driver/
├── models/driver_dashboard_models.dart      DriverDashboardStatsModel, NextTripSummaryModel
├── data/driver_repository.dart              DriverRepository + MockDriverRepository
├── providers/driver_dashboard_provider.dart
└── screens/driver_dashboard_screen.dart

lib/features/dispatcher/
├── models/dispatcher_profile_model.dart
├── providers/dispatcher_profile_provider.dart
└── screens/dispatcher_profile_screen.dart

lib/features/admin/                           ← whole feature is new
├── models/admin_profile_model.dart
├── models/fleet_vehicle_model.dart            VehicleAssignmentStatus enum + FleetVehicleModel
├── data/admin_repository.dart                 AdminRepository + MockAdminRepository
├── providers/admin_profile_provider.dart
├── providers/vehicle_assignment_provider.dart
├── screens/admin_profile_screen.dart
├── screens/vehicle_assignment_screen.dart
└── widgets/
    ├── admin_shell.dart
    └── fleet_vehicle_card.dart
```

## Decisions worth knowing about

**Vehicle Assignment reuses `ReservationRequestModel` from the dispatcher
feature** rather than duplicating a lighter version in `admin/`. A vehicle
assignment only exists in service of an approved request, so importing
across features here is deliberate — the alternative is two models that can
silently drift out of sync.

**`VehicleAssignmentProvider.load()` defaults to `REQ-1042`** — the same demo
request already seeded in `MockDispatcherRepository`. There's no router yet
to pass a real request id in as a navigation argument, so this keeps the
screen useful standalone. `load(requestId)` takes an optional override for
when a router exists.

**The seat-count filter chips are functional**, and default to the
approved request's own passenger count (`4+` for `REQ-1042`, matching the
design). The Type/Fuel dropdowns from the design are visual-only for now —
wiring them needs a second filter dimension on `FleetVehicleModel` that
didn't seem worth the size increase for four seed vehicles. Flagging it
rather than quietly shipping a dropdown that does nothing.

**Register screen: two content changes beyond the reorder,** worth
confirming match intent. The design image's heading read "Welcome Back" —
that's the *login* screen's copy; I kept "Create Account" here since a
sign-up screen welcoming a first-time user "back" reads as a copy-paste
artifact rather than an intentional string. And the phone field's icon
in the image is bright green (WhatsApp-style) while every other icon in
the app is blue-grey — I kept it blue-grey rather than introduce a
one-off accent color with no other use in the palette. Say the word if
either was actually intentional.

**Register screen's role selector only offers User/Driver**, not
Dispatcher/Admin — matching your screenshot, and consistent with those two
roles being provisioned by IT rather than self-registered.

## Still open

- `DriverProfileScreen` (existing) and `MyTripScreen` (existing) are still on
  hardcoded data, not the repository pattern — out of scope for this batch,
  flagging again since it's the same note as last time.
- Fleet Overview, Drivers, and Reports under Admin are stubbed
  "coming soon" — same treatment `DispatcherShell` already uses for its own
  unbuilt screens.
- No router yet. Every cross-shell navigation is still
  `Navigator.pushReplacement` from the login screen; nothing links *between*
  Dispatcher and Admin (e.g. "approve" → "assign vehicle" is two separate
  manual role switches, not a real handoff).
