import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:integral_e_do_mal/core/bhaskara.dart';
import 'package:integral_e_do_mal/core/numero.dart';
import 'package:integral_e_do_mal/extensions/trim_decimal_part.dart';

/// Classe principal da calculadora.
class Calculadora {
  /// Método princiapl do cálculo de integrais.
  static String calcularIntegral({
    required String cima,
    required String baixo,
    final int sup = 0,
    final int inf = 0,
  }) {
    cima += ' ';

    List<String> lBaixo;
    List<Numero> embaixo;

    // Verificação se o valor de baixo começa com parênteses

    if (baixo[0] != '(') {
      baixo += ' ';

      // Calcular bhaskara

      lBaixo = _extrairPalavra(baixo);

      embaixo = _inserirSegundoGrau(lBaixo);

      embaixo = _segundoGrau(embaixo);
    } else {
      lBaixo = _extrairPalavra(baixo);

      embaixo = _inserirNum(lBaixo);
    }

    var lCima = _extrairPalavra(cima);

    var encima = _inserirNum(lCima)[0];

    var abc = _calculaABC(cima: encima, baixo: embaixo);

    // Verifica se a integral possui limites

    if (sup != 0 || inf != 0) {
      final res = _calculaIntegralImpropria(
        baixos: embaixo,
        abc: abc,
        sup: sup,
        inf: inf,
      );

      return res.toString();
    } else {
      return _imprimirIntegral(baixo: embaixo, abc: abc);
    }
  }

  /// Método de concatenar o sinal ao número.
  static String _colocaSinal({required final double num}) {
    if (num > 0) {
      final out = '+ $num';

      return out;
    }

    final out = '- ${num * -1}'.trimDecimal();

    return out;
  }

  /// Método para a extração de valores a partir de uma string.
  static List<String> _extrairPalavra(final String palavras) {
    var newPalavra = '';

    var listaPalavras = <String>[];

    final newPalavras = palavras
        .replaceAll(RegExp(r' \+ '), ' ')
        .replaceAll(RegExp(r' \- '), ' -')
        .replaceAll(RegExp(r'\('), '')
        .replaceAll(RegExp(r'\)'), ' ');

    for (final palavra in newPalavras.split('')) {
      if (palavra != ' ') {
        newPalavra += palavra;

        continue;
      }

      listaPalavras.add(newPalavra);
      newPalavra = '';
    }

    return listaPalavras;
  }

  /// Método para mapear as expressões de string para [Numero].
  static List<Numero> _inserirSegundoGrau(final List<String> baixos) {
    final lista = baixos.map((baixo) {
      var numSX = 0.0;
      var numX = 0.0;

      // Verifica se a expressão possui x
      if (baixo.contains('x')) {
        // Retira ² da string
        baixo = baixo.replaceAll(RegExp(r'²'), '');

        if (baixo == 'x') {
          numX = 1;
        } else {
          // Retira x da string
          baixo = baixo.replaceAll(RegExp(r'x'), '');

          numX = double.tryParse(baixo) ?? 0;
        }
      } else {
        numX = 0;
        numSX = double.tryParse(baixo) ?? 0;
      }

      return Numero(numSX: numSX, numX: numX);
    });

    return lista.toList();
  }

  /// Método para calcular funções de segundo grau.
  static List<Numero> _segundoGrau(final List<Numero> baixos) {
    final respostas = <Numero>[];

    if (baixos.length == 3) {
      // Só calcula se tiver 3 elementos na lista

      // Calcular só com 2
      final bhaskara = _calculaBhaskara(baixos);

      respostas.add(bhaskara.primeiro);
      respostas.add(bhaskara.segundo);
    } else if (baixos.length == 2) {
      // Calcular função incompleta
      final segundoIncompleta = _segundoIncompleta(baixos);

      respostas.add(segundoIncompleta.primeiro);
      respostas.add(segundoIncompleta.segundo);
    }

    return respostas;
  }

  /// Método para calcular funcão de segundo grau utilizando bhaskara.
  static Bhaskara _calculaBhaskara(final List<Numero> baixos) {
    final first = baixos.first;
    final second = baixos[1];
    final third = baixos[2];

    // Cálculo de delta
    var delta = math.pow(second.numX, 2) - 4 * first.numX * third.numSX;
    var bhaskaraPositivo =
        (-1 * second.numX + math.sqrt(delta)) / 2 * first.numX;
    var bhaskaraNegativo =
        (-1 * second.numX - math.sqrt(delta)) / 2 * first.numX;

    final primeiroNumX = first.numX;
    final segundoNumX = first.numX;

    final primeiroNumSX = bhaskaraPositivo * -1 * first.numX;
    final segundoNumSX = bhaskaraNegativo * -1 * first.numX;

    var primeiro = Numero(numSX: primeiroNumSX, numX: primeiroNumX);
    var segundo = Numero(numSX: segundoNumSX, numX: segundoNumX);

    return Bhaskara(primeiro: primeiro, segundo: segundo);
  }

