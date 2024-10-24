extension DurationX on Duration {
  int get hours {
    return (inMinutes / 60).truncate();
  }

  int get minutes {
    return inMinutes % 60;
  }

  String get toStringTime {
    return '${hours.toString().padLeft(2, '0')}:'
        '${minutes.toString().padLeft(2, '0')}';
  }
}
