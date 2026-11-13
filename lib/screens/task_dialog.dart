import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/task_model.dart';

class TaskDialog extends StatefulWidget {
  final Task? task;

  const TaskDialog({super.key, this.task});

  @override
  State<TaskDialog> createState() => _TaskDialogState();
}

class _TaskDialogState extends State<TaskDialog> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _titleController;
  late TextEditingController _descriptionController;

  late DateTime _selectedDueDate;
  late TimeOfDay _selectedTime;
  late String _selectedPriority; // 'low', 'medium', 'high'

  @override
  void initState() {
    super.initState();
    final task = widget.task;
    _titleController = TextEditingController(text: task?.title ?? '');
    _descriptionController = TextEditingController(text: task?.description ?? '');

    final initialDate = task?.dueDate ?? DateTime.now().add(const Duration(hours: 1));
    _selectedDueDate = initialDate;
    _selectedTime = TimeOfDay.fromDateTime(initialDate);
    _selectedPriority = task?.priority ?? 'medium';
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDueDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDueDate = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          _selectedTime.hour,
          _selectedTime.minute,
        );
      });
    }
  }

  Future<void> _pickTime() async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );

    if (pickedTime != null) {
      setState(() {
        _selectedTime = pickedTime;
        _selectedDueDate = DateTime(
          _selectedDueDate.year,
          _selectedDueDate.month,
          _selectedDueDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );
      });
    }
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final task = Task(
      id: widget.task?.id ?? '',
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      dueDate: _selectedDueDate,
      priority: _selectedPriority,
      isCompleted: widget.task?.isCompleted ?? false,
    );

    Navigator.of(context).pop(task);
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.task != null;
    final theme = Theme.of(context);

    return AlertDialog(
      title: Text(isEditing ? 'Edit Task' : 'New Task'),
      content: SingleChildScrollView(
        child: SizedBox(
          width: 380,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _titleController,
                  maxLength: 80,
                  textCapitalization: TextCapitalization.sentences,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: 'Task Title',
                    hintText: 'e.g. Complete delivery order #1042',
                    counterText: '',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a task title';
                    }
                    if (value.trim().length < 3) {
                      return 'Title must be at least 3 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _descriptionController,
                  maxLines: 3,
                  maxLength: 250,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    labelText: 'Description (optional)',
                    hintText: 'Add specific details or instructions...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text('Priority', style: theme.textTheme.titleSmall),
                const SizedBox(height: 8),
                Row(
                  children: [
                    for (final p in [
                      {'val': 'low', 'label': 'Low', 'color': Colors.green.shade600},
                      {'val': 'medium', 'label': 'Medium', 'color': Colors.orange.shade700},
                      {'val': 'high', 'label': 'High', 'color': Colors.red.shade600},
                    ])
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 3.0),
                          child: ChoiceChip(
                            showCheckmark: false,
                            label: Center(
                              child: Text(
                                p['label'] as String,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: _selectedPriority == p['val']
                                      ? (p['color'] as Color)
                                      : theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ),
                            selected: _selectedPriority == p['val'],
                            selectedColor: (p['color'] as Color).withValues(alpha: 0.18),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: BorderSide(
                                color: _selectedPriority == p['val']
                                    ? (p['color'] as Color)
                                    : theme.colorScheme.outlineVariant,
                              ),
                            ),
                            onSelected: (selected) {
                              if (selected) {
                                setState(() {
                                  _selectedPriority = p['val'] as String;
                                });
                              }
                            },
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                Text('Due Date & Time', style: theme.textTheme.titleSmall),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _pickDate,
                        icon: const Icon(Icons.calendar_today, size: 18),
                        label: Text(
                          DateFormat('MMM dd, yyyy').format(_selectedDueDate),
                          style: const TextStyle(fontSize: 13),
                        ),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _pickTime,
                        icon: const Icon(Icons.access_time, size: 18),
                        label: Text(
                          _selectedTime.format(context),
                          style: const TextStyle(fontSize: 13),
                        ),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _submit,
          child: Text(isEditing ? 'Save Changes' : 'Create Task'),
        ),
      ],
    );
  }
}
