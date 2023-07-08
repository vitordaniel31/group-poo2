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
  const DetailView({Key? key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.detailAppBarTitle)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              BlocBuilder<DetailCubit, Character>(
                builder: (context, character) {
                  character =
                      context.select((DetailCubit cubit) => cubit.state);
                  if (character.id != 0) {
                    return SingleChildScrollView(
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              const SizedBox(height: 8),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Image.network(
                                  character.image,
                                  width: 150,
                                  height: 150,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                character.name,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Roboto',
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                character.description,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'Roboto',
                                ),
                              ),
                              const SizedBox(height: 8),
                            ],
                          ),
                        ),
                      ),
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ],
          ),
        ),
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
