# 💰 Smart Finance App

A cross-platform **Flutter** app that helps users manage expenses, set budgets, and visualize spending habits.  
Built using **Riverpod** for state management and **Hive** for local data storage.

---

## 🚀 Setup Instructions

### 🧩 Prerequisites
- Flutter SDK (v3.x or newer)
- Dart SDK
- Android Studio / VS Code / Xcode
- Emulator or physical device

### ⚙️ Getting Started

1. **Clone the repository**
   ```bash
   git clone https://github.com/Darthwimp/Smart-Finance-App.git
   cd Smart-Finance-App
2. **Install dependencies**
   ```bash
   flutter pub get
3. **Generate Hive adapters (if not already generated)**
   ```bash
   dart run build_runner build
4. **Run the app**
   ```bash
   flutter run
5. **Run the tests**
   ```bash
   flutter test

### 🧱 Architecture Overview
lib/\
├── data/         &nbsp;&nbsp;        # Hive model classes\
├── models/         &nbsp;   &nbsp;  # Hive model classes\
├── providers/     &nbsp;     &nbsp;      # Riverpod / ChangeNotifier state managers\
├── theme/          &nbsp;   &nbsp;     # the light and dark theme data of the app\
├── ui/            &nbsp;   &nbsp;   # contains all the UI widgets and pages\
└── main.dart        &nbsp;   &nbsp;    # Entry point\

### 🧩 State Management
The app uses Riverpod for managing and notufying the UI of state changes\
Uses Hive as the local DB

### 🧑‍💻 Author
**Debargha Das**\
Flutter Developer
