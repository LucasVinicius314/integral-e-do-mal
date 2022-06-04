import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:integral_e_do_mal/core/bhaskara.dart';
import 'package:integral_e_do_mal/core/numero.dart';
import 'package:integral_e_do_mal/extensions/trim_decimal_part.dart';

class Calculadora {
  static String calcularIntegral({
    required String cima,
    required String baixo,
    final int sup = 0,
    final int inf = 0,
  }) {
    cima += ' ';

    List<String> lbaixo;
    List<Numero> embaixo;

    if (baixo[0] != '(') {
      baixo += ' ';

      // Calcular bhaskara
      lbaixo = _extrairPalavra(baixo);

      embaixo = _inserirSegundoGrau(lbaixo);

      embaixo = _segundoGrau(embaixo);
    } else {
      lbaixo = _extrairPalavra(baixo);

      embaixo = _inserirNum(lbaixo);
    }

    var lcima = _extrairPalavra(cima);

    var emcima = _inserirNum(lcima)[0];

    var abc = _calculaABC(cima: emcima, baixo: embaixo);

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

  static String _colocaSinal({required final double num}) {
    if (num > 0) {
      final out = '+ $num';

      return out;
    }

    final out = '- ${num * -1}'.trimDecimal();

    return out;
  }

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

  static List<Numero> _inserirSegundoGrau(final List<String> baixos) {
    final lista = baixos.map((baixo) {
      var numSX = 0.0;
      var numX = 0.0;

      if (baixo.contains('x')) {
        baixo = baixo.replaceAll(RegExp(r'²'), '');

        if (baixo == 'x') {
          numX = 1;
        } else {
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

  static List<Numero> _segundoGrau(final List<Numero> baixos) {
    final respostas = <Numero>[];

    // Só calcula se tiver 3 cara
    // Fazer com só 2
    if (baixos.length == 3) {
      final bhaskara = _calculaBhaskara(baixos);

      respostas.add(bhaskara.primeiro);
      respostas.add(bhaskara.segundo);
    } else if (baixos.length == 2) {
      final segundoIncompleta = _segundoIncompleta(baixos);

      respostas.add(segundoIncompleta.primeiro);
      respostas.add(segundoIncompleta.segundo);
    }

    return respostas;
  }

  static Bhaskara _calculaBhaskara(final List<Numero> baixos) {
    final first = baixos.first;
    final second = baixos[1];
    final third = baixos[2];

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

  static List<Numero> _inserirNum(final List<String> baixos) {
    final lista = <Numero>[];

    for (int i = 0; i < baixos.length; i += 1) {
      final num = Numero(numSX: 0, numX: 0);

      if (baixos[i].contains('x')) {
        baixos[i] = baixos[i].replaceAll(RegExp(r'²'), '');

        if (baixos[i] == 'x') {
          num.numX = 1;
        } else {
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

      lista.add(num);
    }

    return lista;
  }

  static double _calculaIntegralImpropria({
    required final List<Numero> baixos,
    required final List<double> abc,
    required int sup,
    required int inf,
  }) {
    var soma = 0.0;

    for (int i = 0; i < baixos.length; i++) {
      final numX = baixos[i].numX;
      final numSX = baixos[i].numSX;

      final plus = (sup + numSX).toDouble();
      final minus = (inf + numSX).toDouble();

      final t = abc[i];

      soma += t * math.log(numX * plus);

      soma -= t * math.log(numX * minus);
    }

    return soma;
  }

  static List<double> _calculaABC({
    required final Numero cima,
    required final List<Numero> baixo,
  }) {
    final respostas = <double>[];

    for (int i = 0; i < baixo.length; i++) {
      var numatual = -1 * baixo[i].numSX / baixo[i].numX;
      var soma = 0.0;

      for (int j = 0; j < baixo.length; j++) {
        if (i != j) {
          soma += baixo[j].numX * numatual + baixo[j].numSX;
        }
      }

      final calculo = (cima.numSX + cima.numX * numatual) / soma;

      respostas.add(calculo);
    }

    return respostas;
  }

  static String _imprimirIntegral({
    required final List<Numero> baixo,
    required final List<double> abc,
  }) {
    var numX = "";
    var imprimirTudo = "";

    for (int i = 0; i < baixo.length; i++) {
      if (baixo[i].numX == 1) {
        numX = "x";
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
