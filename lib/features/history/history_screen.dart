import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:task_nest/core/services/firestore.dart';
import 'package:task_nest/core/widgets/main_scaffold.dart';
import 'package:task_nest/features/home/widget/task_item_view.dart';

import '../../core/constants/constants.dart';
import '../../shared/model/task.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  late Map<String, List<Task>> completedTaskByMonth;

  @override
  void initState() {
    super.initState();
    fetchCompletedTaskByMonth();
  }

  void fetchCompletedTaskByMonth() {
    completedTaskByMonth = {};

    for (var task in Firestore.instance.tasks) {
      if (task.complete == true && task.completedDate != null) {
        final monthYear =
            '${task.completedDate!.month}-${task.completedDate!.day}';
        if (completedTaskByMonth.containsKey(monthYear)) {
          completedTaskByMonth[monthYear]!.add(task);
        } else {
          completedTaskByMonth[monthYear] = [task];
        }
      }
    }

    completedTaskByMonth.forEach((key, tasks) {
      tasks.sort((task1, task2) =>
          task2.completedDate!.compareTo(task1.completedDate!));
    });

    completedTaskByMonth = Map.fromEntries(completedTaskByMonth.entries.toList()
      ..sort((e1, e2) => e2.key.compareTo(e1.key)));
  }

  void refreshScreen() {
    fetchCompletedTaskByMonth();
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      appBarTitle: Constants.history,
      body: ListView.builder(
        itemCount: completedTaskByMonth.keys.length,
        itemBuilder: (context, index) {
          final monthYear = completedTaskByMonth.keys.elementAt(index);
          final tasks = completedTaskByMonth[monthYear]!;

          return ExpansionTile(
            title: Text(convertDateTimeToMonthDay(tasks[0].completedDate!)),
            initiallyExpanded: true,
            children: tasks.map((task) {
              return TaskItemView(
                task: task,
                onStatusChange: refreshScreen,
              );
            }).toList(),
          );
        },
      ),
    );
  }

  String convertDateTimeToMonthDay(DateTime dateTime) {
    return DateFormat('MMM yy').format(dateTime);
  }
}
