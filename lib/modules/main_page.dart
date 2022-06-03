import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  static const route = 'main';

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  String? _result;
  bool _invalid = true;

  final _numeratorFocusNode = FocusNode();
  final _numeratorController = TextEditingController();

  final _denominatorFocusNode = FocusNode();
  final _denominatorController = TextEditingController();

  Future<void> _calculate() async {
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
                                        TextFormField(
                                          textAlign: TextAlign.end,
                                          decoration: InputDecoration(
                                            isDense: true,
                                            alignLabelWithHint: true,
                                            labelText: 'Limite superior:',
                                            labelStyle: Theme.of(context)
                                                .textTheme
                                                .caption,
                                          ),
                                        ),
                                        TextFormField(
                                          textAlign: TextAlign.end,
                                          decoration: InputDecoration(
                                            isDense: true,
                                            alignLabelWithHint: true,
                                            labelText: 'Limite inferior:',
                                            labelStyle: Theme.of(context)
                                                .textTheme
                                                .caption,
                                          ),
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
                                    Card(
                                      clipBehavior: Clip.antiAlias,
                                      margin: const EdgeInsets.all(16),
                                      child: TextFormField(
                                        focusNode: _numeratorFocusNode,
                                        controller: _numeratorController,
                                        decoration: const InputDecoration(
                                          contentPadding: EdgeInsets.all(8),
                                          // TODO: fix
                                          hintText: 'Digite o numerador',
                                        ),
                                      ),
                                    ),
                                    const Divider(
                                      height: 0,
                                      endIndent: 16,
                                      indent: 16,
                                    ),
                                    Card(
                                      clipBehavior: Clip.antiAlias,
                                      margin: const EdgeInsets.all(16),
                                      child: TextFormField(
                                        focusNode: _denominatorFocusNode,
                                        controller: _denominatorController,
                                        decoration: const InputDecoration(
                                          contentPadding: EdgeInsets.all(8),
                                          // TODO: fix
                                          hintText: 'Digite o denominador',
                                        ),
                                      ),
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
