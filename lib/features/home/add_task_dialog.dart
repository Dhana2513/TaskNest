import 'package:flutter/material.dart';
import 'package:recase/recase.dart';
import 'package:task_nest/core/extensions/box_padding.dart';
import 'package:task_nest/core/extensions/duration_extension.dart';
import 'package:task_nest/core/extensions/int_extension.dart';
import 'package:task_nest/core/extensions/ui_navigator.dart';
import 'package:task_nest/core/services/firestore.dart';
import 'package:task_nest/core/widgets/ui_button.dart';

import 'package:task_nest/core/widgets/ui_dialog.dart';
import 'package:task_nest/core/widgets/ui_text_field.dart';
import 'package:task_nest/shared/model/task.dart';
import 'package:task_nest/shared/type/repeat_type.dart';
import 'package:task_nest/shared/type/task_type.dart';

import '../../core/constants/constants.dart';
import '../../core/constants/text_style.dart';

class AddTaskDialog extends StatefulWidget {
  const AddTaskDialog({
    super.key,
    this.taskType,
    this.task,
  });

  final Task? task;
  final TaskType? taskType;

  @override
  State<AddTaskDialog> createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  late final TextEditingController taskNameController;
  late final TextEditingController hourController;
  late final TextEditingController minuteController;
  late final ValueNotifier<bool> loadingNotifier;
  late TaskType selectedTaskType;
  late RepeatType selectedRepeatType = RepeatType.never;

  @override
  void initState() {
    super.initState();
    taskNameController = TextEditingController(text: widget.task?.name ?? '');
    final duration = widget.task?.minutes?.minutesToDuration;

    hourController =
        TextEditingController(text: duration?.hours.toString() ?? '');

    minuteController =
        TextEditingController(text: duration?.minutes.toString() ?? '');

    loadingNotifier = ValueNotifier(false);

    selectedTaskType =
        widget.taskType ?? widget.task?.taskType ?? TaskType.other;

    selectedRepeatType = widget.task?.repeatType ?? RepeatType.never;
  }

  Widget get padding => const SizedBox(height: BoxPadding.standard);

  void showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
      message,
      style: UITextStyle.body,
    )));
  }

  void addTask() async {
    final taskName = taskNameController.text.trim();
    final hourText = hourController.text.trim();
    final minuteText = minuteController.text.trim();

    if (taskName.isEmpty) {
      showError(Constants.provideTaskName);
      return;
    }

    loadingNotifier.value = true;

    final hours = int.tryParse(hourText) ?? 0;
    final minutes = int.tryParse(minuteText) ?? 0;

    final duration = (hours * 60) + minutes;

    final task = Task(
      name: taskName,
      taskType: selectedTaskType,
      minutes: duration,
      date: DateTime.now(),
      repeatType: selectedRepeatType,
    );

    if (widget.task != null) {
      final updatedTask = widget.task!.copyWith(
        name: taskName,
        taskType: selectedTaskType,
        date: DateTime.now(),
        repeatType: selectedRepeatType,
        minutes: duration,
      );

      await Firestore.instance.update(updatedTask);
    } else {
      await Firestore.instance.addTask(task);
    }

    loadingNotifier.value = false;
    closeDialog();
  }

  void closeDialog() {
    UINavigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return UiDialog(
      title: Constants.addTask,
      body: Padding(
        padding: const EdgeInsets.all(BoxPadding.standard),
        child: Column(
          children: [
            UiTextField(
              controller: taskNameController,
              hintText: Constants.taskName,
              keyboardType: TextInputType.name,
            ),
            padding,
            Row(
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade400),
                    borderRadius: BorderRadius.circular(BoxPadding.small),
                  ),
                  child: DropdownButton<TaskType>(
                    underline: Container(),
                    hint: const Text(
                      Constants.selectTaskType,
                      style: UITextStyle.body,
                    ),
                    value: selectedTaskType,
                    items: TaskType.values
                        .map((taskType) => DropdownMenuItem<TaskType>(
                              value: taskType,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: BoxPadding.small,
                                  horizontal: BoxPadding.standard,
                                ),
                                child: Row(
                                  children: [
                                    taskType.icon,
                                    const SizedBox(width: BoxPadding.small),
                                    Text(
                                      taskType.name.titleCase,
                                      style: UITextStyle.body,
                                    ),
                                  ],
                                ),
                              ),
                            ))
                        .toList(),
                    onChanged: (selected) {
                      setState(() {
                        selectedTaskType = selected ?? TaskType.other;
                      });
                    },
                  ),
                ),
              ],
            ),
            padding,
            Row(
              children: [
                const Padding(
                  padding: EdgeInsets.all(BoxPadding.xSmall),
                  child: Text(Constants.time, style: UITextStyle.subtitle1),
                ),
                SizedBox(
                  width: BoxPadding.xxLarge + BoxPadding.xSmall,
                  child: UiTextField(
                    controller: hourController,
                    hintText: Constants.hour,
                    keyboardType: TextInputType.number,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(BoxPadding.xSmall),
                  child: Text(
                    ':',
                    style: UITextStyle.body,
                  ),
                ),
                SizedBox(
                  width: BoxPadding.xxLarge + BoxPadding.xSmall,
                  child: UiTextField(
                    controller: minuteController,
                    hintText: Constants.minutes,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            padding,
            Row(
              children: [
                const Padding(
                  padding: EdgeInsets.all(BoxPadding.xSmall),
                  child: Text(Constants.repeat, style: UITextStyle.subtitle1),
                ),
                DecoratedBox(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade400),
                    borderRadius: BorderRadius.circular(BoxPadding.small),
                  ),
                  child: DropdownButton<RepeatType>(
                    underline: Container(),
                    hint: const Text(
                      Constants.selectRepeatType,
                      style: UITextStyle.body,
                    ),
                    value: selectedRepeatType,
                    items: RepeatType.values
                        .map((repeatType) => DropdownMenuItem<RepeatType>(
                              value: repeatType,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: BoxPadding.small,
                                  horizontal: BoxPadding.standard,
                                ),
                                child: Text(
                                  repeatType.name.titleCase,
                                  style: UITextStyle.body,
                                ),
                              ),
                            ))
                        .toList(),
                    onChanged: (selected) {
                      setState(() {
                        selectedRepeatType = selected ?? RepeatType.never;
                      });
                    },
                  ),
                )
              ],
            ),
            padding,
            ValueListenableBuilder<bool>(
              valueListenable: loadingNotifier,
              builder: (BuildContext context, loading, Widget? child) {
                if (loading) {
                  return const Center(child: CircularProgressIndicator());
                }

                return SizedBox(
                  width: double.infinity,
                  child: UIButton(
                      onPressed: addTask,
                      title: widget.task?.complete == true
                          ? Constants.updateTask
                          : Constants.addTask),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
