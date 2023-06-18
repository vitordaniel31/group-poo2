import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;

class Character {
  Character(
      {required this.id,
      required this.name,
      required this.title,
      required this.image,
      required this.blurb});

  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
      id: json['id'] as String,
      name: utf8.decode(json['name'].toString().codeUnits),
      title: utf8.decode(json['title'].toString().codeUnits),
      image: json['image']['full'] as String,
      blurb: utf8.decode(json['blurb'].toString().codeUnits),
    );
  }

  final String id;
  final String name;
  final String title;
  final String image;
  final String blurb;
}

class DashboardCubit extends Cubit<List<Character>> {
  DashboardCubit() : super([]);

  Future<void> fetchCharacters() async {
    try {
      final response = await http.get(
        Uri.parse(
            'https://ddragon.leagueoflegends.com/cdn/13.12.1/data/pt_BR/champion.json'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final characterData = data['data'] as Map<String, dynamic>;

        final fetchedCharacters = characterData.values
            .map(
              (characterJson) =>
                  Character.fromJson(characterJson as Map<String, dynamic>),
            )
            .toList();

        emit(fetchedCharacters);
      } else {
        throw Exception('Failed to fetch champions');
      }
    } catch (error) {
      throw Exception('Failed to fetch champions: $error');
    }
  }
}
