import 'package:chargames/dashboard/cubit/dashboard_cubit.dart';
import 'package:chargames/detail/detail.dart';
import 'package:chargames/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DetailPage extends StatelessWidget {
  const DetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    var id = 0;
    if (args is Map<String, dynamic>) {
      id = args['id'] as int;
    }

    return BlocProvider(
      create: (_) => DetailCubit(id: id)..fetchCharacter(),
      child: const DetailView(),
    );
  }
}

class DetailView extends StatelessWidget {
  const DetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.detailAppBarTitle)),
      body: BlocBuilder<DetailCubit, Character>(
        builder: (context, character) {
          character = context.select((DetailCubit cubit) => cubit.state);
          if (character.id != 0) {
            return ListView(
                    children: [
                       Image.network(
                          character.href,
                          height: 500,
                        ),

                      Text('Name: ${character.name}'),
                      Text('Release Date: ${character.criacao}'),
                      Text('Typo: ${character.type}'),
                      Text('Fields: ${character.fields}'),

                      Row(
                        children: [
                          Text('Level: '),
                          for (var level in character.levels)
                          Text(level['level'] as String),
                        ],
                      ),

                      Row(
                        children: [
                          Text('Attributes: '),
                          for (var att in character.atributos)
                            Text(att['attribute'] as String),
                        ],
                      ),

                      Text('Description: ${character.descricao}'),

                      DataTable(
                        columns: const [
                          DataColumn(label: Text('Name')),
                          DataColumn(label: Text('Name Inglish')),
                          DataColumn(label: Text('Description')),
                        ],
                        rows: [
                          for (var skill in character.skills)
                          DataRow(cells: [
                            DataCell(Text(skill['skill'] as String),),
                            DataCell(Text(skill['translation'] as String),),
                            DataCell(Text(skill['description'] as String),),
                            ],),
                        ],
                      ),

                      DataTable(
                        columns: const [
                          DataColumn(label: Text('Name')),
                          DataColumn(label: Text('Condition')),
                          DataColumn(label: Text('Image')),
                          DataColumn(label: Text('Ver')),
                        ],
                        rows: [
                          for (var prior in character.priorEvolutions)
                            DataRow(
                              cells: [
                                DataCell(
                                  Text(prior['digimon'] as String),
                                ),
                                DataCell(
                                  Text(prior['condition'] as String),
                                ),
                                DataCell(
                                  Image.network(
                                  prior['image'] as String,
                                  height: 80,
                                ),
                                ),
                                DataCell(
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pushNamed(
                                        context,
                                        '/detail',
                                        arguments: {'id': prior['id'] as int},
                                      );
                                    },
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(Colors.blue),
                                      foregroundColor: MaterialStateProperty.all<Color>(
                                          Colors.white),
                                    ),
                                    child: const Text('Ver'),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        DataTable(
                          columns: const [
                            DataColumn(label: Text('Name')),
                            DataColumn(label: Text('Condition')),
                            DataColumn(label: Text('Image')),
                            DataColumn(label: Text('Ver')),
                          ],
                          rows: [
                            for (var next in character.nextEvolutions)
                              DataRow(
                                cells: [
                                  DataCell(
                                    Text(next['digimon'] as String),
                                  ),
                                  DataCell(
                                    Text(next['condition'] as String),
                                  ),
                                  DataCell(
                                    Image.network(
                                      next['image'] as String,
                                      height: 80,
                                    ),
                                  ),
                                  DataCell(
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pushNamed(
                                          context,
                                          '/detail',
                                          arguments: {'id': next['id'] as int},
                                        );
                                      },
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(Colors.blue),
                                        foregroundColor: MaterialStateProperty.all<Color>(
                                            Colors.white),
                                      ),
                                      child: const Text('Ver'),
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),

                    ]
                  );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

class DetailText extends StatelessWidget {
  const DetailText({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final count = context.select((DetailCubit cubit) => cubit.state);
    return Text('$count', style: theme.textTheme.displayLarge);
  }
}
