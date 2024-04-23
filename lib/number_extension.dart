extension NumberExtensions on num? {
  bool isInRange(num min, num max) {
    if (this == null) return false;
    return this! >= min && this! <= max;
  }
}
