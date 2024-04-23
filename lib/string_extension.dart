extension StringExtensions on String? {
  bool get isNullOrEmpty =>
      (this == null || RegExp(r'^\s*$').hasMatch(this!)) ? true : false;
}
