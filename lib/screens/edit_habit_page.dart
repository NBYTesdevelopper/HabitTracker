import 'package:flutter/material.dart';

import '../models/habit.dart';

class EditHabitPage extends StatefulWidget {
  const EditHabitPage({super.key, this.initialHabit});

  final Habit? initialHabit;

  bool get isEditing => initialHabit != null;

  @override
  State<EditHabitPage> createState() => _EditHabitPageState();
}

class _EditHabitPageState extends State<EditHabitPage> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _titleController;
  late final TextEditingController _notesController;
  late int _selectedColorValue;

  static const List<Color> _palette = <Color>[
    Color(0xFF2563EB),
    Color(0xFF0EA5E9),
    Color(0xFF14B8A6),
    Color(0xFF22C55E),
    Color(0xFFF59E0B),
    Color(0xFFEF4444),
    Color(0xFF8B5CF6),
    Color(0xFFF43F5E),
  ];

  @override
  void initState() {
    super.initState();
    _titleController =
        TextEditingController(text: widget.initialHabit?.title ?? '');
    _notesController =
        TextEditingController(text: widget.initialHabit?.notes ?? '');
    _selectedColorValue =
        widget.initialHabit?.colorValue ?? _palette.first.toARGB32();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _saveHabit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final now = DateTime.now();
    final habit = Habit(
      id: widget.initialHabit?.id ?? now.microsecondsSinceEpoch.toString(),
      title: _titleController.text.trim(),
      notes: _notesController.text.trim(),
      colorValue: _selectedColorValue,
      createdAt: widget.initialHabit?.createdAt ?? now,
      completedDates: widget.initialHabit?.completedDates,
    );

    Navigator.of(context).pop(habit);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEditing ? 'Edit Habit' : 'Add Habit'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Habit Name',
                hintText: 'e.g. Read 20 minutes',
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.next,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a habit name.';
                }
                if (value.trim().length < 2) {
                  return 'Habit name should be at least 2 characters.';
                }
                return null;
              },
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _notesController,
              minLines: 2,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Notes (Optional)',
                hintText: 'Small details or goals for this habit',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 22),
            Text(
              'Pick a Color',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: _palette.map((color) {
                final selected = _selectedColorValue == color.toARGB32();
                return InkWell(
                  borderRadius: BorderRadius.circular(999),
                  onTap: () {
                    setState(() {
                      _selectedColorValue = color.toARGB32();
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: selected ? Colors.black87 : Colors.transparent,
                        width: 2,
                      ),
                      boxShadow: selected
                          ? const [
                              BoxShadow(
                                blurRadius: 10,
                                offset: Offset(0, 3),
                                color: Colors.black26,
                              ),
                            ]
                          : null,
                    ),
                    child: selected
                        ? const Icon(
                            Icons.check_rounded,
                            color: Colors.white,
                          )
                        : null,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 30),
            FilledButton.icon(
              onPressed: _saveHabit,
              icon: const Icon(Icons.save_rounded),
              label: Text(widget.isEditing ? 'Save Changes' : 'Create Habit'),
            ),
          ],
        ),
      ),
    );
  }
}
