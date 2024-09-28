extension MapX on Map {
  String stringForKey(String key, {String defaultTo = ''}) {
    if (containsKey(key)) {
      return this[key];
    }
    return defaultTo;
  }

  int intForKey(String key, {int defaultTo = 0}) {
    if (containsKey(key)) {
      return this[key];
    }

    return defaultTo;
  }

  bool boolForKey(String key, {bool defaultTo = false}) {
    if (containsKey(key)) {
      return this[key];
    }

    return defaultTo;
  }

  List<Map<String, dynamic>> listForKey(String key) {
    if (containsKey(key)) {
      return this[key];
    }

    return [];
  }
}
