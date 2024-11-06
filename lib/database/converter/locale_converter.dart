import 'package:floor/floor.dart';
import 'package:flutter/material.dart';

class LocaleConverter extends TypeConverter<Locale, String> {
  @override
  Locale decode(String databaseValue) {
    return const Locale.fromSubtags(
      languageCode: "en",
      countryCode: "us",
    );
  }

  @override
  String encode(Locale value) {
    return value.toString();
  }
}
