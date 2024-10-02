extension DurationX on Duration {
  int get hours {
    return (inMinutes / 60).truncate();
  }

  int get minutes {
    return inMinutes % 60;
  }
}
