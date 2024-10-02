import 'package:task_nest/core/extensions/map_extension.dart';
import 'package:task_nest/shared/type/task_type.dart';

class Task {
  Task({
    this.documentID,
    this.index,
    required this.name,
    required this.taskType,
    this.minutes,
    this.complete,
    this.subTasks,
    this.completedDate,
  });

  String? documentID;
  int? taskID;
  int? index;
  String name;
  int? minutes;
  bool? complete;
  List<Task>? subTasks;
  TaskType taskType;
  DateTime? completedDate;

  factory Task.fromJson({
    String? documentID,
    required Map<String, dynamic> json,
  }) {
    return Task(
      documentID: documentID,
      name: json.stringForKey(TaskKey.name),
      index: json.intForKey(TaskKey.index),
      minutes: json.intForKey(TaskKey.minutes),
      complete: json.boolForKey(TaskKey.complete),
      taskType: TaskTypeX.fromString(json.stringForKey(TaskKey.taskType)),
      completedDate: json.dateForKey(TaskKey.completedDate),
      subTasks: json
          .listForKey(TaskKey.subTasks)
          .map((item) => Task.fromJson(json: item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      TaskKey.name: name,
      TaskKey.index: index,
      TaskKey.taskType: taskType.name,
      TaskKey.minutes: minutes,
      TaskKey.complete: complete,
      TaskKey.completedDate: completedDate,
      TaskKey.subTasks: subTasks?.map((task) => task.toJson()).toList() ?? []
    };
  }

  Task copyWith({
    String? documentID,
    int? index,
    String? name,
    TaskType? taskType,
    int? minutes,
    bool? complete,
    List<Task>? subTasks,
    DateTime? completedDate,
  }) {
    return Task(
      documentID: documentID ?? this.documentID,
      index: index ?? this.index,
      name: name ?? this.name,
      taskType: taskType ?? this.taskType,
      minutes: minutes ?? this.minutes,
      complete: complete ?? this.complete,
      subTasks: subTasks ?? this.subTasks,
      completedDate: completedDate ?? this.completedDate,
    );
  }
}

abstract class TaskKey {
  static const name = 'name';
  static const index = 'index';
  static const taskType = 'taskType';
  static const minutes = 'minutes';
  static const complete = 'complete';
  static const completedDate = 'completedDate';
  static const subTasks = 'subTasks';
}
