extension TrimDecimalPart on String {
  String trimDecimal() {
    return replaceFirst(RegExp(r'.0+$'), '');
  }
}
