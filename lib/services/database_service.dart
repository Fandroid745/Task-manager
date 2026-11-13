import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/task_model.dart';

/// Database service handling Firestore persistence, real-time streaming, and queries.
class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Retrieves the current authenticated user ID
  String? get _userId => FirebaseAuth.instance.currentUser?.uid;

  /// Helper reference to the user's tasks collection in Firestore
  CollectionReference? get _taskRef {
    final uid = _userId;
    if (uid == null) return null;
    return _db.collection('users').doc(uid).collection('tasks');
  }

  /// Adds a new task for the current authenticated user
  Future<void> addTask(Task task) async {
    final ref = _taskRef;
    if (ref == null) throw 'User session expired. Please sign in again.';
    if (task.title.trim().isEmpty) throw 'Task title cannot be empty.';

    await ref.add(task.toFirestore());
  }

  /// Updates an existing task document in Firestore
  Future<void> updateTask(Task task) async {
    final ref = _taskRef;
    if (ref == null) throw 'User session expired. Please sign in again.';
    if (task.id.isEmpty) throw 'Invalid task identifier.';

    await ref.doc(task.id).update(task.toFirestore());
  }

  /// Toggles the completion status of a task
  Future<void> toggleCompletion(String taskId, bool isCompleted) async {
    final ref = _taskRef;
    if (ref == null) throw 'User session expired. Please sign in again.';
    if (taskId.isEmpty) throw 'Invalid task identifier.';

    await ref.doc(taskId).update({'isCompleted': isCompleted});
  }

  /// Deletes a task from Firestore
  Future<void> deleteTask(String taskId) async {
    final ref = _taskRef;
    if (ref == null) throw 'User session expired. Please sign in again.';
    if (taskId.isEmpty) throw 'Invalid task identifier.';

    await ref.doc(taskId).delete();
  }

  /// Real-time stream of user tasks sorted by due date (earliest to latest) with optional filters
  Stream<List<Task>> getTasksStream({
    String priorityFilter = 'All',
    String statusFilter = 'All',
  }) {
    final ref = _taskRef;
    if (ref == null) return Stream.value([]);

    return ref.orderBy('dueDate', descending: false).snapshots().map((snapshot) {
      final tasks = snapshot.docs.map((doc) => Task.fromFirestore(doc)).toList();

      return tasks.where((task) {
        // Filter by Priority
        if (priorityFilter != 'All' &&
            task.priority.toLowerCase() != priorityFilter.toLowerCase()) {
          return false;
        }

        // Filter by Completion Status
        if (statusFilter == 'Completed' && !task.isCompleted) {
          return false;
        }
        if (statusFilter == 'Incomplete' && task.isCompleted) {
          return false;
        }

        return true;
      }).toList();
    });
  }
}
