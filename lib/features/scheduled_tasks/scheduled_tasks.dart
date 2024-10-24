import 'package:flutter/material.dart';
import 'package:task_nest/core/widgets/main_scaffold.dart';

import '../../core/constants/constants.dart';

class ScheduledTasks extends StatefulWidget {
  const ScheduledTasks({super.key});

  @override
  State<ScheduledTasks> createState() => _ScheduledTasksState();
}

class _ScheduledTasksState extends State<ScheduledTasks> {
  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      appBarTitle: Constants.taskScheduler,
    );
  }
}
