# Mobile App Project Report Template (Habit Tracker)

## 1. App Idea
Habit Tracker helps users build consistency in daily routines by creating habits and checking them off every day.

## 2. Selected Technology
Flutter (Dart)

## 3. Why Flutter
Flutter allows building beautiful mobile interfaces quickly with one codebase, has strong widget support for UI design, and provides good productivity for student projects.

## 4. Planned Features and Screens
- Home screen: list of habits with completion toggle
- Add/Edit screen: form for habit details
- Stats screen: completion statistics and streaks

## 5. Screen Design
Include sketches or screenshots of:
- Home screen
- Add/Edit habit screen
- Stats screen

## 6. Project Environment Setup
- Android Studio installed
- Flutter SDK configured
- Emulator/device configured for testing

## 7. User Interface Implementation
Describe widgets used:
- `Scaffold`, `AppBar`, `BottomNavigationBar`
- `ListView`, `Card`, `TextFormField`, `Dialog`

## 8. Main Functionality Implementation
- Add/Edit/Delete habits
- Mark completion by date
- Save and load data with SQLite (`sqflite`)
- Calculate streak and 7-day completion rate

## 9. Database Design
- `habits` table:
  - `id` (TEXT, primary key)
  - `title` (TEXT)
  - `notes` (TEXT)
  - `color_value` (INTEGER)
  - `created_at` (TEXT)
- `habit_completions` table:
  - `habit_id` (TEXT, foreign key to habits)
  - `day_key` (TEXT)
  - Composite primary key: (`habit_id`, `day_key`)

## 10. Testing and Improvements
Describe test scenarios:
- App launch with no data
- Add multiple habits
- Mark/unmark completion
- Close/reopen app and verify saved data
- Edit and delete habits

## 11. Conclusion
Summarize what the app solves, what you learned, and future improvements (e.g., reminders, notifications, cloud sync).