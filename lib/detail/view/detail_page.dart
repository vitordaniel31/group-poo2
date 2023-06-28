// ignore_for_file: lines_longer_than_80_chars
import 'package:chargames/dashboard/cubit/dashboard_cubit.dart';
import 'package:chargames/detail/detail.dart';
import 'package:chargames/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:carousel_slider/carousel_slider.dart';

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
          style: TextStyle(
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
    List<String> img = [];
    return Scaffold(
      appBar: AppBar(title: Text(l10n.detailAppBarTitle)),
      body: BlocBuilder<DetailCubit, Character>(
        builder: (context, character) {
          character = context.select((DetailCubit cubit) => cubit.state);
          if (character.id != 0) {
            return ListView(
                    children: [
                      Container(
                        color: Color.fromARGB(255, 116, 59, 223), // Defina a cor de fundo desejada aqui
                        child: Text(
                          character.name
                          ,
                          style: TextStyle(
                            fontSize: 40,
                            color: const Color.fromARGB(255, 255, 255, 255),
                          ),
                        ),
                      ),
                      Image.network(
                        character.href,
                        height: 300,
                      ),
                      DataTable(
                        columns: const [
                          DataColumn(label: Text('About digimon:')),
                          DataColumn(label: Text(' ')),
                        ],
                        rows: [
                          buildDataRow('Release Date:', character.criacao),
                          buildDataRow('Type:', character.type),
                          buildDataRow('Fields:', character.fields),
                          buildDataRow('Description:', character.descricao),
                        ],
                        dataRowColor: MaterialStateColor.resolveWith((states) {
                          if (states.contains(MaterialState.selected)) {
                            return Colors.grey
                                .withOpacity(0.5); // Cor de fundo quando selecionada
                          }
                          return Colors.transparent; // Cor de fundo padrão
                        }),
                        dataTextStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 14.0,
                        ),
                      ),

                      Container(
                        color: Color.fromARGB(255, 9, 50, 185), // Defina a cor de fundo desejada aqui
                        child: Text(
                          'Prior Evolutions',
                          style: TextStyle(
                            fontSize: 40,
                            color: const Color.fromARGB(255, 255, 255, 255),
                          ),
                        ),
                      ),


                      CarouselSlider(
                        options: CarouselOptions(height: 500,),
                        items: character.priorEvolutions.map((i) {
                          return Builder(
                            builder: (BuildContext context) {
                              return Container(
                                width: MediaQuery.of(context).size.width,
                                margin: EdgeInsets.symmetric(horizontal: 5.0),
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: NetworkImage("${i['image'] as String}"),
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                child: Stack(
                                  children: [
                                    Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Padding(
                                        padding: EdgeInsets.only(bottom: 16.0),
                                        child: TextButton(
                                          onPressed: () {
                                            Navigator.pushNamed(
                                              context,
                                              '/detail',
                                              arguments: {'id': i['id'] as int},
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
                                          child: Text('text ${i['digimon'] as String}'),
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


                      Container(
                        color: Color.fromARGB(255, 6, 136, 75), // Defina a cor de fundo desejada aqui
                        child: Text(
                          'Next Evolutions',
                          style: TextStyle(
                            fontSize: 40,
                            color: const Color.fromARGB(255, 255, 255, 255),
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
                                width: MediaQuery.of(context).size.width,
                                margin: EdgeInsets.symmetric(horizontal: 5.0),
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: NetworkImage("${i['image'] as String}"),
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                child: Stack(
                                  children: [
                                    Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Padding(
                                        padding: EdgeInsets.only(bottom: 16.0),
                                        child: TextButton(
                                          onPressed: () {
                                            Navigator.pushNamed(
                                              context,
                                              '/detail',
                                              arguments: {'id': i['id'] as int},
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
                                          child: Text('text ${i['digimon'] as String}'),
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
