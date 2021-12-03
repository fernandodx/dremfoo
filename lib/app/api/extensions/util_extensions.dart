


import 'dart:ffi';

import 'package:date_format/date_format.dart';
import 'package:dremfoo/app/resources/PortuguesLocale.dart';

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
  }
}

extension CapExtension on String {
  String get inCaps => '${this[0].toUpperCase()}${this.substring(1)}';
  String get allInCaps => this.toUpperCase();
  String get capitalizeFirstOfEach => this.split(" ").map((str) => str.capitalize()).join(" ");
  String get orEmpty => this.isNotEmpty ? this : "";

  String truncate({ length: 7, omission: '...' }) {
    if (length >= this.length) {
      return this;
    }
    return this.replaceRange(length, this.length, omission);
  }

}

extension PercentExtensions on double {
  String get toIntPercent {
    if(this.isNaN || this.isInfinite) return "0%";
    return "${(this*100).toInt()}%";
  }
  String get formatIntPercent {
    if(this.isNaN || this.isInfinite) return "0%";
    return "${(this).toInt()}%";
  }
}

extension DateOnlyCompare on DateTime {
  bool isSameDate(DateTime other) {
    return this.year == other.year && this.month == other.month
        && this.day == other.day;
  }

  String format() {
    return formatDate(this, [dd, '/', mm, '/', yyyy], locale: PortuguesLocale());
  }

  String formatExtension() {
    return formatDate(this, [dd, ' de ', MM, ' de ', yyyy], locale: PortuguesLocale());
  }

}
