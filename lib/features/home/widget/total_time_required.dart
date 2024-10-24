import 'package:flutter/material.dart';
import 'package:task_nest/core/constants/text_style.dart';
import 'package:task_nest/core/extensions/box_padding.dart';
import 'package:task_nest/core/extensions/duration_extension.dart';
import 'package:task_nest/core/extensions/int_extension.dart';

import '../../../shared/model/task.dart';

class TotalTimeRequired extends StatelessWidget {
  const TotalTimeRequired({super.key, required this.tasks});

  final List<Task> tasks;

  Duration? calculateTotalTime() {
    int totalTime = 0;
    for (final task in tasks) {
      totalTime +=
          (task.minutes == 0 || task.minutes == null) ? 15 : task.minutes!;
    }

    return totalTime == 0 ? null : totalTime.minutesToDuration;
  }

  @override
  Widget build(BuildContext context) {
    final duration = calculateTotalTime();
    if (duration == null) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: BoxPadding.xxSmall,
        vertical: BoxPadding.standard,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(BoxPadding.small),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).primaryColor.withOpacity(0.2),
            blurRadius: BoxPadding.xxSmall,
            spreadRadius: BoxPadding.xxSmall,
          ),
        ],
      ),
      padding: const EdgeInsets.all(BoxPadding.standard),
      child: Text(
        'Total required time ${duration.toStringTime} hrs',
        style: UITextStyle.subtitle1.copyWith(
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }
}
