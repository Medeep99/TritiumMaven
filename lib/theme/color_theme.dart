import 'package:flutter/material.dart';

class ColorTheme {
  ColorTheme({
    required this.primary,
    required this.secondary,
    required this.background,
    required this.text,
    required this.subtext,
    required this.neutral,
    required this.success,
    required this.error,
    required this.shadow,
    required this.warmup,
    required this.drop,
    required this.cooldown,
  });

  final Color primary;
  final Color secondary;
  final Color background;
  final Color text;
  final Color subtext;
  final Color neutral;
  final Color success;
  final Color error;
  final Color shadow;
  final Color warmup;
  final Color drop;
  final Color cooldown;
}