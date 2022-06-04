class Entry {
  const Entry({
    required this.numerator,
    required this.denominator,
    this.upperLimit,
    this.lowerLimit,
    this.result,
  });

  final String numerator;
  final String denominator;
  final int? upperLimit;
  final int? lowerLimit;
  final String? result;
}
