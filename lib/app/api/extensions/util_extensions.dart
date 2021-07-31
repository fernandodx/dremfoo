


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
