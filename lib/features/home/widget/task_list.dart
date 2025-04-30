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
  Future updateList(
    List<Task> filteredTasks,
    Task updatedTask,
    int oldIndex,
    int newIndex,
  ) async {
    if (newIndex < oldIndex) {
      if (updatedTask.index != null) {
        final listToUpdate = filteredTasks
            .where((task) => (task.index ?? 0) >= updatedTask.index!)
            .toList();

        listToUpdate.remove(updatedTask);

        for (final task in listToUpdate) {
          task.index = task.index! + 1;
          await Firestore.instance.update(task);
        }
      }
    } else {
      if (updatedTask.index != null) {
        final listToUpdate = filteredTasks
            .where((task) => (task.index ?? 0) <= updatedTask.index!)
            .toList();

        listToUpdate.remove(updatedTask);

        for (final task in listToUpdate) {
          task.index = task.index! - 1;
          await Firestore.instance.update(task);
        }
      }
    }
  }

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
          child: ReorderableListView(
            onReorder: (int oldIndex, int newIndex) {
              final task = filteredTasks[oldIndex];

              final index = newIndex >= filteredTasks.length
                  ? filteredTasks.length - 1
                  : newIndex;

              task.index = filteredTasks[index].index;
              Firestore.instance.update(task);

              updateList(filteredTasks, task, oldIndex, index);
            },
            header: TotalTimeRequired(tasks: filteredTasks),
            footer: const SizedBox(height: 64),
            children: [
              ...filteredTasks.map(
                (task) => TaskItemView(
                  task: task,
                  key: ValueKey(task),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
