import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

import '../models/habit.dart';

class HabitStorageService {
  static const _dbName = 'habit_tracker.db';
  static const _dbVersion = 1;

  static const _habitsTable = 'habits';
  static const _habitCompletionsTable = 'habit_completions';

  Future<Database>? _databaseFuture;

  Future<Database> _getDatabase() {
    return _databaseFuture ??= _openDatabase();
  }

  Future<Database> _openDatabase() async {
    String dbRootPath;
    try {
      dbRootPath = await getDatabasesPath();
    } catch (_) {
      dbRootPath = '';
    }

    final dbPath = dbRootPath.isEmpty ? _dbName : p.join(dbRootPath, _dbName);

    return openDatabase(
      dbPath,
      version: _dbVersion,
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $_habitsTable (
            id TEXT PRIMARY KEY,
            title TEXT NOT NULL,
            notes TEXT NOT NULL,
            color_value INTEGER NOT NULL,
            created_at TEXT NOT NULL
          )
        ''');

        await db.execute('''
          CREATE TABLE $_habitCompletionsTable (
            habit_id TEXT NOT NULL,
            day_key TEXT NOT NULL,
            PRIMARY KEY (habit_id, day_key),
            FOREIGN KEY (habit_id) REFERENCES $_habitsTable(id) ON DELETE CASCADE
          )
        ''');
      },
    );
  }

  Future<List<Habit>> loadHabits() async {
    final db = await _getDatabase();

    final habitsRows = await db.query(
      _habitsTable,
      orderBy: 'created_at DESC',
    );

    if (habitsRows.isEmpty) {
      return <Habit>[];
    }

    final completionsRows = await db.query(_habitCompletionsTable);
    final completionsByHabit = <String, Set<String>>{};

    for (final row in completionsRows) {
      final habitId = (row['habit_id'] ?? '').toString();
      final dayKey = (row['day_key'] ?? '').toString();
      if (habitId.isEmpty || dayKey.isEmpty) {
        continue;
      }
      completionsByHabit.putIfAbsent(habitId, () => <String>{}).add(dayKey);
    }

    return habitsRows.map((row) {
      final habitId = (row['id'] ?? '').toString();
      final createdAtRaw = row['created_at'];
      final createdAt =
          DateTime.tryParse(createdAtRaw?.toString() ?? '') ?? DateTime.now();

      return Habit(
        id: habitId,
        title: (row['title'] ?? '').toString(),
        notes: (row['notes'] ?? '').toString(),
        colorValue: (row['color_value'] is int)
            ? row['color_value'] as int
            : 0xFF2563EB,
        createdAt: createdAt,
        completedDates: completionsByHabit[habitId] ?? <String>{},
      );
    }).toList();
  }

  Future<void> saveHabits(List<Habit> habits) async {
    final db = await _getDatabase();

    await db.transaction((txn) async {
      final batch = txn.batch();

      // Keep the write path simple and consistent with current UI flow.
      batch.delete(_habitCompletionsTable);
      batch.delete(_habitsTable);

      for (final habit in habits) {
        batch.insert(
          _habitsTable,
          {
            'id': habit.id,
            'title': habit.title,
            'notes': habit.notes,
            'color_value': habit.colorValue,
            'created_at': habit.createdAt.toIso8601String(),
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );

        final sortedDates = habit.completedDates.toList()..sort();
        for (final dayKey in sortedDates) {
          batch.insert(
            _habitCompletionsTable,
            {
              'habit_id': habit.id,
              'day_key': dayKey,
            },
            conflictAlgorithm: ConflictAlgorithm.ignore,
          );
        }
      }

      await batch.commit(noResult: true);
    });
  }
}
