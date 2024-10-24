import 'package:flutter/material.dart';
import 'package:task_nest/core/extensions/date_time_extenssion.dart';
import 'package:task_nest/core/services/firestore.dart';
import 'package:task_nest/shared/type/repeat_type.dart';

import '../../shared/model/task.dart';

class TaskScheduler {
  static TaskScheduler instance = TaskScheduler._();

  TaskScheduler._();

  bool _taskScheduled = false;

  void scheduleTask(List<Task> tasks) {
    if (_taskScheduled) {
      return;
    }
    final taskList =
        tasks.where((task) => task.repeatType != RepeatType.never).toList();
    final scheduledTasks = _removeDuplicateTasks(taskList);

    for (final task in scheduledTasks) {
      if (task.complete == true) {
        final today = DateTime.now();

        switch (task.repeatType) {
          case RepeatType.daily:
            if (!DateUtils.isSameDay(today, task.date!)) {
              _addTask(task);
            }
          case RepeatType.weekly:
            if (task.date!.weekOfYear != today.weekOfYear) {
              _addTask(task);
            }
          case RepeatType.monthly:
            if (task.date!.month != today.month) {
              _addTask(task);
            }
          case RepeatType.never:
            break;
        }
      }
    }

    _taskScheduled = true;
  }

  void _addTask(Task task) {
    Firestore.instance.addTask(task.copyWith(date: DateTime.now()));
  }

  List<Task> _removeDuplicateTasks(List<Task> tasks) {
    tasks.removeWhere((task) => task.date == null);

    tasks.sort((a, b) => b.date!.compareTo(a.date!));

    final taskList = <Task>[];
    for (final task in tasks) {
      if (!taskList.any((item) => item.name == task.name)) {
        taskList.add(task);
      }
    }

    return taskList;
  }
}
