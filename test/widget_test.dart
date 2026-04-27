import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:habit_tracker/main.dart';

void main() {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  testWidgets('App shows Habit Tracker title', (WidgetTester tester) async {
    await tester.pumpWidget(const HabitTrackerApp());

    expect(find.text('Habit Tracker'), findsOneWidget);
    expect(find.text('Habits'), findsOneWidget);
  });
}
