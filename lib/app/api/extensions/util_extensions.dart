


import 'dart:ffi';

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
}
