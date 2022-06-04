import 'package:integral_e_do_mal/extensions/trim_decimal_part.dart';
import 'package:test/test.dart';

void main() {
  test('1st', () {
    final res = '3'.capDecimalPlaces();

    expect(res, '3');
  });

  test('2nd', () {
    final res = '.34354345'.capDecimalPlaces();

    expect(res, '.3435');
  });

  test('3nd', () {
    final res = '+ 6ln'.capDecimalPlaces();

    expect(res, '+ 6ln');
  });
}
