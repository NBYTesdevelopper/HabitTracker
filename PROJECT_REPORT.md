# Habit Tracker Mobile App Report

## 1. Introduction
In this project, I developed a mobile application called **Habit Tracker** using Flutter. The main goal of this project was to build a real app that solves a small real-life problem and to show basic mobile development skills such as interface design, navigation, user input, and data handling. I also wanted this project to be practical, not only for grading, but also for daily use.

Most students (including me) face the same issue: we start good habits, then after some days we forget to continue. I wanted to make a small app that helps me stay consistent. That is why I created a Habit Tracker app where users can add habits, mark daily progress, and monitor streaks and weekly completion rates.

This report explains the full process from idea to final implementation. I describe why I selected Flutter, how I planned the app, how I built it, what problems I faced, and how I solved them. I also include final project information and GitHub repository details.

## 2. Project Idea
The app idea is simple: a user can create habits (for example, "Read 20 minutes", "Drink water", "Workout"), then mark each habit as completed every day. The app stores this data and gives simple statistics.

I selected this idea for three reasons:
1. It solves a real and common daily problem.
2. It still allows me to demonstrate many required mobile concepts.

The main user flow is:
1. Open app.
2. Add one or more habits.
3. Mark habits done for today.
4. Check stats page to see progress.
5. Close app and open later with data still saved.

With this flow, the app stays beginner-friendly but still complete enough to look like a real product.

## 3. Technology Choice
I chose **Flutter** for this project.

### Why Flutter
I picked Flutter because:
- I can build Android, iOS, desktop, and web from one codebase.
- The widget system is clear and fast for UI design.
- Navigation and state updates are straightforward for medium-size student apps.
- Hot reload helps very fast iteration while designing screens.

I considered Kotlin and React Native, but Flutter looked like the best balance for me between productivity and UI control.

### Database Choice
At first, I used local key-value storage (`shared_preferences`) for simple persistence. After improving the project, I migrated to an **actual SQLite database**, which is more professional and better aligned with software engineering practice.

Current database stack:
- `sqflite`
- `sqflite_common_ffi` (desktop)
- `sqflite_common_ffi_web` (web compatibility)

This means the project now uses a real relational database with tables, not only simple key-value strings.

## 4. Planning Stage
Before coding, I made a simple plan for features and screens.

### Main Features Planned
1. Add new habit.
2. Edit existing habit.
3. Delete habit.
4. Mark habit completed for current day.
5. Calculate current streak.
6. Calculate weekly completion percentage.
7. Show global stats.
8. Save all data locally between app sessions.

### Screen Planning
I planned three key screens/components:
1. **Habits screen (home tab)**
   - List all habits
   - Add habit button
   - Toggle completion for today
   - Menu actions (edit/delete)
2. **Add/Edit Habit screen**
   - Form with habit title
   - Optional notes field
   - Color selection
3. **Stats screen**
   - Total habits
   - Done today
   - Best streak
   - Average weekly completion
   - Detailed progress bars by habit

### Data Planning
After migration to SQLite, I designed two tables:
- `habits` table for main habit data
- `habit_completions` table for daily completion records

This normalized structure makes the data cleaner and easier to scale.

## 5. Development Stage
I built the app step by step.

### Environment Setup
- Flutter SDK installed and configured
- Project created in `C:\SaaS\HabitTracker`
- Dependencies installed with `flutter pub get`
- Project tested with `flutter analyze` and `flutter test`

### User Interface Development
The UI is built with Flutter Material widgets:
- `Scaffold`, `AppBar`, `NavigationBar`
- `ListView` for habits list
- `Card` for habit item display
- `TextFormField` for user input
- `FilledButton`, `FloatingActionButton`
- `AlertDialog` for delete confirmation

I used a clean light theme with soft colors and colored indicators for each habit.

### Navigation and Interaction
Navigation is done with bottom tabs:
- Tab 1: Habits
- Tab 2: Statistics

Add/Edit habit opens a separate page with form validation. Habit toggling updates state instantly, then persists changes in database.

### Data Handling Implementation
I created a dedicated service class for persistence:
- `HabitStorageService`

Responsibilities:
- Open SQLite database
- Create tables on first run
- Load habits + completion records
- Save all habits inside a transaction

The app model (`Habit`) keeps business logic methods:
- `isCompletedOn(date)`
- `toggleForDate(date)`
- `currentStreak`
- `longestStreak()`
- `completionRate(days)`

### Testing and Quality Checks
I ran:
- `flutter analyze` to check code quality
- `flutter test` to validate widget behavior

During testing, I had to initialize SQLite FFI for widget tests, then tests passed successfully.

## 6. Final Version
The final version is functional and stable.

### What the final app can do
1. Create habits with title, note, and color.
2. Edit and delete habits.
3. Mark a habit done for today.
4. Show streak and weekly percentage per habit.
5. Show global summary statistics.
6. Keep all user data saved in SQLite between app launches.

### Final Architecture (simple)
- `lib/main.dart`: app startup + database backend config
- `lib/screens/home_shell.dart`: main behavior and tabs
- `lib/screens/edit_habit_page.dart`: add/edit form
- `lib/screens/stats_page.dart`: stats dashboard
- `lib/models/habit.dart`: business model and calculations
- `lib/services/habit_storage_service.dart`: SQLite persistence

### Database Schema
- `habits(id, title, notes, color_value, created_at)`
- `habit_completions(habit_id, day_key)`

The relation between tables is maintained with foreign keys (`ON DELETE CASCADE`), so deleting a habit automatically deletes its completion records.

## 7. Challenges and Solutions
During development, I faced several challenges.

### Challenge 1: Local storage vs real database
- **Problem:** initial implementation used shared preferences, which is easy but not ideal as an actual database.
- **Solution:** migrated to SQLite with structured tables and service layer.
- **Result:** better project quality and cleaner data model.

### Challenge 2: Windows symlink issue when running Flutter
- **Problem:** Flutter plugin build on Windows required symlink support (Developer Mode / permissions).
- **Solution:** enabled the required environment setup and adjusted runtime workflow.
- **Result:** project could run correctly on available devices.

### Challenge 3: Test failure after SQLite migration
- **Problem:** widget tests failed because `databaseFactory` was not initialized in test environment.
- **Solution:** initialized `sqfliteFfi` and set `databaseFactoryFfi` in test setup.
- **Result:** `flutter test` passed.

### Challenge 4: Keeping code simple while adding features
- **Problem:** as features increased, state management could become messy.
- **Solution:** kept clear separation: model logic in `Habit`, persistence in service, UI logic in screens.
- **Result:** easier debugging and maintenance.

## 8. Conclusion
This project helped me understand the complete mobile app workflow: idea, planning, UI development, feature implementation, persistence, testing, and publication.

From a learning perspective, this project was useful in multiple ways:
- I practiced Flutter UI structure and navigation.
- I handled form validation and user interactions.
- I implemented and used an actual SQLite database.
- I learned how to debug runtime and environment issues.
- I used Git and GitHub to publish project code professionally.

If I continue this app in the future, I would add:
1. Notifications/reminders for habits.
2. Weekly/monthly charts.
3. User authentication and cloud sync.
4. Export report feature (PDF).

Overall, I achieved the project objectives and built a working Habit Tracker application that solves a practical daily problem.


