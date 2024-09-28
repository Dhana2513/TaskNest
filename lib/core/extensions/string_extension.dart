import 'package:recase/recase.dart';

extension StringX on String {
  String get titleCase => ReCase(this).titleCase;

  String get sentenceCase => ReCase(this).sentenceCase;
}
