import 'package:integral_e_do_mal/core/calculadora.dart';
import 'package:test/test.dart';

void main() {
  // CaucularIntegral("2x", "(x - 1)(x - 2)(x - 4)"); // - 0.5ln(x - 1) - 4ln(x - 2) + 1.6ln(x - 4) + C
  test('1st', () {
    final res = Calculadora.calcularIntegral(
      cima: '2x',
      baixo: '(x - 1)(x - 2)(x - 4)',
    );

    expect(
      res,
      '- 0.5ln(x - 1) - 4ln(x - 2) + 1.6ln(x - 4) + C',
    );
  });

  // CaucularIntegral("3x", "(x + 1)(x + 2)", 1, 0); // 0.35334910696915056
  test('2nd', () {
    final res = Calculadora.calcularIntegral(
      cima: '3x',
      baixo: '(x + 1)(x + 2)',
      sup: 1,
      inf: 0,
    );

    expect(
      res,
      '0.35334910696915056',
    );
  });

  // CaucularIntegral("1", "(x + 3)(x - 2)(x + 4)"); // - 0.25ln(x + 3) + 0.09090909090909091ln(x - 2) - 0.14285714285714285ln(x + 4) + C
  test('3rd', () {
    final res = Calculadora.calcularIntegral(
      cima: '1',
      baixo: '(x + 3)(x - 2)(x + 4)',
    );

    expect(
      res,
      '- 0.25ln(x + 3) + 0.09090909090909091ln(x - 2) - 0.14285714285714285ln(x + 4) + C',
    );
  });

  // CaucularIntegral("2x", "x² - 5x + 6"); // + 6ln(x - 3) - 4ln(x - 2) + C
  test('4th', () {
    final res = Calculadora.calcularIntegral(
      cima: '2x',
      baixo: 'x² - 5x + 6',
    );

    expect(
      res,
      '+ 6ln(x - 3) - 4ln(x - 2) + C',
    );
  });

  // CaucularIntegral("7x", "(x + 3)(x + 2)"); // + 21ln(x + 3) - 14ln(x + 2) + C
  test('5th', () {
    final res = Calculadora.calcularIntegral(
      cima: '7x',
      baixo: '(x + 3)(x + 2)',
    );

    expect(
      res,
      '+ 21ln(x + 3) - 14ln(x + 2) + C',
    );
  });

  // CaucularIntegral("3x", "x² - 10x + 21"); // + 5.25ln(x - 7) - 2.25ln(x - 3) + C
  test('6th', () {
    final res = Calculadora.calcularIntegral(
      cima: '3x',
      baixo: 'x² - 10x + 21',
    );

    expect(
      res,
      '+ 5.25ln(x - 7) - 2.25ln(x - 3) + C',
    );
  });

// CaucularIntegral("1", "x² - 4"); // - 0.25ln(x + 2) + 0.25ln(x - 2) + C
  test('7th', () {
    final res = Calculadora.calcularIntegral(
      cima: '1',
      baixo: 'x² - 4',
    );

    expect(
      res,
      '- 0.25ln(x + 2) + 0.25ln(x - 2) + C',
    );
  });
}