  /// Método para calcular funções de segundo grau incompletas.
  static Bhaskara _segundoIncompleta(final List<Numero> baixos) {
    final first = baixos.first;
    final second = baixos[1];

    final primeiro = Numero(numSX: 0, numX: first.numX);
    final segundo = Numero(numSX: 0, numX: first.numX);

    if (second.numSX < 0) {
      second.numSX *= -1;

      primeiro.numSX = math.sqrt(second.numSX);
      segundo.numSX = primeiro.numSX * -1;
    } else {
      primeiro.numX = math.sqrt(second.numX);
      segundo.numSX = primeiro.numSX;
    }

    return Bhaskara(primeiro: primeiro, segundo: segundo);
  }

  /// Método para tratar e converter as expressões em uma lista [Numero].
  static List<Numero> _inserirNum(final List<String> baixos) {
    // Lista de números a serem retornados
    final lista = <Numero>[];

    for (int i = 0; i < baixos.length; i += 1) {
      final num = Numero(numSX: 0, numX: 0);

      // Verifica se a string contém x
      if (baixos[i].contains('x')) {
        // Retira ² da string
        baixos[i] = baixos[i].replaceAll(RegExp(r'²'), '');

        if (baixos[i] == 'x') {
          num.numX = 1;
        } else {
          // Retira x da string
          baixos[i] = baixos[i].replaceAll('x', '');
          num.numX = double.tryParse(baixos[i]) ?? 0;
        }
        if (baixos.length != 1) {
          num.numSX = double.tryParse(baixos[i + 1]) ?? 0;
          i++;
        }
      } else {
        num.numX = 0;
        num.numSX = double.tryParse(baixos[i]) ?? 0;
      }

      // Adiciona o número à lista
      lista.add(num);
    }

    return lista;
  }

  /// Método para calcular o valor de integrais definidas.
  static double _calculaIntegralImpropria({
    required final List<Numero> baixos,
    required final List<double> abc,
    required int sup,
    required int inf,
  }) {
    var soma = 0.0;

    /// Percorrer os valores multiplicando e somando
    for (int i = 0; i < baixos.length; i++) {
      final numX = baixos[i].numX;
      final numSX = baixos[i].numSX;

      final plus = (sup + numSX).toDouble();
      final minus = (inf + numSX).toDouble();

      final temp = abc[i];

      soma += temp * math.log(numX * plus);

      soma -= temp * math.log(numX * minus);
    }

    return soma;
  }

  /// Método para calcular a integral com a fórmula de calcular utilizando A, B e C.
  static List<double> _calculaABC({
    required final Numero cima,
    required final List<Numero> baixo,
  }) {
    final respostas = <double>[];

    // Percorre a lista dividindo e calculando os resultados
    for (int i = 0; i < baixo.length; i++) {
      var numAtual = -1 * baixo[i].numSX / baixo[i].numX;
      var soma = 0.0;

      for (int j = 0; j < baixo.length; j++) {
        if (i != j) {
          soma += baixo[j].numX * numAtual + baixo[j].numSX;
        }
      }

      final calculo = (cima.numSX + cima.numX * numAtual) / soma;

      respostas.add(calculo);
    }

    return respostas;
  }

  /// Método para transformar a integral em string.
  static String _imprimirIntegral({
    required final List<Numero> baixo,
    required final List<double> abc,
  }) {
    var numX = '';
    var imprimirTudo = '';

    // Percorre a lista formatando os números e concatenando à saída
    for (int i = 0; i < baixo.length; i++) {
      if (baixo[i].numX == 1) {
        numX = 'x';
      } else {
        numX = '${baixo[i].numX}x';
      }

      final preLn = _colocaSinal(num: abc[i]).trimDecimal();
      final newNumX = numX.toString().trimDecimal();
      final postNumX = _colocaSinal(num: baixo[i].numSX).trimDecimal();

      final out = '${preLn}ln($newNumX $postNumX) ';

      imprimirTudo += out;
    }

    final res = '$imprimirTudo+ C';

    if (kDebugMode) {
      print(res);
    }

    return res;
  }
}
