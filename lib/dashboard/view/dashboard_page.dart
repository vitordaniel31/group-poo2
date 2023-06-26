import 'package:chargames/dashboard/dashboard.dart';
import 'package:chargames/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DashboardCubit()..fetchCharacters(''),
      child: const DashboardView(),
    );
  }
}

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    var currentSearch = '';

    return Scaffold(
      appBar: AppBar(title: Text(l10n.dashboardAppBarTitle)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              onChanged: (search) {
                currentSearch = search;
                context.read<DashboardCubit>().filterCharacters(search);
              },
              decoration: const InputDecoration(
                labelText: 'Pesquise por nome ou ID',
              ),
            ),
          ),
          Expanded(
            child: BlocBuilder<DashboardCubit, List<Character>>(
              builder: (context, characterList) {
                if (characterList.isNotEmpty) {
                  return NotificationListener<ScrollNotification>(
                    onNotification: (scrollNotification) {
                      if (scrollNotification is ScrollEndNotification &&
                          scrollNotification.metrics.extentAfter == 0) {
                        context
                            .read<DashboardCubit>()
                            .loadMoreCharacters(currentSearch);
                      }
                      return false;
                    },
                    child: SingleChildScrollView(
                      child: DataTable(
                        dataRowMaxHeight: 100,
                        columns: const [
                          DataColumn(label: Text('Nome')),
                          DataColumn(label: Text('Imagem')),
                          DataColumn(label: Text('Ações')),
                        ],
                        rows: characterList.map((character) {
                          return DataRow(
                            cells: [
                              DataCell(Text(character.name)),
                              DataCell(
                                Image.network(
                                  character.image,
                                  height: 80,
                                ),
                              ),
                              DataCell(
                                TextButton(
                                  onPressed: () {
                                    Navigator.pushNamed(
                                      context,
                                      '/detail',
                                      arguments: {'id': character.id},
                                    );
                                  },
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.blue),
                                    foregroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.white),
                                  ),
                                  child: const Text('Detalhar'),
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class DashboardText extends StatelessWidget {
  const DashboardText({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final count = context.select((DashboardCubit cubit) => cubit.state);
    return Text('$count', style: theme.textTheme.displayLarge);
  }
}
