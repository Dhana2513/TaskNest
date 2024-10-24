import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:task_nest/core/services/task_scheduler.dart';
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
  int maxTaskIndex = 0;

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

      for (final task in tasks) {
        if (task.index != null) {
          if (task.index! > maxTaskIndex) {
            maxTaskIndex = task.index!;
          }
        }
      }

      TaskScheduler.instance.scheduleTask(tasks);

      tasks.sort((t1, t2) => (t1.index ?? 0) > (t2.index ?? 0) ? 1 : 0);

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
    maxTaskIndex++;
    task.index = maxTaskIndex;
    final doc = await _tasks.add(task.toJson());
    return doc.id;
  }

  Future<void> update(Task task) async {
    final doc = _tasks.doc(task.documentID);
    doc.update(task.toJson());
  }

  Future<void> deleteTask(Task task) async {
    await _tasks.doc(task.documentID).delete();
  }
}
