import 'package:task_nest/core/extensions/map_extension.dart';
import 'package:task_nest/shared/type/task_type.dart';

class Task {
  Task({
    this.documentID,
    required this.name,
    required this.taskType,
    this.time,
    this.complete,
    this.subTasks,
  });

  String? documentID;
  String name;
  int? time;
  bool? complete;
  List<Task>? subTasks;
  TaskType taskType;

  factory Task.fromJson({
    String? documentID,
    required Map<String, dynamic> json,
  }) {
    return Task(
      documentID: documentID,
      name: json.stringForKey(TaskKey.name),
      time: json.intForKey(TaskKey.time),
      complete: json.boolForKey(TaskKey.complete),
      taskType: TaskTypeX.fromString(json.stringForKey(TaskKey.taskType)),
      subTasks: json
          .listForKey(TaskKey.subTasks)
          .map((item) => Task.fromJson(json: item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      TaskKey.name: name,
      TaskKey.taskType: taskType.name,
      TaskKey.time: time,
      TaskKey.complete: complete,
      TaskKey.subTasks: subTasks?.map((task) => task.toJson()).toList() ?? []
    };
  }
}

abstract class TaskKey {
  static const name = 'name';
  static const taskType = 'taskType';
  static const time = 'time';
  static const complete = 'complete';
  static const subTasks = 'subTasks';
}
