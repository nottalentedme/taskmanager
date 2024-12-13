import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:task/feature/model/task_model.dart';

class TaskRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  TaskRepository(this._auth, this._firestore);

  String get _userId => _auth.currentUser!.uid;

  Stream<List<TaskModel>> getTasks() {
    return _firestore
        .collection('users')
        .doc(_userId)
        .collection('tasks')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => TaskModel.fromFirestore(doc)).toList();
    });
  }

  Future<void> addTask(String title, String description) async {
    await _firestore.collection('users').doc(_userId).collection('tasks').add(
      {
        'title': title,
        'description': description,
        'isCompleted': false,
      },
    );
  }

   Future<void> updateTask(TaskModel task) async {
    await _firestore
        .collection('users')
        .doc(_userId)
        .collection('tasks')
        .doc(task.id)
        .update(task.toMap());
  }

  Future<void> deleteTask(String taskId) async {
    await _firestore
        .collection('users')
        .doc(_userId)
        .collection('tasks')
        .doc(taskId)
        .delete();
  }
}
