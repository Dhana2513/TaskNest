import 'package:flutter/material.dart';
import 'package:task_nest/core/constants/constants.dart';
import 'package:task_nest/core/constants/text_style.dart';
import 'package:task_nest/core/extensions/box_padding.dart';
import 'package:task_nest/core/extensions/duration_extension.dart';
import 'package:task_nest/core/extensions/int_extension.dart';
import 'package:task_nest/core/extensions/ui_navigator.dart';
import 'package:task_nest/core/services/firestore.dart';
import 'package:task_nest/features/home/add_task_dialog.dart';
import 'package:task_nest/shared/model/task.dart';
import 'package:task_nest/shared/type/task_type.dart';

class TaskItemView extends StatefulWidget {
  const TaskItemView({
    super.key,
    required this.task,
    this.onStatusChange,
  });

  final Task task;
  final VoidCallback? onStatusChange;

  @override
  State<TaskItemView> createState() => _TaskItemViewState();
}

class _TaskItemViewState extends State<TaskItemView> {
  final listTileKey = GlobalKey();

  void openTaskDetails() {}

  void editTask() {
    showDialog(
      context: context,
      builder: (context) => Dialog(child: AddTaskDialog(task: widget.task)),
    );
  }

  void changeCompletionStatus({required bool updatedStatus}) async {
    widget.task.complete = updatedStatus;
    widget.task.completedDate = DateTime.now();
    await Firestore.instance.update(widget.task);
    await Future.delayed(const Duration(milliseconds: 500));
    widget.onStatusChange?.call();
  }

  void deleteTask() {
    void dismissDialog() {
      UINavigator.pop(context);
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('${Constants.delete} ${widget.task.name}?'),
          content: Text('${Constants.deleteAlertText} ${widget.task.name}?'),
          actions: [
            TextButton(
              child: const Text(Constants.delete),
              onPressed: () async {
                dismissDialog();
                await Firestore.instance.deleteTask(widget.task);
                await Future.delayed(const Duration(milliseconds: 500));
                widget.onStatusChange?.call();
              },
            ),
            TextButton(
              child: const Text(Constants.cancel),
              onPressed: () => dismissDialog,
            ),
          ],
        );
      },
    );
  }

  void openContextMenu() {
    final box = listTileKey.currentContext?.findRenderObject() as RenderBox?;
    final position = box?.localToGlobal(Offset.zero);

    PopupMenuItem menuItem({
      required VoidCallback onTap,
      required String name,
      required IconData icon,
    }) {
      return PopupMenuItem(
        onTap: onTap,
        child: Row(
          children: [
            SizedBox(width: BoxPadding.xxLarge, child: Text(name)),
            const SizedBox(width: BoxPadding.small),
            Icon(
              icon,
              color: Colors.grey.shade700,
            ),
          ],
        ),
      );
    }

    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        100,
        position?.dy ?? 100,
        100,
        position?.dy ?? 100,
      ),
      items: [
        menuItem(onTap: editTask, name: Constants.edit, icon: Icons.edit),
        menuItem(onTap: deleteTask, name: Constants.delete, icon: Icons.delete),
      ],
    );
  }

  String getDuration() {
    final duration = widget.task.minutes?.minutesToDuration;
    if (duration == null) return '';
    return '${duration.hours.toString().padLeft(2, '0')}:'
        '${duration.minutes.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    //TODO: add animation when task marked as complete

    return Container(
      margin: const EdgeInsets.all(BoxPadding.xxSmall),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(BoxPadding.small),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).primaryColor.withOpacity(0.2),
            blurRadius: BoxPadding.xxSmall,
            spreadRadius: 0.5,
          ),
        ],
      ),
      child: ListTile(
        key: listTileKey,
        onTap: openTaskDetails,
        onLongPress: openContextMenu,
        leading:
            widget.task.complete == true ? widget.task.taskType.icon : null,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(widget.task.name),
            Text(
              widget.task.minutes != 0 ? getDuration() : '',
              style: UITextStyle.bodyLarge,
            ),
          ],
        ),
        trailing: Radio(
          value: widget.task.complete,
          groupValue: true,
          fillColor: WidgetStatePropertyAll(Theme.of(context).primaryColor),
          toggleable: true,
          onChanged: (value) {
            changeCompletionStatus(
                updatedStatus: !(widget.task.complete == true));
          },
        ),
      ),
    );
  }
}
