import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:task_nest/shared/model/task.dart';
import 'package:task_nest/shared/type/task_type.dart';

abstract class _FirestoreKey {
  static const tasks = 'tasks';
}

class Firestore {
  static Firestore instance = Firestore._();

  Firestore._() {
    _firestore = FirebaseFirestore.instance;

    _tasks = _firestore.collection(_FirestoreKey.tasks);
  }

  late final FirebaseFirestore _firestore;
  late final CollectionReference _tasks;

  final workTaskStream = StreamController<List<Task>>();
  final studyTaskStream = StreamController<List<Task>>();
  final homeTaskStream = StreamController<List<Task>>();
  final skillsTaskStream = StreamController<List<Task>>();
  final legalTaskStream = StreamController<List<Task>>();
  final otherTaskStream = StreamController<List<Task>>();

  final List<Task> tasks = [];

  Stream<List<Task>> streamByTaskType(TaskType type) {
    switch (type) {
      case TaskType.work:
        return workTaskStream.stream;
      case TaskType.study:
        return studyTaskStream.stream;
      case TaskType.skills:
        return skillsTaskStream.stream;
      case TaskType.home:
        return homeTaskStream.stream;
      case TaskType.legal:
        return legalTaskStream.stream;
      default:
        return otherTaskStream.stream;
    }
  }

  void allTasks() {
    _tasks.snapshots().listen((snapshot) {
      tasks.clear();
      tasks.addAll(snapshot.docs
          .map((doc) => Task.fromJson(
              documentID: doc.id, json: doc.data() as Map<String, dynamic>))
          .toList());

      workTaskStream.sink
          .add(tasks.where((task) => task.taskType == TaskType.work).toList());

      studyTaskStream.sink
          .add(tasks.where((task) => task.taskType == TaskType.study).toList());

      homeTaskStream.sink
          .add(tasks.where((task) => task.taskType == TaskType.home).toList());

      skillsTaskStream.sink.add(
          tasks.where((task) => task.taskType == TaskType.skills).toList());

      legalTaskStream.sink
          .add(tasks.where((task) => task.taskType == TaskType.legal).toList());

      otherTaskStream.sink
          .add(tasks.where((task) => task.taskType == TaskType.other).toList());
    });
  }

  Future<String> addTask(Task task) async {
    final doc = await _tasks.add(task.toJson());
    return doc.id;
  }

  Future<void> update(Task task) async {
    final doc = await _tasks.add(task.toJson());
    doc.update(task.toJson());
  }

  Future<void> deleteTask(Task task) async {
    await _tasks.doc(task.documentID).delete();
  }
}
