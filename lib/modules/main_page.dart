import 'package:flutter/material.dart';
import 'package:math_parser/math_parser.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  static const route = 'main';

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  String? _result;
  bool _invalid = true;

  final _focusNode = FocusNode();
  final _controller = TextEditingController();

  Future<void> _calculate() async {
    try {
      final text = _controller.text;

      final expression = MathNodeExpression.fromString(text);

      final res = expression.calc(MathVariableValues.none);

      setState(() {
        _result = res.toString();
      });
    } on CantProcessExpressionException {
      await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            // TODO: fix
            title: const Text('Calma lá'),
            content: const Text('A expressão inserida é inválida.'),
            actions: [
              TextButton(
                child: const Text('BELEZA'),
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

  @override
  void initState() {
    super.initState();

    _controller.addListener(() {
      final text = _controller.text;

      final invalid = text.isEmpty;

      if (invalid == _invalid) return;

      setState(() {
        _invalid = invalid;
      });
    });
  }

  @override
  void dispose() {
    _controller.removeListener(() {});

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // TODO: fix
      appBar: AppBar(title: const Text('Integral é do mal')),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints.loose(const Size.fromWidth(720)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: CustomScrollView(
                  slivers: [
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Card(
                            clipBehavior: Clip.antiAlias,
                            margin: const EdgeInsets.all(16),
                            child: TextFormField(
                              focusNode: _focusNode,
                              controller: _controller,
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.all(8),
                                // TODO: fix
                                hintText: 'Digite algo para ser calculado',
                              ),
                            ),
                          ),
                          Builder(
                            builder: (context) {
                              final result = _result;

                              if (result == null) return Container();

                              return Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Text(
                                      // TODO: fix
                                      'Resultado',
                                      textAlign: TextAlign.center,
                                      style:
                                          Theme.of(context).textTheme.headline6,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Text(
                                      result,
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline4
                                          ?.copyWith(
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: ElevatedButton(
                  onPressed: _invalid ? null : _calculate,
                  child: const Text(
                    // TODO: fix
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
