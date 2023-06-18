import 'package:chargames/dashboard/dashboard.dart';
import 'package:chargames/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DashboardCubit()..fetchCharacters(),
      child: const DashboardView(),
    );
  }
}

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.dashboardAppBarTitle)),
      body: BlocBuilder<DashboardCubit, List<Character>>(
        builder: (context, characterList) {
          if (characterList.isNotEmpty) {
            return SingleChildScrollView(
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
                      const DataCell(Text('Detalhar')),
                    ],
                  );
                }).toList(),
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
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
