import 'package:flutter/material.dart';
import 'package:task_nest/core/services/firestore.dart';
import 'package:task_nest/core/widgets/main_scaffold.dart';
import 'package:task_nest/features/home/widget/task_item_view.dart';

import '../../core/constants/constants.dart';
import '../../shared/model/task.dart';
import '../../shared/type/repeat_type.dart';

class ScheduledTasks extends StatefulWidget {
  const ScheduledTasks({super.key});

  @override
  State<ScheduledTasks> createState() => _ScheduledTasksState();
}

class _ScheduledTasksState extends State<ScheduledTasks> {
  late List<Task> scheduledTasks;

  @override
  void initState() {
    super.initState();
    fetchScheduledTask();
  }

  void fetchScheduledTask() {
    scheduledTasks = Firestore.instance.tasks
        .where((task) => task.repeatType != RepeatType.never)
        .toList();

    scheduledTasks.sort(
            (task1, task2) => task2.completedDate!.compareTo(task1.completedDate!));
  }

  void refreshScreen() {
    fetchScheduledTask();
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      appBarTitle: Constants.history,
      body: ListView.builder(
          itemCount: scheduledTasks.length,
          itemBuilder: (context, index) {
            final task = scheduledTasks[index];
            return TaskItemView(
              task: task,
              onStatusChange: refreshScreen,
            );
          }),
    );
  }
}
