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
                      Image.network(
                        character.href,
                        height: 300,
                      ),
                      DataTable(
                        columns: const [
                          DataColumn(label: Text('Sobre o Digimon:')),
                        ],
                        rows: [
                            DataRow(
                              cells: [
                                DataCell(
                                  Text('Name: ${character.name}'),
                                ),
                              ],
                            ),
                            DataRow(
                              cells: [
                                DataCell(
                                  Text('Release Date: ${character.criacao}'),
                                ),
                              ],
                            ),
                            DataRow(
                              cells: [
                                DataCell(
                                  Text('Type: ${character.type}'),
                                ),
                              ],
                            ),
                            DataRow(
                              cells: [
                                DataCell(
                                  Text('Fields: ${character.fields}'),
                                ),
                              ],
                            ),
                            DataRow(
                              cells: [
                                DataCell(
                                  Text('Description: ${character.descricao}'),
                                ),
                              ],
                            ),
                        ],
                      ),
                      // Row(
                      //   children: [
                      //     Text('Level: '),
                      //     for (var level in character.levels)
                      //     Text(level['level'] as String),
                      //   ],
                      // ),

                      // Row(
                      //   children: [
                      //     Text('Attributes: '),
                      //     for (var att in character.atributos)
                      //       Text(att['attribute'] as String ),
                      //   ],
                      // ),
                      // ignore: use_colored_box
                      Container(
                        color: Color.fromARGB(255, 112, 63, 248), // Defina a cor de fundo desejada aqui
                        child: Text(
                          'Skills',
                          style: TextStyle(
                            fontSize: 40,
                            color: const Color.fromARGB(255, 255, 255, 255),
                          ),
                        ),
                      ),

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

                      // DataTable(
                      //   columns: const [
                      //     DataColumn(label: Text('Name')),
                      //     DataColumn(label: Text('Condition')),
                      //     DataColumn(label: Text('Image')),
                      //     DataColumn(label: Text('Ver')),
                      //   ],
                      //   rows: [
                      //     for (var prior in character.priorEvolutions)
                      //       DataRow(
                      //         cells: [
                      //           DataCell(
                      //             Text(prior['digimon'] as String),
                      //           ),
                      //           DataCell(
                      //             Text(prior['condition'] as String),
                      //           ),
                      //           DataCell(
                      //             Image.network(
                      //             prior['image'] as String,
                      //             height: 80,
                      //           ),
                      //           ),
                      //           DataCell(
                      //             TextButton(
                      //               onPressed: () {
                      //                 Navigator.pushNamed(
                      //                   context,
                      //                   '/detail',
                      //                   arguments: {'id': prior['id'] as int},
                      //                 );
                      //               },
                      //               style: ButtonStyle(
                      //                 backgroundColor:
                      //                     MaterialStateProperty.all<Color>(Colors.blue),
                      //                 foregroundColor: MaterialStateProperty.all<Color>(
                      //                     Colors.white),
                      //               ),
                      //               child: const Text('Ver'),
                      //             ),
                      //           ),
                      //         ],
                      //       ),
                      //     ],
                      //   ),

                      //   DataTable(
                      //     columns: const [
                      //       DataColumn(label: Text('Name')),
                      //       DataColumn(label: Text('Condition')),
                      //       DataColumn(label: Text('Image')),
                      //       DataColumn(label: Text('Ver')),
                      //     ],
                      //     rows: [
                      //       for (var next in character.nextEvolutions)
                      //         DataRow(
                      //           cells: [
                      //             DataCell(
                      //               Text(next['digimon'] as String),
                      //             ),
                      //             DataCell(
                      //               Text(next['condition'] as String),
                      //             ),
                      //             DataCell(
                      //               Image.network(
                      //                 next['image'] as String,
                      //                 height: 80,
                      //               ),
                      //             ),
                      //             DataCell(
                      //               TextButton(
                      //                 onPressed: () {
                      //                   Navigator.pushNamed(
                      //                     context,
                      //                     '/detail',
                      //                     arguments: {'id': next['id'] as int},
                      //                   );
                      //                 },
                      //                 style: ButtonStyle(
                      //                   backgroundColor:
                      //                       MaterialStateProperty.all<Color>(Colors.blue),
                      //                   foregroundColor: MaterialStateProperty.all<Color>(
                      //                       Colors.white),
                      //                 ),
                      //                 child: const Text('Ver'),
                      //               ),
                      //             ),
                      //           ],
                      //         ),
                      //     ],
                      //   ),

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
