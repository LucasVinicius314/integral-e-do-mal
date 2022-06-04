import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:integral_e_do_mal/core/calculadora.dart';
import 'package:integral_e_do_mal/extensions/trim_decimal_part.dart';
import 'package:integral_e_do_mal/models/entry.dart';
import 'package:integral_e_do_mal/utils/breakpoints.dart';
import 'package:integral_e_do_mal/widgets/expression_text_form_field_card.dart';
import 'package:integral_e_do_mal/widgets/limit_text_form_field.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  static const route = 'main';

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  String? _result;
  bool _invalid = true;
  bool _capDecimals = true;

  final _numeratorFocusNode = FocusNode();
  final _numeratorController = TextEditingController();

  final _denominatorFocusNode = FocusNode();
  final _denominatorController = TextEditingController();

  final _upperLimitFocusNode = FocusNode();
  final _upperLimitController = TextEditingController();

  final _lowerLimitFocusNode = FocusNode();
  final _lowerLimitController = TextEditingController();

  final _examples = [
    const Entry(numerator: '2x', denominator: '(x - 1)(x - 2)(x - 4)'),
    const Entry(
      numerator: '3x',
      denominator: '(x + 1)(x + 2)',
      upperLimit: 1,
      lowerLimit: 0,
    ),
    const Entry(
      numerator: '1',
      denominator: '(x + 3)(x - 2)(x + 4)',
    ),
    const Entry(numerator: '2x', denominator: 'x² - 5x + 6'),
    const Entry(numerator: '7x', denominator: '(x + 3)(x + 2)'),
    const Entry(numerator: '3x', denominator: 'x² - 10x + 21'),
    const Entry(numerator: '1', denominator: 'x² - 4'),
  ];

  final _history = <Entry>[];

  Future<void> _copy(final String text) async {
    await Clipboard.setData(
      ClipboardData(text: text),
    );

    _showSnackBar(message: 'Resultado copiado para a área de transferência');
  }

  void _showSnackBar({required final String message}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      behavior: SnackBarBehavior.floating,
      action: SnackBarAction(
        label: 'TÁ BOM',
        onPressed: () {},
      ),
    ));
  }

  void _addToHistory(final Entry entry) {
    if (_history.length > 20) {
      _history.remove(_history.last);
    }

    _history.add(entry);

    setState(() {});
  }

  void _removeFromHistory(final Entry entry) {
    FocusScope.of(context).unfocus();

    _history.remove(entry);

    setState(() {});
  }

  void _loadEntry(final Entry entry) {
    FocusScope.of(context).unfocus();

    _numeratorController.text = entry.numerator;
    _denominatorController.text = entry.denominator;
    _upperLimitController.text = (entry.upperLimit ?? '').toString();
    _lowerLimitController.text = (entry.lowerLimit ?? '').toString();

    setState(() {
      _result = entry.result;
    });
  }

  Future<void> _calculate() async {
    FocusScope.of(context).unfocus();

    final numerator = _numeratorController.text;
    final denominator = _denominatorController.text;
    final upperLimit = int.tryParse(_upperLimitController.text);
    final lowerLimit = int.tryParse(_lowerLimitController.text);

    try {
      final res = Calculadora.calcularIntegral(
        baixo: denominator,
        cima: numerator,
        sup: upperLimit ?? 0,
        inf: lowerLimit ?? 0,
      );

      final entry = Entry(
        numerator: numerator,
        denominator: denominator,
        upperLimit: upperLimit,
        lowerLimit: lowerLimit,
        result: res,
      );

      setState(() {
        _result = res;
      });

      _addToHistory(entry);
    } catch (e) {
      await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Calma lá'),
            content: const Text('A expressão inserida é inválida.'),
            actions: [
              TextButton(
                child: const Text('TÁ BOM'),
                onPressed: () async {
                  await Navigator.of(context).maybePop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  List<SliverMultiBoxAdaptorWidget> _exampleWidgets({
    required final double viewportWidth,
  }) {
    return [
      SliverList(
        delegate: SliverChildListDelegate([
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text('Exemplos'),
                Text(
                  'Substituir o que tá ali em cima por um dos exemplos:',
                  style: Theme.of(context).textTheme.caption,
                ),
              ],
            ),
          ),
        ]),
      ),
      SliverGrid.extent(
        maxCrossAxisExtent: 180,
        childAspectRatio: viewportWidth >= Breakpoints.lg ? 2 : 1,
        children: List.generate(_examples.length, (index) {
          final example = _examples[index];

          return Padding(
            padding: const EdgeInsets.all(8),
            child: TextButton(
              child: Text(
                'Exemplo ${index + 1}',
                textAlign: TextAlign.center,
              ),
              onPressed: () {
                _loadEntry(example);
              },
            ),
          );
        }),
      ),
    ];
  }

  SliverMultiBoxAdaptorWidget _settingsWidget() {
    return SliverList(
      delegate: SliverChildListDelegate([
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('Configurações'),
              Text(
                'Mude um pouco como o app funciona.',
                style: Theme.of(context).textTheme.caption,
              ),
            ],
          ),
        ),
        SwitchListTile(
          value: _capDecimals,
          title: const Text(
            'Limitar casas decimais na resposta',
          ),
          onChanged: (value) {
            setState(() {
              _capDecimals = value;
            });
          },
        ),
        const SizedBox(height: 8),
        TextButton(
          child: const Text('LIMPAR RESULTADO'),
          onPressed: () {
            _loadEntry(const Entry(numerator: '', denominator: ''));
          },
        ),
      ]),
    );
  }

  SliverMultiBoxAdaptorWidget _historyWidget() {
    final history = _history;

    return SliverList(
      delegate: SliverChildListDelegate([
        if (history.isNotEmpty)
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text('Histórico'),
                Text(
                  'É só uma lista das últimas coisas que foram calculadas.',
                  style: Theme.of(context).textTheme.caption,
                ),
                const SizedBox(
                  height: 16,
                ),
                ...history.map((e) {
                  return ListTile(
                    title: Text(e.result ?? ''),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          tooltip: 'Pegar esse aqui de volta',
                          color: Colors.blueAccent,
                          icon: const Icon(Icons.upload),
                          onPressed: () {
                            _loadEntry(e);

                            _showSnackBar(
                              message: 'Cálculo carregado.',
                            );
                          },
                        ),
                        IconButton(
                          tooltip: 'Tirar ele daqui',
                          color: Colors.redAccent,
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            _removeFromHistory(e);

                            _showSnackBar(
                              message: 'Cálculo tirado da lista.',
                            );
                          },
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
      ]),
    );
  }

  @override
  void initState() {
    super.initState();

    void listener() {
      final numeratorText = _numeratorController.text;
      final denominatorText = _denominatorController.text;

      final invalid = numeratorText.isEmpty || denominatorText.isEmpty;

      if (invalid == _invalid) return;

      setState(() {
        _invalid = invalid;
      });
    }

    _numeratorController.addListener(listener);
    _denominatorController.addListener(listener);

    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) async {
      await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Opa bom?'),
            content: const Text('Te desejo uma boa sorte.'),
            actions: [
              TextButton(
                child: const Text('VALEU'),
                onPressed: () async {
                  await Navigator.of(context).maybePop();
                },
              ),
            ],
          );
        },
      );
    });
  }

  @override
  void dispose() {
    _numeratorController.removeListener(() {});
    _denominatorController.removeListener(() {});

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Integral é do mal')),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints.loose(
            const Size.fromWidth(Breakpoints.md),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(context)
                      .copyWith(scrollbars: false),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return CustomScrollView(
                        slivers: [
                          SliverList(
                            delegate: SliverChildListDelegate([
                              const SizedBox(height: 32),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      top: 16,
                                      left: 32,
                                      right: 32,
                                      bottom: 32,
                                    ),
                                    child: Text(
                                      '∫',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline6
                                          ?.apply(fontSizeFactor: 3),
                                    ),
                                  ),
                                  SizedBox.fromSize(
                                    size: const Size(100, 120),
                                    child: Container(
                                      color: Colors.transparent,
                                      child: Transform.translate(
                                        offset: const Offset(0, -20),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            LimitTextFormField(
                                              labelText: 'Limite superior:',
                                              focusNode: _upperLimitFocusNode,
                                              controller: _upperLimitController,
                                            ),
                                            LimitTextFormField(
                                              labelText: 'Limite inferior:',
                                              focusNode: _lowerLimitFocusNode,
                                              controller: _lowerLimitController,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        ExpressionTextFormFieldCard(
                                          hintText: 'Digite o numerador',
                                          focusNode: _numeratorFocusNode,
                                          controller: _numeratorController,
                                        ),
                                        const Divider(
                                          height: 0,
                                          endIndent: 16,
                                          indent: 16,
                                        ),
                                        ExpressionTextFormFieldCard(
                                          hintText: 'Digite o denominador',
                                          focusNode: _denominatorFocusNode,
                                          controller: _denominatorController,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Builder(
                                builder: (context) {
                                  final result = _result;

                                  if (result == null) return Container();

                                  final newResult = _capDecimals
                                      ? result.capDecimalPlaces()
                                      : result;

                                  return Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(16),
                                        child: Column(
                                          children: [
                                            Text(
                                              'Resultado',
                                              textAlign: TextAlign.center,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline6,
                                            ),
                                            Text(
                                              'Clique para copiar',
                                              textAlign: TextAlign.center,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .caption,
                                            ),
                                          ],
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () async {
                                          await _copy(newResult);
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(16),
                                          child: Text(
                                            newResult,
                                            textAlign: TextAlign.center,
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline4
                                                ?.copyWith(
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ]),
                          ),
                          _historyWidget(),
                          ..._exampleWidgets(
                            viewportWidth: MediaQuery.of(context).size.width,
                          ),
                          _settingsWidget(),
                        ],
                      );
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: ElevatedButton(
                  onPressed: _invalid ? null : _calculate,
                  child: const Text(
                    'CALCULAR',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
