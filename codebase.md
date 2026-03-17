# Flutter Pet Shop App Codebase Overview

This document provides a technical overview of the codebase to assist developers and agents in understanding the project's architecture and organization.

## Architecture
- **Pattern**: Feature-driven Architecture following Clean Architecture principles.
- **State Management**: BLoC (Business Logic Component) and Cubit via `flutter_bloc`.
- **Navigation**: Declarative routing using `go_router`.
- **Modularization**: Heavy use of internal packages in the `packages/` directory to separate concerns.

## Project Structure

### Root Application (`/lib`)
- `bootstrap.dart`: Common initialization logic for all environments (logging, error handling, BLoC observers).
- `main_development.dart`: Entry point for the development environment.
- `main_staging.dart`: Entry point for the staging environment.
- `main_production.dart`: Entry point for the production environment.
- `app/`: Root application widget and view.
- `config/`: Configuration files, including routing setup (`config/route/`).
- `features/`: Core business logic and UI, organized by feature.
  - `auth/`: Authentication flow (login, signup, logout).
  - `home/`: Main dashboard/landing screen.
  - `pets/`: Pet management and listing.
  - `products/`: Product catalog.
  - `appointments/`: Booking and scheduling.
  - `profile/`: User profile management.
  - `settings/`: App-wide settings.
  - `favorite/`: User favorites/wishlist.
  - ...and more (accessory, card, categories, services, shared).
- `l10n/`: Localization files and generated localization code.
- `navigation/`: Bottom navigation bar and overall app navigation structure.
- `splash/`: Splash screen and initial loading logic.

### Internal Packages (`/packages`)
To ensure separation of concerns, the app uses several internal packages:
- `repository/`: The central data layer that coordinates data fetching between network and storage.
- `app_ui/`: A shared design system containing reusable widgets, themes, and UI assets.
- `api_http_client/`: API-specific network layer, typically wrapping Dio with interceptors and base configurations.
- `http_client/`: A lower-level network layer abstraction.
- `storage/`: Persistence layer abstractions.
  - `persistent_storage/`: General local storage (e.g., SharedPreferences).
  - `token_storage/`: Specialized storage for authentication tokens.
  - `storage/`: Base storage interfaces.

## Key Technologies & Dependencies
- **Core Framework**: Flutter (v3.35.0+) / Dart (v3.9.0+).
- **State Management**: `bloc`, `flutter_bloc`, `equatable`.
- **Networking**: `dio`, `http`.
- **Storage**: `shared_preferences`.
- **UI/UX Utilities**: `cached_network_image`, `shimmer`, `flutter_iconly`, `loading_indicator`, `table_calendar`, `badges`.
- **Media**: `image_picker`, `file_picker`, `record`, `audioplayers`, `webview_flutter`.
- **Testing**: `bloc_test`, `mocktail`, `flutter_test`.

## Development Workflows
- **Localization**: Handled via `.arb` files in `lib/l10n/arb/`. Run `flutter gen-l10n` to generate localizations.
- **Environments**: The app supports multiple environments. Use `--target` to point to the desired `main_*.dart` file.
- **Architecture**: Always prefer adding new logic within the appropriate feature folder or internal package. UI-only components should go to `packages/app_ui`.
- **Testing**: Follow the patterns in the `test/` directory, using BLoC tests for logic verification.
