import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../models/habit.dart';

class StatsPage extends StatelessWidget {
  const StatsPage({super.key, required this.habits});

  final List<Habit> habits;

  @override
  Widget build(BuildContext context) {
    if (habits.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'No stats yet. Add habits and start checking them daily.',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    final completedToday = habits.where((h) => h.isCompletedOn(DateTime.now())).length;
    final bestCurrentStreak = habits.fold<int>(
      0,
      (best, habit) => math.max(best, habit.currentStreak),
    );
    final averageWeeklyRate = habits
            .map((h) => h.completionRate(7))
            .fold<double>(0, (sum, v) => sum + v) /
        habits.length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _MetricCard(
                title: 'Total Habits',
                value: '${habits.length}',
                icon: Icons.list_alt_rounded,
              ),
              _MetricCard(
                title: 'Done Today',
                value: '$completedToday',
                icon: Icons.check_circle_rounded,
              ),
              _MetricCard(
                title: 'Best Streak',
                value: '$bestCurrentStreak days',
                icon: Icons.local_fire_department_rounded,
              ),
              _MetricCard(
                title: 'Avg 7-Day Rate',
                value: '${(averageWeeklyRate * 100).round()}%',
                icon: Icons.query_stats_rounded,
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            'Habit Details',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 10),
          ...habits.map((habit) {
            final weeklyRate = habit.completionRate(7);
            final weeklyPercent = (weeklyRate * 100).round();
            return Card(
              elevation: 0,
              margin: const EdgeInsets.only(bottom: 10),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  title: Text(
                    habit.title,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Current streak: ${habit.currentStreak} day(s) | Longest: ${habit.longestStreak()} day(s)',
                          style: const TextStyle(color: Color(0xFF475569), fontSize: 12),
                        ),
                        const SizedBox(height: 8),
                        LinearProgressIndicator(
                          value: weeklyRate,
                          minHeight: 8,
                          backgroundColor: const Color(0xFFE2E8F0),
                          borderRadius: BorderRadius.circular(999),
                          color: Color(habit.colorValue),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Last 7 days completion: $weeklyPercent%',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  final String title;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 170,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: const Color(0xFF334155)),
          const SizedBox(height: 8),
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: const Color(0xFF64748B),
                ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
          ),
        ],
      ),
    );
  }
}