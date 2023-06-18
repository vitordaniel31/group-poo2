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
            return ListView.builder(
              itemCount: characterList.length,
              itemBuilder: (context, index) {
                final character = characterList[index];
                return ListTile(
                  leading: Image.network(
                    'https://ddragon.leagueoflegends.com/cdn/img/champion/loading/${character.id}_0.jpg',
                    width: 150,
                    height: 150,
                  ),
                  title: Text(character.name),
                  subtitle: Text(character.title),
                  trailing: Text(character.blurb.length > 200
                      ? '${character.blurb.substring(0, 200)}...'
                      : character.blurb),
                );
              },
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
