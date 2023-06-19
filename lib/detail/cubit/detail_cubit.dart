import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:chargames/dashboard/cubit/dashboard_cubit.dart';
import 'package:http/http.dart' as http;

class DetailCubit extends Cubit<Character> {
  DetailCubit({required this.id}) : super(Character());

  final int id;

  Future<void> fetchCharacter() async {
    try {
      final response = await http.get(
        Uri.parse('https://www.digi-api.com/api/v1/digimon/${id}'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        final fetchedCharacter =
            Character.fromJson(data as Map<String, dynamic>);

        emit(fetchedCharacter);
      } else {
        throw Exception('Failed to fetch characters');
      }
    } catch (error) {
      throw Exception('Failed to fetch champions: $error');
    }
  }
}
