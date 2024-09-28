import 'package:flutter/material.dart';

enum TaskType {
  work,
  home,
  study,
  skills,
  legal,
  other,
}

extension TaskTypeX on TaskType {
  static List<TaskType> taskCategories = [
    TaskType.work,
    TaskType.study,
    TaskType.home,
    TaskType.skills,
    TaskType.legal,
    TaskType.other,
  ];

  static TaskType fromString(String value) {
    switch (value.toLowerCase()) {
      case 'work':
        return TaskType.work;
      case 'study':
        return TaskType.study;
      case 'skills':
        return TaskType.skills;
      case 'home':
        return TaskType.home;
      case 'legal':
        return TaskType.legal;
      default:
        return TaskType.other;
    }
  }

  IconData get iconData {
    switch (this) {
      case TaskType.work:
        return Icons.work_outline;
      case TaskType.study:
        return Icons.book_outlined;
      case TaskType.skills:
        return Icons.crisis_alert_outlined;
      case TaskType.home:
        return Icons.house_outlined;
      case TaskType.legal:
        return Icons.maps_home_work_outlined;
      default:
        return Icons.task_alt_outlined;
    }
  }

  Icon get icon {
    return Icon(
      iconData,
      size: this == TaskType.home ? 28 : 24,
      color: Colors.red,
    );
  }
}