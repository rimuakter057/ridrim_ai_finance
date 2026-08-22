# RidRim — Full Documentation

---

## 1. Welcome / Project Overview

Welcome to **RidRim**, an AI-first personal finance app template built with Flutter and Material 3. It combines a complete personal-finance feature set — accounts, transactions, budgets, savings goals, bills, debt, investments, analytics, and forecasting — with an AI assistant that's woven through the whole experience rather than bolted on as a single chat screen.

This document is the complete reference for the codebase: what's included, how it's put together, how to run and customize it, and where to look when something needs changing. If you only need the short version — install, run, build — see [`README.md`](README.md).

The app currently runs entirely on a realistic **in-memory mock data layer**. Every screen, chart, and number you see is generated from seed data in `lib/data/datasources/mock/`. This is deliberate: the architecture is layered so that replacing mock data with a real backend is a data-layer change, not a rewrite (see [§18 API/Backend Integration](#18-apibackend-integration-information)).

---

## 2. Features

### Finance
- Multi-account tracking (checking, savings, credit, investment) with live-computed net worth and liquid balance
- Full transaction history — search, category filters, date grouping, add/detail flows
- Category budgets with radial progress gauges, rollover, and AI-optimization toggle
- Savings goals with progress bars, deadlines, and an "Add funds" flow
- Bill & subscription tracking with overdue/upcoming/paid states and reminders
- Debt tracker with avalanche payoff ordering and a debt-free date forecast
- Investment portfolio with asset allocation and per-holding gain/loss
- Weekly/monthly analytics, a 6-month balance forecast, and a 0–100 financial health score

### AI
- Dashboard "AI Insight" card: a generated one-line takeaway + 14-day cash-flow sparkline
- AI Chat: natural-language Q&A over your own transactions/budgets, with inline generated charts
- A dedicated **AI Settings** panel (Settings → AI Settings) with 10+ feature toggles (spending analysis, budget/savings suggestions, anomaly detection, bill/subscription detection, personalized alerts, voice assistant) plus personalization controls (advice frequency, insight frequency, AI tone)
- A **Financial Profile** on the Profile screen (income, goals, risk tolerance, experience level) that frames how the assistant would personalize its answers

### App Experience
- Onboarding carousel, gradient-hero/bottom-sheet-card auth flow (login, register, forgot password, OTP, reset password)
- 5-tab bottom navigation (Dashboard, Transactions, Accounts, AI Chat, More) plus a "More" menu for everything else
- Alerts feed with severity color-coding and read/unread state
- Deep Settings covering Finance Preferences, Notifications (6 categories), Security & Privacy, Analytics & Reports, Data & Sync, and Support & Legal
- Light and dark themes, a single teal accent, glassmorphic AI surfaces

---

## 3. Complete Screen & Route List

- **Route:** `/splash` — **Screen:** Splash — **Notes:** Initial route, redirects to onboarding
- **Route:** `/onboarding` — **Screen:** Onboarding — **Notes:** 3-slide carousel
- **Route:** `/login` — **Screen:** Login — **Notes:** Gradient-hero bottom-sheet card
- **Route:** `/login/register` — **Screen:** Register
- **Route:** `/login/forgot-password` — **Screen:** Forgot Password
- **Route:** `/login/forgot-password/verify-otp` — **Screen:** Verify OTP — **Notes:** Receives email via `extra`
- **Route:** `/login/reset-password` — **Screen:** Reset Password
- **Route:** `/dashboard` — **Screen:** Dashboard — **Notes:** Bottom-nav tab 1
- **Route:** `/transactions` — **Screen:** Transactions — **Notes:** Bottom-nav tab 2
- **Route:** `/transactions/add` — **Screen:** Add Transaction
- **Route:** `/transactions/:id` — **Screen:** Transaction Detail
- **Route:** `/accounts` — **Screen:** Accounts — **Notes:** Bottom-nav tab 3
- **Route:** `/accounts/:id` — **Screen:** Account Detail
- **Route:** `/ai-chat` — **Screen:** AI Chat — **Notes:** Bottom-nav tab 4
- **Route:** `/more` — **Screen:** More (menu) — **Notes:** Bottom-nav tab 5
- **Route:** `/budget` — **Screen:** Budget — **Notes:** Radial gauges per category
- **Route:** `/savings` — **Screen:** Savings Goals
- **Route:** `/bills` — **Screen:** Bills & Subscriptions
- **Route:** `/debt` — **Screen:** Debt Tracker
- **Route:** `/investments` — **Screen:** Investments
- **Route:** `/analytics` — **Screen:** Analytics
- **Route:** `/forecast` — **Screen:** Forecast — **Notes:** 6-month projection
- **Route:** `/financial-health` — **Screen:** Financial Health — **Notes:** Score + factors
- **Route:** `/alerts` — **Screen:** Alerts
- **Route:** `/profile` — **Screen:** Profile — **Notes:** Financial overview + preferences
- **Route:** `/profile/edit` — **Screen:** Edit Profile
- **Route:** `/profile/password-security` — **Screen:** Password & Security
- **Route:** `/profile/payment-methods` — **Screen:** Payment Methods
- **Route:** `/profile/billing-history` — **Screen:** Billing History
- **Route:** `/settings` — **Screen:** Settings — **Notes:** ~20 sections
- **Route:** `/settings/sessions` — **Screen:** Active Sessions
- **Route:** `/settings/about` — **Screen:** About App
- **Route:** `/settings/legal/terms` — **Screen:** Terms of Service
- **Route:** `/settings/legal/privacy` — **Screen:** Privacy Policy
- **Route:** `/subscription` — **Screen:** Subscription plans — **Notes:** Free / Pro / Premium
- **Route:** `/help` — **Screen:** Help & Support

---

## 4. Requirements

- Flutter SDK `^3.9.2` (stable channel) — install via [flutter.dev](https://flutter.dev)
- Dart `^3.9.2` (ships with the Flutter SDK)
- Xcode (for iOS/macOS builds) or Android Studio + an Android SDK (for Android builds)
- A device, emulator, simulator, or Chrome/Edge for web

Run `flutter doctor` to confirm your toolchain is ready.

---

## 5. Installation & Quick Start

```bash
git clone <repository-url>
cd nexar_finance
flutter pub get
flutter run
```

The app boots to a splash screen, then onboarding, then login. Since there's no real backend, **any syntactically valid email + a password of 8+ characters** signs you in.

To jump straight to a specific screen during development, change `initialLocation` in `lib/core/routing/app_router.dart` or temporarily flip `isLoggedInNotifier.value = true` in `lib/core/utils/auth_state_notifier.dart`.

---

## 6. Project Structure

```
lib/
├── main.dart
├── core/
│   ├── constants/        app_strings.dart, app_assets.dart, app_constants.dart
│   ├── routing/           app_router.dart  (all GoRoute definitions + AppRoutes constants)
│   ├── theme/              app_colors.dart, app_spacing.dart, app_radius.dart,
│   │                       app_text_styles.dart, app_theme.dart
│   ├── utils/               extensions.dart, responsive.dart, helpers.dart,
│   │                       theme_mode_notifier.dart, font_scale_notifier.dart,
│   │                       auth_state_notifier.dart, transaction_category_style.dart,
│   │                       financial_health_calculator.dart
│   └── widgets/            AppButton, AppCard, AppGlassCard, AppGradientButton,
│                           AppTextField, AppAppBar, AppLoading, AppEmptyState, AppLogoIcon
├── domain/
│   ├── entities/            Account, Transaction, Budget, SavingsGoal, Bill, Debt,
│   │                       Investment, Alert, ChatMessage, UserProfile, SubscriptionPlan
│   ├── repositories/        one interface per entity
│   └── usecases/            one Get*/Add*/Set* class per operation
├── data/
│   ├── models/               *Model extends the matching domain entity
│   ├── repositories/          *RepositoryImpl implements the domain interface
│   └── datasources/mock/      Mock*DataSource — the actual seed data
└── features/
    ├── dashboard/  transactions/  accounts/  chat/
    ├── budget/  savings/  bills/  debt/  investments/
    ├── analytics/  forecast/  financial_health/  alerts/  more/
    ├── auth/  onboarding/  splash/
    └── profile/  settings/  subscription/  help/
        each with presentation/screens, presentation/widgets,
        and presentation/state where a feature needs shared logic
```

---

## 7. Architecture

RidRim follows a light **clean/layered architecture**, adapted to stay simple for a mock-data app rather than over-engineered for a backend that doesn't exist yet:

```
 Screens (features/*/presentation)
        │  calls
        ▼
   Use Cases (domain/usecases)      — one small class per operation, e.g. GetTransactions
        │  calls
        ▼
 Repository Interface (domain/repositories)   — the contract; pure Dart, no implementation detail
        △  implements
        │
 Repository Impl (data/repositories)          — delegates to a data source
        │  calls
        ▼
 Mock Data Source (data/datasources/mock)     — the only place that "knows" data is mocked
```

**Why this shape:** a screen only ever depends on a `*Repository` *interface* and a use case — never on `Mock*DataSource` directly (except to construct the repository, since there's no DI container). Swapping mock data for a real API means writing one new `Api*DataSource` per feature that implements the same repository interface; no screen, widget, or use case changes.

There is **no dependency-injection framework**. Each screen constructs its own repository/use-case instances inline in its `State` class, e.g.:

```dart
final TransactionRepository _repository =
    const TransactionRepositoryImpl(MockTransactionDataSource());
late final GetTransactions _getTransactions = GetTransactions(_repository);
```

This is intentional — it keeps the dependency graph visible at the call site and avoids a service-locator dependency for a project this size.

---

## 8. State Management

No external state-management package (no Provider, Riverpod, Bloc, GetX). Two patterns cover everything:

1. **Local screen state** — the overwhelming majority of screens are `StatefulWidget`s that fetch their own data in `initState`, store it in fields, and call `setState`. This is deliberately simple and easy to trace.
2. **App-wide `ValueNotifier`s** — for the handful of things every screen needs to react to:
    - `themeModeNotifier` (`core/utils/theme_mode_notifier.dart`) — light/dark/system
    - `fontScaleNotifier` (`core/utils/font_scale_notifier.dart`) — accessibility text scaling
    - `isLoggedInNotifier` (`core/utils/auth_state_notifier.dart`) — drives the GoRouter `redirect`

Where a screen has many independent toggle/picker preferences (Settings has ~35), a `Map<String, bool>` / `Map<String, String>` plus small generic builder methods are used instead of one field per preference — see `SettingsScreen._toggles` / `_pickers`.

---

## 9. Navigation

[go_router](https://pub.dev/packages/go_router) is the single navigation system, centralized in `lib/core/routing/app_router.dart`:

- **`AppRoutes`** — every path as a typed `String` constant (plus `transactionDetail(id)` for the one parameterized helper route). Screens never hard-code a path string.
- **`StatefulShellRoute.indexedStack`** drives the 5-tab bottom navigation (`MainShellScreen`), preserving each tab's own navigation stack when you switch tabs.
- **Auth guard** — `GoRouter(refreshListenable: isLoggedInNotifier, redirect: ...)` sends unauthenticated users to `/login` and authenticated users away from onboarding/login. Toggle `isLoggedInNotifier.value` and the whole app reroutes.
- **Nested routes** — e.g. `/login/forgot-password/verify-otp`, `/transactions/:id`, `/settings/legal/terms`.
- Screens navigate with `context.go(...)` (replace stack) or `context.push(...)` (push), imported from `package:go_router/go_router.dart`.

---

## 10. Theme & Design System

Every visual token lives in `lib/core/theme/`:

- **File:** `app_colors.dart` — **Contains:** Brand teal ramp (`primary`, `primaryBright`, `primarySoft`, `primaryHighlight`, `primaryDeep`), neutrals, semantic colors (success/error/warning/info), a large "tile" palette for category icons, gradients, and glassmorphism overlay colors
- **File:** `app_spacing.dart` — **Contains:** `xs` (4) → `section` (48), an 8-step spacing scale
- **File:** `app_radius.dart` — **Contains:** `xs` (6) → `pill` (999)
- **File:** `app_text_styles.dart` — **Contains:** Display/headline/title/body/label styles on Google Fonts "Inter"
- **File:** `app_theme.dart` — **Contains:** Builds `ThemeData` for light & dark from the tokens above; exposes `AppStatusColors` as a `ThemeExtension`

**Only one color changes between light and dark** in spirit — the same teal `primary` is used in both `ColorScheme.fromSeed(seedColor: AppColors.primary, ...)` calls; everything else (backgrounds, surfaces, borders, text) is a separate light/dark neutral pair. No screen defines a `Color(0x...)`, spacing number, or radius inline — everything traces back to these five files.

Two signature visual motifs recur across the app:
- **Gradient hero cards** (`AppColors.primaryGradient`) — Dashboard AI Insight, Debt/Investments summary headers, the auth screens' hero
- **Glassmorphism** (`AppGlassCard`, and the custom-painted `RadialProgressGauge`) — blurred, translucent, bordered surfaces with a soft color-matched glow

---

## 11. Responsive Design

`lib/core/utils/responsive.dart` provides `ResponsiveHelper.of(context)` with a 375×812 reference design:

```dart
final responsive = ResponsiveHelper.of(context);
responsive.spacing(AppSpacing.lg);   // scaled spacing
responsive.width(48);                // scaled width
responsive.iconSize(20);             // scaled icon size
responsive.radius(AppRadius.md);     // scaled radius
responsive.maxContentWidth;          // caps form width on tablet/desktop
```

Scaling is clamped (0.85×–1.25×) so it never over- or under-shoots on very small or very large screens. `DeviceType` (mobile/tablet/largeTablet/desktop) and `responsiveValue(mobile:, tablet:, ...)` are available for layouts that need to branch by breakpoint rather than just scale.

---

## 12. Reusable Components

`lib/core/widgets/`:

- **Widget:** `AppButton` — **Use:** Primary (gradient)/secondary/outline/text button variants, loading state
- **Widget:** `AppGradientButton` — **Use:** Standalone brand-gradient CTA button
- **Widget:** `AppCard` — **Use:** Standard bordered surface, optional `onTap`
- **Widget:** `AppGlassCard` — **Use:** Blurred, translucent glassmorphic surface
- **Widget:** `AppTextField` — **Use:** Labeled input with prefix/suffix icon, validator support
- **Widget:** `AppAppBar` — **Use:** Themed app bar with optional subtitle
- **Widget:** `AppLoading` — **Use:** Small/button/normal/full-screen spinner presets
- **Widget:** `AppEmptyState` — **Use:** Icon + title + description (+ optional CTA)
- **Widget:** `AppLogoIcon` — **Use:** App logo image wrapper

Feature-local reusable widgets worth knowing about: `RadialProgressGauge` (glassmorphic gradient-stroke ring, used by Budget and Financial Health), `TransactionTile`, `AccountCard`, `SettingsGroupCard` / `SettingsTileData` / `ProfileMenuTile` (every Settings/Profile row), and `AuthScaffold` / `AuthTipCard` (shared shell for all 5 auth screens).

---

## 13. Customization

- **To change...:** Brand color — **Edit...:** The five `primary*` constants in `app_colors.dart`
- **To change...:** App name / tagline — **Edit...:** `AppStrings.appName` / `AppStrings.appTagline` in `app_strings.dart`
- **To change...:** Logo / launcher icon — **Edit...:** `assets/logo/logo.png` (also feeds `flutter_launcher_icons` in `pubspec.yaml`)
- **To change...:** Typography — **Edit...:** `app_text_styles.dart` (swap the `GoogleFonts.inter(...)` calls)
- **To change...:** Spacing/radius scale — **Edit...:** `app_spacing.dart` / `app_radius.dart`
- **To change...:** Mock/seed data — **Edit...:** Any `data/datasources/mock/mock_*_data.dart`
- **To change...:** Routes — **Edit...:** `core/routing/app_router.dart`
- **To change...:** Onboarding copy/icons — **Edit...:** `features/onboarding/presentation/widgets/onboarding_page_data.dart` + `app_strings.dart`

---

## 14. Branding / Logo / App Name

- **App name**: `AppStrings.appName` = `"RidRim"` — shown on the splash screen and used as the window/app title in `main.dart`.
- **Logo**: `assets/logo/logo.png`, referenced via `AppAssets.appLogo`. Used by the splash screen and `flutter_launcher_icons`.
- **Package identifier**: the Flutter package name is `ridrim` (internal `package:ridrim/...` imports), and the store identifiers are `com.ridrim.finance` for both Android (`applicationId`) and iOS (`PRODUCT_BUNDLE_IDENTIFIER`) — change these if you want a different identifier for your own store listing.

---

## 15. Assets

```
assets/
├── logo/
│   └── logo.png          # App logo / launcher icon source
└── icons/
    ├── logos_google-icon.svg
    ├── logos_facebook.svg
    └── logos_apple.svg   # Social sign-in brand marks (auth screens)
```

Declared in `pubspec.yaml` under `flutter: assets:`. Add new assets there before referencing them.

---

## 16. Mock/Demo Data

Every list, chart, and stat is generated by an in-memory `Mock*DataSource` under `lib/data/datasources/mock/`:

- **Data source:** `mock_account_data.dart` — **Feeds:** 4 accounts (checking, savings, credit, investment)
- **Data source:** `mock_transaction_data.dart` — **Feeds:** ~25 seed transactions across categories/dates; `addTransaction` mutates a shared `static` list so additions are visible across screens
- **Data source:** `mock_budget_data.dart` — **Feeds:** 6 category budgets
- **Data source:** `mock_savings_goal_data.dart` — **Feeds:** 4 savings goals; supports add + contribute
- **Data source:** `mock_bill_data.dart` — **Feeds:** 7 bills (mixed overdue/upcoming/paid)
- **Data source:** `mock_debt_data.dart` — **Feeds:** 3 debts (credit card, student loan, auto loan)
- **Data source:** `mock_investment_data.dart` — **Feeds:** 5 holdings (stock/ETF/crypto/bond)
- **Data source:** `mock_alert_data.dart` — **Feeds:** 6 alerts across severities; supports mark-as-read
- **Data source:** `mock_chat_data.dart` — **Feeds:** Keyword-matches user questions against the mock transactions/budgets to generate answers (and chart data) rather than returning canned text
- **Data source:** `mock_user_data.dart` — **Feeds:** The signed-in demo profile
- **Data source:** `mock_subscription_data.dart` — **Feeds:** Free / Pro / Premium plan definitions

Most mock sources compute dates **relative to `DateTime.now()`** (e.g. "3 days ago"), so the app looks current no matter when you run it.

---

## 17. Authentication

Authentication is fully **simulated** — there is no backend, token storage, or persistence:

- `LoginScreen` / `RegisterScreen` validate the form, wait ~600ms (to feel real), then set `isLoggedInNotifier.value = true` and `context.go(AppRoutes.dashboard)`.
- `isLoggedInNotifier` is a plain in-memory `ValueNotifier<bool>` — it resets to `false` on every cold start, so you'll always see onboarding → login again after a full restart.
- The Forgot Password → Verify OTP → Reset Password flow is a 3-step simulated round trip (any 6-digit code "verifies"), useful as a ready-made UI to wire up to a real auth provider.
- All 5 auth screens share `AuthScaffold`: a teal gradient hero (icon, title, subtitle) with the form presented as a rounded card docked to the bottom of the screen, like a permanently-open bottom sheet.

To integrate real authentication, replace the body of `_submit()` in each auth screen with your provider's call, and flip `isLoggedInNotifier.value` based on the result — the router guard needs no changes.

---

## 18. Main App Features

See [§2 Features](#2-features) and [§3 Screen List](#3-complete-screen--route-list) above for the full breakdown. Highlights worth calling out for anyone extending the app:

- **Dashboard** (`features/dashboard`) computes everything it shows (net worth, sparkline, category donut, top budgets, recent transactions) from the same repositories the other screens use — it has no data of its own.
- **AI Chat** (`features/chat`) answers by pattern-matching the user's message against keywords ("overspend", "trend", category names) and querying the mock repositories live — see `MockChatDataSource.generateReply`.
- **Financial Health score** is computed by a single shared utility, `FinancialHealthCalculator` (`core/utils/financial_health_calculator.dart`), used by both the Financial Health screen and the Profile's Financial Overview so the number is always consistent.

---

## 19. Settings

`/settings` is intentionally the most exhaustive screen in the app — it doubles as a reference for how far a preferences screen can go while staying readable:

**Appearance** · **Finance Preferences** (currency, format, decimal places, default account, budget cycle, week start, financial year) · **AI Settings** (master switch + 10 feature toggles + advice/insight frequency + AI tone) · **Notifications** (general + 5 categorized groups: Transaction, Budget, Bill, Savings, AI) · **Budget Settings** · **Accounts & Wallets** · **Goals** · **Bills & Subscriptions** · **Debt** · **Security & Privacy** (2FA, PIN, biometric, auto-lock, device alerts, AI data usage, analytics permission) · **Analytics & Reports** · **General** (language, date/time format, font size, sound, auto-update) · **Data & Sync** (cloud sync, backup, export, reset) · **Support & Legal**.

All toggles/pickers are local `State` (no persistence) — see [§8 State Management](#8-state-management) for the `Map`-based pattern used to keep this manageable.

---

## 20. API/Backend Integration Information

There is no backend today. The architecture is set up so integrating one is additive, not a rewrite:

1. **Pick a feature** (e.g. Transactions) and look at its repository interface (`domain/repositories/transaction_repository.dart`) — that's the contract you need to satisfy.
2. **Write a new data source**, e.g. `data/datasources/remote/api_transaction_data_source.dart`, with the same method signatures as the `Mock*DataSource` it replaces (`getTransactions()`, `addTransaction(...)`).
3. **Point the repository at it** — change the one line where the screen constructs `TransactionRepositoryImpl(MockTransactionDataSource())` to `TransactionRepositoryImpl(ApiTransactionDataSource(...))`.
4. Nothing else changes — the use case, the screen, and every widget already depend only on the `TransactionRepository` interface.

For authentication, wire a real provider into the `_submit()` methods on the 5 auth screens (see [§17](#17-authentication)); for persistence, either add `shared_preferences`/`hive` behind the same repository interfaces or introduce a proper backend and repeat step 2–3 per feature.

---

## 21. Production Build

```bash
flutter analyze          # static analysis — should report 0 issues
flutter test              # run the test suite
flutter build apk --release        # Android APK
flutter build appbundle --release  # Android App Bundle (Play Store)
flutter build ios --release        # iOS (requires Xcode + signing)
flutter build web --release        # Web
```

Before shipping, review `pubspec.yaml`'s `version:`, the app id/bundle id in `android/app/build.gradle` and `ios/Runner.xcodeproj`, and replace `assets/logo/logo.png` with your final artwork if you haven't already.

---

## 22. Android/iOS Build

**Android**
```bash
flutter build apk --release --split-per-abi   # smaller per-architecture APKs
flutter build appbundle --release             # required for Play Store
```
App icon generation is already configured — `flutter pub run flutter_launcher_icons` regenerates all Android/iOS icon sizes from `assets/logo/logo.png` per the `flutter_launcher_icons:` block in `pubspec.yaml`.

**iOS**
```bash
flutter build ios --release
open ios/Runner.xcworkspace   # set your Team/signing in Xcode, then Archive
```

---

## 23. Troubleshooting

- **Symptom:** `flutter pub get` fails on the Dart SDK constraint — **Fix:** Update Flutter: `flutter upgrade` (needs Dart `^3.9.2`)
- **Symptom:** Blank/red error screen after a hot reload — **Fix:** Hot **restart** (`R` in the terminal, or the IDE's restart button) — some changes (new `const` fields, enum changes) need a full restart, not just reload
- **Symptom:** Chart labels look duplicated — **Fix:** Ensure `fl_chart` axis `SideTitles` specify `interval: 1` when x-values are small integers (the app already does this — a useful pattern if you add new charts)
- **Symptom:** A row's label/value text overlaps or truncates oddly — **Fix:** `ProfileMenuTile` renders `valueText` as a second line under the label rather than beside it, specifically to avoid this on phone-width screens — follow the same pattern for new Settings rows
- **Symptom:** Login doesn't "remember" you after restart — **Fix:** Expected — `isLoggedInNotifier` is in-memory only; see [§17](#17-authentication)
- **Symptom:** Emulator shows a stale screen after multiple `flutter run`s — **Fix:** Force-stop the app (`adb shell am force-stop <package>`) and relaunch — repeated background `flutter run` processes can leave stale instances in the OS task list

---

## 24. Dependencies

- **Package:** `go_router` — **Version:** ^17.2.3 — **Purpose:** Navigation
- **Package:** `fl_chart` — **Version:** ^0.70.2 — **Purpose:** Charts
- **Package:** `google_fonts` — **Version:** ^6.2.1 — **Purpose:** Typography (Inter)
- **Package:** `flutter_svg` — **Version:** ^2.0.10+1 — **Purpose:** SVG social icons
- **Package:** `image_picker` — **Version:** ^1.2.2 — **Purpose:** Chat image attachments
- **Package:** `file_picker` — **Version:** ^11.0.3 — **Purpose:** Chat file attachments
- **Package:** `speech_to_text` — **Version:** ^7.4.0 — **Purpose:** AI Chat voice input
- **Package:** `url_launcher` — **Version:** ^6.3.1 — **Purpose:** External links
- **Package:** `cupertino_icons` — **Version:** ^1.0.8 — **Purpose:** iOS-style icons
- **Package:** `flutter_lints` (dev) — **Version:** ^5.0.0 — **Purpose:** Lint rules
- **Package:** `flutter_launcher_icons` (dev) — **Version:** ^0.14.4 — **Purpose:** Icon generation

---

## 25. Credits

Built on Flutter & Material 3. Charts by [`fl_chart`](https://pub.dev/packages/fl_chart). Navigation by [`go_router`](https://pub.dev/packages/go_router). Typography via [Google Fonts](https://fonts.google.com) (Inter). Social sign-in marks are official brand assets of their respective owners (Google, Apple, Meta) and are used for UI representation only.

---

## 26. Changelog

**2026-08-22 — Marketplace-readiness pass**
- App identity finalized: package name `ridrim`, Android `applicationId` / iOS `PRODUCT_BUNDLE_IDENTIFIER` set to `com.ridrim.finance` (was the `com.example.*` placeholder), launcher icon regenerated for Android/iOS/web from the RidRim brand mark
- Fixed a dashboard account-card overflow that hit most iPhone widths (375-410pt) — the compact carousel now sizes to its content instead of a fixed height
- Added the 5 missing iOS `Info.plist` usage-description keys (camera, photo library x2, microphone, speech recognition) that would have crashed the app on first use of the photo picker or voice input
- Google/Apple/Facebook sign-in buttons changed from a tappable "coming soon" stub to a visually static/disabled control (no backend to wire them to yet)
- Bottom-nav "Transactions" label shortened to "Activity" to stop wrapping on the narrowest phone widths
- Fixed the AI Insight card's text/icon/sparkline being unreadable (white-on-near-white) in light theme
- Bill row due-date no longer gets truncated away behind a long payee name

**Unreleased**
- Full rebrand from a generic AI-SaaS template to RidRim: teal design system, GoRouter navigation, and a complete personal-finance feature set (Dashboard, Transactions, Accounts, Budget, Savings, Bills, Debt, Investments, Analytics, Forecast, Financial Health, Alerts)
- AI Chat rebuilt to answer over real (mock) financial data with inline charts
- Profile rebuilt with a Financial Overview, Financial Profile, and AI Profile
- Settings rebuilt into a comprehensive finance + AI preferences center
- Auth flow redesigned with a gradient-hero/bottom-sheet-card layout

---

## 27. License

Proprietary. All rights reserved unless a `LICENSE` file is added to this repository specifying otherwise. If distributing via a marketplace, replace this section with that marketplace's required license text.

---

## 28. Support

For codebase questions, start with this document and [`README.md`](README.md) — together they cover setup, architecture, customization, and troubleshooting. For bugs or feature requests, use your project's issue tracker.

---

## 29. Thank You

Thanks for using RidRim. Whether you're building a real fintech product on top of this scaffold or using it to learn a clean, dependency-light Flutter architecture, we hope the codebase is as pleasant to extend as it was to build. Happy shipping. 🌊
