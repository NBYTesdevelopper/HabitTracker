# Habit Tracker (Flutter)

A simple mobile Habit Tracker project for coursework. The app demonstrates:

- Interface design with Material UI
- Navigation using bottom tabs and page routing
- User input with forms (create/edit habits)
- Local data handling with an actual SQLite database

## Features

- Add, edit, and delete habits
- Mark a habit as complete for today
- View streak and 7-day completion rate for each habit
- View overall statistics on a separate Stats tab
- Data persistence between app launches

## Database

- Database engine: SQLite
- Access package: `sqflite`
- Desktop support: `sqflite_common_ffi`
- Web support: `sqflite_common_ffi_web`
- Tables:
  - `habits` (`id`, `title`, `notes`, `color_value`, `created_at`)
  - `habit_completions` (`habit_id`, `day_key`)

## Project Structure

- `lib/main.dart`: app entry point, theme setup, and DB factory configuration
- `lib/screens/home_shell.dart`: main navigation and habit management
- `lib/screens/edit_habit_page.dart`: add/edit habit form
- `lib/screens/stats_page.dart`: statistics dashboard
- `lib/widgets/habit_card.dart`: reusable habit list item UI
- `lib/models/habit.dart`: habit model + streak/rate logic
- `lib/services/habit_storage_service.dart`: SQLite persistence service
- `lib/utils/app_date.dart`: date-key helpers for daily tracking

## Run Steps

1. Install Flutter SDK and Android Studio.
2. Open terminal in `C:\SaaS\HabitTracker`.
3. If platform folders are missing, generate them once:
   - `flutter create .`
4. Install dependencies:
   - `flutter pub get`
5. Run the app:
   - `flutter run -d windows` (or another available device)

