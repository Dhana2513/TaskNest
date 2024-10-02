extension IntX on int {
  Duration get minutesToDuration {
    final hours = this != 0 ? (this / 60).truncate() : 0;
    final remainingMinutes = this != 0 ? this % 60 : 0;
    return Duration(hours: hours, minutes: remainingMinutes);
  }
}
