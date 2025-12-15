# Smart Campus Companion 📱

A Flutter app that helps students manage campus life: class schedules, room availability, announcements, and campus services.

## ✨ Features

| Feature | Description |
|---------|-------------|
| 🔐 **Authentication** | Login & Register with Firebase |
| 📢 **Announcements** | Campus news with offline support |
| 📅 **Schedule** | Weekly class timetable by class ID |
| 🏠 **Rooms** | Find available rooms by building |
| 🛠️ **Services** | Campus services directory |
| ⚙️ **Settings** | Dark mode, notifications, profile |

## 🚀 Quick Start

```bash
# 1. Install dependencies
flutter pub get

# 2. Run the app
flutter run
```

## 🔧 Firebase Setup

1. Create project at [Firebase Console](https://console.firebase.google.com/)
2. Enable **Authentication** → Email/Password
3. Create **Firestore Database**
4. Configure:
   ```bash
   dart pub global activate flutterfire_cli
   flutterfire configure
   ```

## 📁 Project Structure

```
lib/
├── core/           # Theme, utils, widgets
├── features/
│   ├── auth/       # Login, Register
│   ├── home/       # Announcements
│   ├── schedule/   # Class schedule
│   ├── rooms/      # Room availability
│   ├── services/   # Campus services
│   └── profile/    # Settings
└── main.dart
```

## 🛠️ Tech Stack

- **Flutter** + Dart
- **Firebase** (Auth, Firestore)
- **BLoC** (State Management)
- **Hive** (Local Storage)
- **GetIt** (Dependency Injection)

## 📱 Seed Test Data

After running the app:
1. Go to **Profile** → **Developer**
2. Tap **Seed Test Data**
3. Data will populate all features

## ✅ Requirements Met

- ✅ Firebase Authentication
- ✅ Firestore Database
- ✅ Clean Architecture
- ✅ BLoC State Management
- ✅ Local Caching (Hive)
- ✅ Dark/Light Theme
- ✅ Material 3 Design

---

Made with ❤️ using Flutter
