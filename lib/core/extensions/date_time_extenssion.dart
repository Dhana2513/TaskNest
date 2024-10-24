extension DateTimeX on DateTime {
  int get weekOfYear {
    final firstDayOfYear = DateTime(year, 1, 1);
    final firstDayOfNextYear = DateTime(year + 1, 1, 1);
    final daysSinceFirstDayOfYear = difference(firstDayOfYear).inDays;
    final daysSinceFirstDayOfNextYear = difference(firstDayOfNextYear).inDays;
    final weekOfYear =
        (daysSinceFirstDayOfYear + daysSinceFirstDayOfNextYear) / 7;
    return weekOfYear.round();
  }
}
