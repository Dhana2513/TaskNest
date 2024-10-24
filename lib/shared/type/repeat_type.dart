enum RepeatType {
  daily,
  weekly,
  monthly,
  never,
}

extension RepeatTypeX on RepeatType {
  static RepeatType fromString(String value) {
    switch (value.toLowerCase()) {
      case 'daily':
        return RepeatType.daily;
      case 'weekly':
        return RepeatType.weekly;
      case 'monthly':
        return RepeatType.monthly;
      default:
        return RepeatType.never;
    }
  }
}
