import 'dart:math' as math;

import '../utils/app_date.dart';

class Habit {
  Habit({
    required this.id,
    required this.title,
    required this.notes,
    required this.colorValue,
    required this.createdAt,
    Set<String>? completedDates,
  }) : completedDates = Set<String>.from(completedDates ?? <String>{});

  final String id;
  final String title;
  final String notes;
  final int colorValue;
  final DateTime createdAt;
  final Set<String> completedDates;

  Habit copyWith({
    String? id,
    String? title,
    String? notes,
    int? colorValue,
    DateTime? createdAt,
    Set<String>? completedDates,
  }) {
    return Habit(
      id: id ?? this.id,
      title: title ?? this.title,
      notes: notes ?? this.notes,
      colorValue: colorValue ?? this.colorValue,
      createdAt: createdAt ?? this.createdAt,
      completedDates: completedDates ?? this.completedDates,
    );
  }

  bool isCompletedOn(DateTime date) {
    return completedDates.contains(AppDate.dayKey(date));
  }

  Habit toggleForDate(DateTime date) {
    final key = AppDate.dayKey(date);
    final next = Set<String>.from(completedDates);

    if (next.contains(key)) {
      next.remove(key);
    } else {
      next.add(key);
    }

    return copyWith(completedDates: next);
  }

  int get currentStreak {
    var streak = 0;
    var cursor = AppDate.today();

    while (completedDates.contains(AppDate.dayKey(cursor))) {
      streak += 1;
      cursor = cursor.subtract(const Duration(days: 1));
    }

    return streak;
  }

  int longestStreak() {
    if (completedDates.isEmpty) {
      return 0;
    }

    final dates = completedDates
        .map(AppDate.parseDayKey)
        .toList()
      ..sort();

    var longest = 1;
    var current = 1;

    for (var i = 1; i < dates.length; i++) {
      final diff = dates[i].difference(dates[i - 1]).inDays;
      if (diff == 1) {
        current += 1;
      } else if (diff > 1) {
        current = 1;
      }
      longest = math.max(longest, current);
    }

    return longest;
  }

  double completionRate(int days, {DateTime? endingOn}) {
    if (days <= 0) {
      return 0;
    }

    final end = AppDate.startOfDay(endingOn ?? DateTime.now());
    var completed = 0;

    for (var i = 0; i < days; i++) {
      final day = end.subtract(Duration(days: i));
      if (isCompletedOn(day)) {
        completed += 1;
      }
    }

    return completed / days;
  }

  Map<String, dynamic> toJson() {
    final sortedDates = completedDates.toList()..sort();
    return {
      'id': id,
      'title': title,
      'notes': notes,
      'colorValue': colorValue,
      'createdAt': createdAt.toIso8601String(),
      'completedDates': sortedDates,
    };
  }

  factory Habit.fromJson(Map<String, dynamic> json) {
    final dynamic createdAtRaw = json['createdAt'];
    DateTime createdAt;

    if (createdAtRaw is String) {
      createdAt = DateTime.tryParse(createdAtRaw) ?? DateTime.now();
    } else if (createdAtRaw is int) {
      createdAt = DateTime.fromMillisecondsSinceEpoch(createdAtRaw);
    } else {
      createdAt = DateTime.now();
    }

    final dynamic completedRaw = json['completedDates'];
    final Iterable<dynamic> dateItems = completedRaw is List ? completedRaw : const [];

    return Habit(
      id: (json['id'] ?? DateTime.now().microsecondsSinceEpoch.toString()).toString(),
      title: (json['title'] ?? '').toString(),
      notes: (json['notes'] ?? '').toString(),
      colorValue: (json['colorValue'] is int) ? json['colorValue'] as int : 0xFF2563EB,
      createdAt: createdAt,
      completedDates: dateItems.map((e) => e.toString()).toSet(),
    );
  }
}