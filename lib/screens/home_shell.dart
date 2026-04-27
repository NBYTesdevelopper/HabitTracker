import 'package:flutter/material.dart';

import '../models/habit.dart';
import '../services/habit_storage_service.dart';
import '../widgets/habit_card.dart';
import 'edit_habit_page.dart';
import 'stats_page.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  final HabitStorageService _storageService = HabitStorageService();

  List<Habit> _habits = <Habit>[];
  bool _loading = true;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadHabits();
  }

  Future<void> _loadHabits() async {
    final loaded = await _storageService.loadHabits();
    if (!mounted) {
      return;
    }

    setState(() {
      _habits = loaded;
      _loading = false;
    });
  }

  Future<void> _persistHabits() {
    return _storageService.saveHabits(_habits);
  }

  Future<void> _upsertHabit(Habit habit) async {
    setState(() {
      final index = _habits.indexWhere((h) => h.id == habit.id);
      if (index == -1) {
        _habits = [habit, ..._habits];
      } else {
        _habits[index] = habit;
      }
    });

    await _persistHabits();
  }

  Future<void> _openAddHabit() async {
    final created = await Navigator.of(context).push<Habit>(
      MaterialPageRoute(builder: (_) => const EditHabitPage()),
    );

    if (created == null) {
      return;
    }

    await _upsertHabit(created);
  }

  Future<void> _openEditHabit(Habit habit) async {
    final updated = await Navigator.of(context).push<Habit>(
      MaterialPageRoute(builder: (_) => EditHabitPage(initialHabit: habit)),
    );

    if (updated == null) {
      return;
    }

    await _upsertHabit(updated);
  }

  Future<void> _toggleToday(Habit habit) async {
    await _upsertHabit(habit.toggleForDate(DateTime.now()));
  }

  Future<void> _deleteHabit(Habit habit) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Habit'),
          content: Text('Are you sure you want to delete "${habit.title}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: FilledButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (shouldDelete != true) {
      return;
    }

    setState(() {
      _habits.removeWhere((h) => h.id == habit.id);
    });

    await _persistHabits();
  }

  Widget _buildHabitsTab() {
    if (_habits.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.track_changes_rounded,
                size: 66,
                color: Color(0xFF94A3B8),
              ),
              const SizedBox(height: 12),
              Text(
                'No habits yet',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Tap "Add Habit" to create your first habit.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 18),
              FilledButton.icon(
                onPressed: _openAddHabit,
                icon: const Icon(Icons.add_rounded),
                label: const Text('Add Habit'),
              ),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadHabits,
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _habits.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          final habit = _habits[index];
          return HabitCard(
            habit: habit,
            onToggleToday: () => _toggleToday(habit),
            onEdit: () => _openEditHabit(habit),
            onDelete: () => _deleteHabit(habit),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final titles = <String>['Habit Tracker', 'Statistics'];

    return Scaffold(
      appBar: AppBar(
        title: Text(titles[_selectedIndex]),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : IndexedStack(
              index: _selectedIndex,
              children: [
                _buildHabitsTab(),
                StatsPage(habits: _habits),
              ],
            ),
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton.extended(
              onPressed: _openAddHabit,
              icon: const Icon(Icons.add_rounded),
              label: const Text('Add Habit'),
            )
          : null,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Habits',
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart_outlined),
            selectedIcon: Icon(Icons.bar_chart_rounded),
            label: 'Stats',
          ),
        ],
      ),
    );
  }
}