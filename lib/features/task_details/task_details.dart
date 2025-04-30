import 'package:flutter/material.dart';

import '../../shared/model/task.dart';

class TaskDetailsScreen extends StatelessWidget {
  final Task task;

  const TaskDetailsScreen({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              task.name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              task.taskType.name,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            const Text(
              'Subtasks',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: task.subTasks?.length ?? 0,
                itemBuilder: (context, index) {
                  final subTask = task.subTasks![index];
                  return ListTile(
                    leading: Radio<bool>(
                      value: true,
                      groupValue: subTask.complete,
                      onChanged: (value) {
                        subTask.complete = value!;
                        // Update the task object and send to Firebase
                        // updateTaskInFirebase(task);
                      },
                    ),
                    title: Text(subTask.name),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
