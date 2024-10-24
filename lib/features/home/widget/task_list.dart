import 'package:flutter/material.dart';
import 'package:task_nest/core/extensions/box_padding.dart';
import 'package:task_nest/core/services/firestore.dart';
import 'package:task_nest/features/home/widget/total_time_required.dart';
import 'package:task_nest/shared/type/task_type.dart';

import '../../../shared/model/task.dart';
import 'task_item_view.dart';

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

        final filteredTasks =
            tasks.where((task) => task.complete != true).toList();

        return Padding(
          padding: const EdgeInsets.all(BoxPadding.medium),
          child: ListView(
            children: [
              TotalTimeRequired(tasks: filteredTasks),
              ...filteredTasks.map((task) => TaskItemView(task: task)),
            ],
          ),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
