# 🎓 Smart Campus Companion

<div align="center">

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Firebase](https://img.shields.io/badge/Firebase-FFCA28?style=for-the-badge&logo=firebase&logoColor=black)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)

**Your all-in-one campus companion app**

[Features](#-features) • [Architecture](#-architecture) • [Getting Started](#-getting-started) • [Class Diagram](#-class-diagram)

</div>

---

## ✨ Features

<table>
<tr>
<td align="center">🔐<br><b>Auth</b></td>
<td align="center">📢<br><b>Announcements</b></td>
<td align="center">📅<br><b>Schedule</b></td>
<td align="center">🏠<br><b>Rooms</b></td>
<td align="center">🛠️<br><b>Services</b></td>
<td align="center">⚙️<br><b>Settings</b></td>
</tr>
<tr>
<td>Login & Register with Firebase</td>
<td>Campus news with offline cache</td>
<td>Weekly timetable by class</td>
<td>Room availability by building</td>
<td>Campus services directory</td>
<td>Dark mode & preferences</td>
</tr>
</table>

---

## 🏗️ Architecture

This app follows **Clean Architecture** with **BLoC** pattern:

```
┌─────────────────────────────────────────────────────────────┐
│                    PRESENTATION LAYER                        │
│  ┌─────────┐  ┌─────────┐  ┌─────────┐  ┌─────────┐        │
│  │  Pages  │  │ Widgets │  │  BLoCs  │  │ States  │        │
│  └────┬────┘  └────┬────┘  └────┬────┘  └────┬────┘        │
└───────┼────────────┼────────────┼────────────┼──────────────┘
        │            │            │            │
┌───────┴────────────┴────────────┴────────────┴──────────────┐
│                      DOMAIN LAYER                            │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐          │
│  │  Entities   │  │  Use Cases  │  │ Repositories│          │
│  └──────┬──────┘  └──────┬──────┘  └──────┬──────┘          │
└─────────┼────────────────┼────────────────┼─────────────────┘
          │                │                │
┌─────────┴────────────────┴────────────────┴─────────────────┐
│                       DATA LAYER                             │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐          │
│  │   Models    │  │ DataSources │  │  Repo Impl  │          │
│  └─────────────┘  └─────────────┘  └─────────────┘          │
└─────────────────────────────────────────────────────────────┘
```

---

## 📊 Class Diagram

```mermaid
classDiagram
    %% Core Entities
    class UserEntity {
        +String id
        +String email
        +String displayName
        +String? classId
    }
    
    class AnnouncementEntity {
        +String id
        +String title
        +String content
        +String category
        +DateTime publishedAt
        +bool isPinned
    }
    
    class ScheduleClassEntity {
        +String id
        +String classId
        +String name
        +String instructor
        +String room
        +int dayOfWeek
        +String startTime
        +String endTime
    }
    
    class RoomEntity {
        +String id
        +String name
        +String buildingId
        +int floor
        +int capacity
        +bool isAvailable
        +String? currentEvent
    }
    
    class BuildingEntity {
        +String id
        +String name
        +String code
        +int floors
    }
    
    class ServiceEntity {
        +String id
        +String name
        +String description
        +String category
        +String hours
        +String location
    }

    %% BLoCs
    class AuthBloc {
        +signIn()
        +signUp()
        +signOut()
    }
    
    class HomeBloc {
        +loadAnnouncements()
    }
    
    class ScheduleBloc {
        +loadSchedule(classId)
        +changeDay(index)
    }
    
    class RoomsBloc {
        +loadRooms()
        +filterByBuilding(id)
    }
    
    class ServicesBloc {
        +loadServices()
    }

    %% Repositories
    class AuthRepository {
        <<interface>>
        +signIn(email, password)
        +signUp(email, password, name)
        +signOut()
        +getCurrentUser()
    }
    
    class AnnouncementRepository {
        <<interface>>
        +getAnnouncements()
    }
    
    class ScheduleRepository {
        <<interface>>
        +getScheduleByClassId(classId)
    }
    
    class RoomsRepository {
        <<interface>>
        +getBuildings()
        +getRooms()
    }
    
    class ServicesRepository {
        <<interface>>
        +getServices()
    }

    %% Relationships
    AuthBloc --> AuthRepository
    HomeBloc --> AnnouncementRepository
    ScheduleBloc --> ScheduleRepository
    RoomsBloc --> RoomsRepository
    ServicesBloc --> ServicesRepository
    
    AuthRepository ..> UserEntity
    AnnouncementRepository ..> AnnouncementEntity
    ScheduleRepository ..> ScheduleClassEntity
    RoomsRepository ..> RoomEntity
    RoomsRepository ..> BuildingEntity
    ServicesRepository ..> ServiceEntity
```

---

## 📁 Project Structure

```
lib/
├── core/
│   ├── constants/      # App constants
│   ├── errors/         # Exceptions & Failures
│   ├── routes/         # Navigation
│   ├── theme/          # App theme
│   ├── utils/          # Utilities & Seeder
│   └── widgets/        # Shared widgets
│
├── features/
│   ├── auth/           # 🔐 Authentication
│   ├── home/           # 📢 Announcements
│   ├── schedule/       # 📅 Class Schedule
│   ├── rooms/          # 🏠 Room Availability
│   ├── services/       # 🛠️ Campus Services
│   ├── profile/        # ⚙️ Settings
│   └── navigation/     # Bottom Navigation
│
├── injection_container.dart
├── app.dart
└── main.dart
```

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.0+)
- Firebase project

### Installation

```bash
# Clone the repository
git clone https://github.com/DevITJAX/Smart-Campus-Companion.git

# Navigate to project
cd Smart-Campus-Companion

# Install dependencies
flutter pub get

# Run the app
flutter run
```

### Firebase Setup

```bash
# Install FlutterFire CLI
dart pub global activate flutterfire_cli

# Configure Firebase
flutterfire configure
```

---

## 🛠️ Tech Stack

| Category | Technology |
|----------|------------|
| Framework | Flutter |
| Language | Dart |
| Backend | Firebase (Auth + Firestore) |
| State Management | BLoC / Cubit |
| Dependency Injection | GetIt |
| Local Storage | Hive + SharedPreferences |
| HTTP | Dio |

---

## 📱 Seed Test Data

To populate the app with test data:
1. Go to **Profile** tab
2. Scroll to **Developer** section
3. Tap **"Seed Test Data"**

This will add sample announcements, buildings, rooms, services, and schedules.

---

## ✅ Requirements Checklist

- [x] Firebase Authentication
- [x] Firestore Database
- [x] Clean Architecture
- [x] BLoC State Management
- [x] Local Caching (Hive)
- [x] Dark/Light Theme
- [x] Material 3 Design
- [x] Offline Support

---

<div align="center">

Made with ❤️ using Flutter

**[⬆ Back to Top](#-smart-campus-companion)**

</div>
