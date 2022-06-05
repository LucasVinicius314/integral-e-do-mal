/// Extensão de utilidades em strings.
extension TrimDecimalPart on String {
  String trimDecimal() {
    return replaceFirst(RegExp(r'.0+$'), '');
  }

  String capDecimalPlaces() {
    return replaceAllMapped(RegExp(r'\.(\d+)', dotAll: true), (match) {
      final text = (match.group(1) ?? '');

      if (text.length <= 4) {
        return '.$text';
      }

      return '.${text.substring(0, 4)}';
    });
  }
}
