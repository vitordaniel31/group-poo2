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

List<Character> characters = [];

class DashboardCubit extends Cubit<List<Character>> {
  DashboardCubit() : super([]);

  int pageSize = 20;
  int currentPage = 1;
  int totalPages = 1;

  Future<void> fetchCharacters(String search) async {
    try {
      if (currentPage <= totalPages) {
        final response = await http.get(
          Uri.parse(
            'https://www.digi-api.com/api/v1/digimon?pageSize=$pageSize&page=$currentPage',
          ),
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          totalPages = data['pageable']['totalPages'] as int;

          final characterData = data['content'] as List<dynamic>;

          final fetchedCharacters = characterData
              .map((dynamic characterJson) =>
                  Character.fromJson(characterJson as Map<String, dynamic>))
              .toList();

          if (currentPage == 1) {
            characters.clear();
          }

          characters.addAll(fetchedCharacters);

          emit(fetchedCharacters);
        }
      } else {
        throw Exception('Failed to fetch characters');
      }
    } catch (error) {
      throw Exception('Failed to fetch characters: $error');
    }
  }

  void filterCharacters(String search) {
    if (search.isEmpty) {
      emit(characters);
    } else {
      final searchLowerCase = search.toLowerCase();
      final filteredCharacters = characters
          .where(
            (character) =>
                searchLowerCase.isEmpty ||
                (character.id
                        .toString()
                        .toLowerCase()
                        .contains(searchLowerCase) ||
                    character.name.toLowerCase().contains(searchLowerCase)),
          )
          .toList();
      emit(filteredCharacters);
    }
  }

  void loadMoreCharacters(String search) {
    currentPage++;
    fetchCharacters(search);
  }
}
