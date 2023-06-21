import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;

class Character {
  Character({
    this.id = 0,
    this.name = '',
    this.image = '',
  });

  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
      id: json['id'] as int,
      name: utf8.decode(json['name'].toString().codeUnits),
      image: (json.containsKey('image') ? json['image'] : '') as String,
    );
  }

  final int id;
  final String name;
  final String image;
}

List<Character> perOriginal = [];

class DashboardCubit extends Cubit<List<Character>> {
  DashboardCubit() : super([]);

  Future<void> fetchCharacters(String search) async {
    try {
      final response = await http.get(
        Uri.parse('https://www.digi-api.com/api/v1/digimon?pageSize=20'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final characterData = data['content'] as List<dynamic>;

        final fetchedCharacters = characterData
            .map(
              (dynamic characterJson) =>
                  Character.fromJson(characterJson as Map<String, dynamic>),
            ).where((character) {
              final searchLowerCase = search.toLowerCase();
              return searchLowerCase.isEmpty || 
              (character.id.toString().toLowerCase().contains(searchLowerCase) 
              || character.name.toLowerCase().contains(searchLowerCase)
              );
            },).toList();

        emit(fetchedCharacters);
      } else {
        throw Exception('Failed to fetch characters');
      }
    } catch (error) {
      throw Exception('Failed to fetch champions: $error');
    }
  }
}
