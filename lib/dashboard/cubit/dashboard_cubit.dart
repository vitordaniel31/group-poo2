import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;

class Character {
  Character({
    this.id = 0,
    this.name = '',
    this.image = '',
    this.description = '',
    this.releaseDate = '',
    this.type = '',
    this.fields = '',
    this.priorEvolutions = const [],
    this.nextEvolutions = const [],
  });

  factory Character.fromJson(Map<String, dynamic> json) {
    var image = '';
    var description = '';
    var type = '';
    var fields = '';
    final priorData = json['priorEvolutions'] as List<dynamic>?;
    final nextData = json['nextEvolutions'] as List<dynamic>?;

    if (json.containsKey('image')) {
      image = json['image'] as String;
    } else if (json.containsKey('images')) {
      final firstImage = (json['images'] as List<dynamic>)[0];
      if (firstImage is Map<String, dynamic> &&
          firstImage.containsKey('href')) {
        image = firstImage['href'] as String;
      }
    }

    if (json.containsKey('descriptions')) {
      final firstDescription = (json['descriptions'] as List<dynamic>)[1];
      if (firstDescription is Map<String, dynamic> &&
          firstDescription.containsKey('description')) {
        description = firstDescription['description'] as String;
      }
    }

    if (json.containsKey('types')) {
      final firstType = (json['types'] as List<dynamic>)[0];
      if (firstType is Map<String, dynamic> && firstType.containsKey('type')) {
        type = firstType['type'] as String;
      }
    }

    if (json.containsKey('fields')) {
      for (var field in json['fields'] as List) {
        field = field['field'];
        fields = '$fields$field, ';
      }

      if (fields.endsWith(', ')) {
        fields = fields.substring(0, fields.length - 2);
      }
    }

    final priorEvolutions = priorData != null
        ? List<Map<String, dynamic>>.from(priorData)
        : <Map<String, dynamic>>[];

    final nextEvolutions = nextData != null
        ? List<Map<String, dynamic>>.from(nextData)
        : <Map<String, dynamic>>[];

    return Character(
      id: json['id'] as int,
      name: utf8.decode(json['name'].toString().codeUnits),
      image: image,
      description: utf8.decode(description.codeUnits),
      releaseDate: utf8.decode(json['releaseDate'].toString().codeUnits),
      type: utf8.decode(type.codeUnits),
      fields: fields,
      priorEvolutions: priorEvolutions,
      nextEvolutions: nextEvolutions,
    );
  }

  final int id;
  final String name;
  final String image;
  final String description;
  final String releaseDate;
  final String type;
  final String fields;
  final List<Map<String, dynamic>> priorEvolutions;
  final List<Map<String, dynamic>> nextEvolutions;
}

class DashboardCubit extends Cubit<List<Character>> {
  DashboardCubit() : super([]);

  List<Character> characters = [];

  int pageSize = 20;
  int currentPage = 0;
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

          final updatedCharacters = List<Character>.from(characters);
          updatedCharacters.addAll(fetchedCharacters);

          characters = updatedCharacters;

          filterCharacters(search);
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
