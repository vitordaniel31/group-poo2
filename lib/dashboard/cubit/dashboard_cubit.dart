import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;

class Character {
  Character({
    this.id = 0,
    this.name = '',
    this.image = '',
    this.href = '',
    this.levels = const [],
    this.type = '',
    this.atributos = const [],
    this.fields = '',
    this.criacao = '',
    this.descricao = '',
    this.skills = const [],
    this.priorEvolutions = const [],
    this.nextEvolutions = const [],
  });

  factory Character.fromJson(Map<String, dynamic> json) {
    final levelsData = json['levels'] as List<dynamic>?;
    final atributosData = json['attributes'] as List<dynamic>?;
    final skillsData = json['skills'] as List<dynamic>?;
    final priorData = json['priorEvolutions'] as List<dynamic>?;
    final nextData = json['nextEvolutions'] as List<dynamic>?;

    // ignore: omit_local_variable_types, prefer_final_locals, lines_longer_than_80_chars
    List<Map<String, dynamic>> levels =
        levelsData != null ? List<Map<String, dynamic>>.from(levelsData) : [];
    // ignore: omit_local_variable_types, prefer_final_locals, lines_longer_than_80_chars
    List<Map<String, dynamic>> atributos = atributosData != null
        ? List<Map<String, dynamic>>.from(atributosData)
        : [];
    // ignore: omit_local_variable_types, prefer_final_locals, lines_longer_than_80_chars
    List<Map<String, dynamic>> skills =
        skillsData != null ? List<Map<String, dynamic>>.from(skillsData) : [];
    // ignore: omit_local_variable_types, prefer_final_locals, lines_longer_than_80_chars
    List<Map<String, dynamic>> priorEvolutions =
        priorData != null ? List<Map<String, dynamic>>.from(priorData) : [];
    // ignore: omit_local_variable_types, prefer_final_locals, lines_longer_than_80_chars
    List<Map<String, dynamic>> nextEvolutions =
        nextData != null ? List<Map<String, dynamic>>.from(nextData) : [];

    return Character(
      id: json['id'] as int,
      name: utf8.decode(json['name'].toString().codeUnits),
      image: (json.containsKey('image') ? json['image'] : '') as String,
      criacao: utf8.decode(json['releaseDate'].toString().codeUnits),
      href: json.containsKey('images')
          // ignore: avoid_dynamic_calls
          ? (json['images'][0]['href'] as String? ?? '')
          : '',
      type: json.containsKey('types')
          // ignore: avoid_dynamic_calls
          ? (json['types'][0]['type'] as String? ?? '')
          : '',
      fields: json.containsKey('fields')
          // ignore: avoid_dynamic_calls
          ? (json['fields'][0]['field'] as String? ?? '')
          : '',
      descricao: json.containsKey('descriptions')
          // ignore: avoid_dynamic_calls
          ? (json['descriptions'][1]['description'] as String? ?? '')
          : '',
      levels: levels,
      atributos: atributos,
      skills: skills,
      priorEvolutions: priorEvolutions,
      nextEvolutions: nextEvolutions,
    );
  }

  final int id;
  final String name;
  final String image;
  final String href;
  final List<Map<String, dynamic>> levels;
  final String type;
  final List<Map<String, dynamic>> atributos;
  final String fields;
  final String criacao;
  final String descricao;
  final List<Map<String, dynamic>> skills;
  final List<Map<String, dynamic>> priorEvolutions;
  final List<Map<String, dynamic>> nextEvolutions;
}


class DashboardCubit extends Cubit<List<Character>> {
  DashboardCubit() : super([]);

  List<Character> characters = [];

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
