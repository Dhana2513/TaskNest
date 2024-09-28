import 'package:flutter/material.dart';
import 'package:task_nest/core/services/firestore.dart';
import 'package:task_nest/shared/type/task_type.dart';

import '../../../shared/model/task.dart';

class TaskList extends StatefulWidget {
  const TaskList({super.key, required this.taskType});

  final TaskType taskType;

  @override
  State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    return StreamBuilder<List<Task>>(
      stream: Firestore.instance.streamByTaskType(widget.taskType),
      builder: (context, snapshot) {
        final tasks = snapshot.data ?? [];

        return ListView.builder(
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            final task = tasks[index];
            return Text(task.name);
          },
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
