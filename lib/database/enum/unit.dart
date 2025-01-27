import 'package:maven/common/common.dart';

enum Unit {
  metric,
  imperial;

  String get name {
    return toString().split('.').last.capitalize;
  }
}