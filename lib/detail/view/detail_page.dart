import 'package:carousel_slider/carousel_slider.dart';
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

DataRow buildDataRow(String label, String value) {
  return DataRow(
    cells: [
      DataCell(
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      DataCell(
        Text(value),
      ),
    ],
  );
}

class DetailView extends StatelessWidget {
  const DetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.detailAppBarTitle)),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                BlocBuilder<DetailCubit, Character>(
                  builder: (context, character) {
                    character =
                        context.select((DetailCubit cubit) => cubit.state);
                    if (character.id != 0) {
                      return Card(
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
                              DataTable(
                                columns: const [
                                  DataColumn(label: Text('')),
                                  DataColumn(label: Text('')),
                                ],
                                rows: [
                                  buildDataRow(
                                      'Release Date:', character.releaseDate),
                                  buildDataRow('Type:', character.type),
                                  buildDataRow('Fields:', character.fields),
                                ],
                                dataRowColor:
                                    MaterialStateColor.resolveWith((states) {
                                  if (states.contains(MaterialState.selected)) {
                                    return Colors.grey.withOpacity(
                                        0.5); // Cor de fundo quando selecionada
                                  }
                                  return Colors
                                      .transparent; // Cor de fundo padrão
                                }),
                                dataTextStyle: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 14.0,
                                ),
                              ),
                              const SizedBox(height: 25),
                              const ColoredBox(
                                color: Color.fromARGB(255, 9, 50,
                                    185), // Defina a cor de fundo desejada aqui
                                child: Text(
                                  'Prior Evolutions',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Color.fromARGB(255, 255, 255, 255),
                                  ),
                                ),
                              ),
                              CarouselSlider(
                                options: CarouselOptions(
                                  height: 500,
                                ),
                                items: character.priorEvolutions.map((i) {
                                  return Builder(
                                    builder: (BuildContext context) {
                                      return Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        margin: const EdgeInsets.symmetric(
                                          horizontal: 5,
                                        ),
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: NetworkImage(
                                                i['image'] as String),
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                        child: Stack(
                                          children: [
                                            Align(
                                              alignment: Alignment.bottomCenter,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                  bottom: 16,
                                                ),
                                                child: TextButton(
                                                  onPressed: () {
                                                    Navigator.pushNamed(
                                                      context,
                                                      '/detail',
                                                      arguments: {
                                                        'id': i['id'] as int
                                                      },
                                                    );
                                                  },
                                                  style: ButtonStyle(
                                                    backgroundColor:
                                                        MaterialStateProperty
                                                            .all<Color>(
                                                      Colors.blue,
                                                    ),
                                                    foregroundColor:
                                                        MaterialStateProperty
                                                            .all<Color>(
                                                      Colors.white,
                                                    ),
                                                  ),
                                                  child: Text(
                                                    i['digimon'] as String,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                }).toList(),
                              ),
                              const ColoredBox(
                                color: Color.fromARGB(
                                  255,
                                  6,
                                  136,
                                  75,
                                ), // Defina a cor de fundo desejada aqui
                                child: Text(
                                  'Next Evolutions',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Color.fromARGB(255, 255, 255, 255),
                                  ),
                                ),
                              ),
                              CarouselSlider(
                                options: CarouselOptions(
                                  height: 500,
                                ),
                                items: character.nextEvolutions.map((i) {
                                  return Builder(
                                    builder: (BuildContext context) {
                                      return Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        margin: const EdgeInsets.symmetric(
                                          horizontal: 5,
                                        ),
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: NetworkImage(
                                              i['image'] as String,
                                            ),
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                        child: Stack(
                                          children: [
                                            Align(
                                              alignment: Alignment.bottomCenter,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                  bottom: 16,
                                                ),
                                                child: TextButton(
                                                  onPressed: () {
                                                    Navigator.pushNamed(
                                                      context,
                                                      '/detail',
                                                      arguments: {
                                                        'id': i['id'] as int
                                                      },
                                                    );
                                                  },
                                                  style: ButtonStyle(
                                                    backgroundColor:
                                                        MaterialStateProperty
                                                            .all<Color>(
                                                                Colors.blue),
                                                    foregroundColor:
                                                        MaterialStateProperty
                                                            .all<Color>(
                                                                Colors.white),
                                                  ),
                                                  child: Text(
                                                    i['digimon'] as String,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                }).toList(),
                              ),
                            ],
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
