# Healthify Mobile 🌿

AI-powered skincare & cosmetic ingredient analysis — Flutter client.
Final Year Software Engineering Project.

Scan a product's ingredient list with the camera, get an explainable
AI suitability score personalized to your skin profile, chat with the
assistant, compare products, and discover better alternatives.

## Features

- **Auth**: register / login / forgot & reset password, JWT with refresh-token
  rotation, biometric unlock, secure token storage
- **Skin profile**: 4-step wizard (type, concerns, allergies, goals)
- **Scanner**: live camera with framing overlay & torch, gallery upload,
  on-device Google ML Kit OCR, editable review sheet
- **Analysis**: animated suitability score, safety rating, allergy &
  irritation warnings, per-ingredient breakdown with reasons, AI explanation,
  better alternatives, share, bookmark
- **Compare**: side-by-side product comparison with winner highlighting
- **AI assistant**: contextual chat grounded in your analyses (Claude when the
  backend has an AI key, database-grounded otherwise)
- **Search**: ingredients + products with debounce and search history
- **Ingredient library**: browse the whole ingredient database, ingredient of
  the day, and picks ranked against your skin profile
- **Product catalog**: browse by category with paging, and analyze any catalog
  product against your profile without scanning a label
- **Premium**: plans in NPR with Khalti / eSewa checkout
- **More**: dashboard with daily insight & recommendations, favorites,
  history, notification center, daily local scan reminders, dark/light theme

## Getting started

Prereqs: Flutter (stable), a running [healthify_backend](../healthify_backend),
and MongoDB (local or Atlas).

```sh
flutter pub get
dart run build_runner build --delete-conflicting-outputs   # Freezed/JSON codegen
flutter run
```

### API base URL

Resolved once at startup by
[api_base_url.dart](lib/core/network/api_base_url.dart) and injected through
`apiBaseUrlProvider`, in this order:

| Target | Base URL |
| --- | --- |
| Any build with `--dart-define=HEALTHIFY_API_BASE_URL` | that value |
| Release build | `https://api.healthify.app/api/v1` |
| Android **emulator** | `http://10.0.2.2:5000/api/v1` |
| iOS simulator, desktop, web | `http://localhost:5000/api/v1` |

`10.0.2.2` is the emulator's alias for the host's loopback and is **meaningless
on a real phone**, so emulator and device are told apart with a device probe
rather than by platform alone.

### Running on a physical Android device

A phone cannot reach your machine's loopback, so this build **must** be given
your LAN address:

```bash
flutter run --dart-define=HEALTHIFY_API_BASE_URL=http://<PC_IP>:5000/api/v1
```

Start the backend first — it prints the exact command for each network
interface, labelled by adapter name (pick the `[Wi-Fi]` one, not `vEthernet`).
Your phone and PC must be on the same Wi-Fi.

If you forget the flag, the app logs a loud warning at startup instead of
silently timing out on every request.

If you are also testing eSewa checkout on a device, set the backend's
`PUBLIC_BASE_URL` to the same host — eSewa needs a browser-reachable redirect
URL, so `localhost` will not work there either.

### Google Sign-In

The "Continue with Google" button on the login screen only appears once a
Google OAuth **web** client id is supplied at build time:

```bash
flutter run --dart-define=GOOGLE_SERVER_CLIENT_ID=xxxx.apps.googleusercontent.com
```

This must be the **same** client id as the backend's `GOOGLE_CLIENT_ID` (and
the Healthify web app's) — the backend verifies the token's audience against
it. Leave it unset to build without Google Sign-In; the button hides itself,
matching the app's existing pattern for optional integrations (AI chat,
Khalti/eSewa). Native setup (Android SHA-1 fingerprint registration, an
Android-type OAuth client in the same Google Cloud project) still has to be
done once in Google Cloud Console before this works end-to-end.

## Architecture

Clean Architecture + MVVM. Riverpod is both state management and the DI
container; repositories are injected via providers.

```
lib/
├── main.dart                 # Bootstrap: DI overrides, notifications, ProviderScope
├── app/                      # MaterialApp.router, GoRouter + auth redirects, shell
├── core/                     # Feature-agnostic infrastructure
│   ├── di/                   #   provider wiring (DI container)
│   ├── error/                #   sealed AppException hierarchy
│   ├── network/              #   Dio, endpoints, auth + refresh interceptors
│   ├── services/             #   biometrics, local notifications, session events
│   ├── storage/              #   secure storage (tokens) + preferences
│   ├── theme/                #   Material 3 design system
│   ├── utils/                #   validators, relative date formatting
│   └── widgets/              #   reusable design-system widgets + skeletons
└── features/<feature>/
    ├── data/                 #   repositories + remote data sources
    ├── domain/               #   entities (Freezed) + contracts
    └── presentation/         #   views (ConsumerWidgets) + viewmodels (Notifiers)
```

**MVVM:** Views render state only. ViewModels are Riverpod
`Notifier`/`AsyncNotifier` classes exposing `AsyncValue`, so every screen
handles loading / success / error / empty / offline uniformly
(`StatusView`, `AppLoader`, `SkeletonList`). `StatusView.forError` maps a
repository failure to the right state, so a dropped connection or timeout
reads as "offline" rather than a generic error.
The app-wide `AuthController` state machine
(`AuthUnknown → AuthLocked / Unauthenticated / Authenticated`) drives all
router redirects.

**Design system** ([core/theme](lib/core/theme)): dark-first Material 3 —
deep-navy surfaces, mint→cyan primary gradient, violet accent,
Plus Jakarta Sans + Inter, 4pt spacing scale, glassmorphism, glow shadows.

## Testing

```sh
flutter analyze
flutter test                  # unit + widget + ViewModel tests (mocktail)
flutter test integration_test # integration test (device/emulator)
```

Coverage includes: auth state machine, form validators, OCR ingredient
parser, favorites ViewModel (optimistic update + rollback), ingredient-library
and product-catalog ViewModels (debounce, stale-response and paging
behaviour), relative date formatting, search history, theme contract,
reusable widgets, screen-reader semantics, error/offline state mapping,
routing smoke tests, and analysis model parsing. Repositories are mocked with
`mocktail`; `SharedPreferences` uses mock initial values.

Two conventions to follow when adding tests:

- Riverpod 3 **retries failed providers automatically**, so a provider whose
  `build()` throws sits in `AsyncLoading(retrying)` rather than `AsyncError`
  and `await provider.future` never completes. Construct test containers with
  `ProviderContainer(retry: (_, _) => null)` when exercising an error path.
- The search ViewModels debounce on a real `Timer`. Poll for the expected
  state with the local `waitFor` helper instead of sleeping for the debounce
  duration, which is flaky on a loaded machine.

## Demo tips

1. Start the backend (`npm run dev`) — it seeds ingredients & products.
2. Register → complete the skin profile (add "Fragrance" as an allergy).
3. Scan any product photo containing "Ingredients: …" — or gallery-pick one.
4. Show the score, warnings, breakdown, alternatives → Compare → Ask AI.
5. Settings → enable biometric login, restart the app for the unlock gate.
6. Profile → Go Premium → pay with Khalti (simulated without gateway keys).
