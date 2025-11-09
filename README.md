# Android Push Notifications

A Flutter application demonstrating push notification implementation using Firebase Cloud Messaging (FCM) and local notifications. Includes handling notifications in foreground, background, and terminated states.

## Demo

https://github.com/user-attachments/assets/4cf8ce13-90bd-457d-8282-8a245fc68168

## Features

- Firebase Cloud Messaging (FCM) integration for remote push notifications
- Local notifications with custom sounds
- Notification handling in all app states (foreground, background, terminated)
- Navigation based on notification interactions
- BLoC pattern for state management


## Installation

### Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install) (3.9.2 or higher)
- Dart SDK (included with Flutter)
- Android Studio / Xcode / VS Code with Flutter extensions

### Steps

1. Clone the repository:
```bash
git clone https://github.com/jumagu/android_push_notifications.git
cd android_push_notifications
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

### Available Commands

- `flutter run` - Run the app in debug mode
- `flutter build apk` - Build Android APK
- `flutter build appbundle` - Build Android App Bundle
- `flutter build ios` - Build iOS app (requires macOS)
- `flutter build windows` - Build Windows desktop app
- `flutter test` - Run tests
- `flutter clean` - Clean build artifacts

## Project Structure

The project follows Clean Architecture principles:

- `config/` - Configuration (themes, helpers)
- `domain/` - Business entities
- `presentation/` - UI (screens, widgets, providers)

## Dependencies

- `flutter` - Flutter SDK
- `firebase_core: 4.2.1` - Firebase core functionality
- `firebase_messaging: 16.0.3` - Firebase Cloud Messaging for push notifications
- `flutter_local_notifications: 19.5.0` - Local notification display and handling
- `flutter_bloc: 9.1.1` - BLoC pattern state management
- `equatable: 2.0.7` - Value equality for Dart objects
- `go_router: 16.3.0` - Declarative routing for Flutter

## License

This project is part of a Flutter course.
