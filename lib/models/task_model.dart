import 'package:cloud_firestore/cloud_firestore.dart';

enum TaskPriority { low, medium, high }

/// Represents a single task item owned by a user.
class Task {
  final String id;
  final String title;
  final String description;
  final DateTime dueDate;
  final String priority; // 'low', 'medium', 'high'
  final bool isCompleted;

  const Task({
    required this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.priority,
    this.isCompleted = false,
  });

  /// Priority helper enum representation
  TaskPriority get priorityEnum {
    switch (priority.toLowerCase()) {
      case 'high':
        return TaskPriority.high;
      case 'low':
        return TaskPriority.low;
      case 'medium':
      default:
        return TaskPriority.medium;
    }
  }

  /// Checks if the task is past due date and incomplete
  bool get isOverdue =>
      !isCompleted && dueDate.isBefore(DateTime.now());

  /// Creates a Task instance from a Firestore document snapshot
  factory Task.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return Task(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      dueDate: (data['dueDate'] is Timestamp)
          ? (data['dueDate'] as Timestamp).toDate()
          : DateTime.now(),
      priority: data['priority'] ?? 'medium',
      isCompleted: data['isCompleted'] ?? false,
    );
  }

  /// Converts Task instance to a Firestore JSON Map
  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
      'dueDate': Timestamp.fromDate(dueDate),
      'priority': priority.toLowerCase(),
      'isCompleted': isCompleted,
    };
  }

  /// Creates a copy of Task with updated values
  Task copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? dueDate,
    String? priority,
    bool? isCompleted,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      priority: priority ?? this.priority,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Task &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          description == other.description &&
          dueDate == other.dueDate &&
          priority == other.priority &&
          isCompleted == other.isCompleted;

  @override
  int get hashCode =>
      id.hashCode ^
      title.hashCode ^
      description.hashCode ^
      dueDate.hashCode ^
      priority.hashCode ^
      isCompleted.hashCode;

  @override
  String toString() {
    return 'Task(id: $id, title: $title, priority: $priority, isCompleted: $isCompleted, dueDate: $dueDate)';
  }
}
