import 'package:flutter/material.dart';
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
  late List<Task> completedTask;

  @override
  void initState() {
    super.initState();
    completedTask = Firestore.instance.tasks
        .where((task) => task.complete == true)
        .toList();
  }

  void refreshScreen() {
    completedTask = Firestore.instance.tasks
        .where((task) => task.complete == true)
        .toList();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      appBarTitle: Constants.history,
      body: ListView.builder(
          itemCount: completedTask.length,
          itemBuilder: (context, index) {
            final task = completedTask[index];
            return TaskItemView(
              task: task,
              onStatusChange: refreshScreen,
            );
          }),
    );
  }
}
