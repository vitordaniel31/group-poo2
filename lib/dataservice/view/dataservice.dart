import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DataService{

  final ValueNotifier<List<dynamic>> tableStateNotifier = ValueNotifier([]);

  void carregar(int index){

    var res = null;

    print('carregar #1 - antes de carregarCervejas');

    if (index == 1) res = carregarCervejas();

    print('carregar #2 - carregarCervejas retornou $res');

  }


  Future<void> carregarCervejas() async{

    var beersUri = Uri(

      scheme: 'https',

      host: 'random-data-api.com',

      path: 'api/beer/random_beer',

      queryParameters: {'size': '5'});


    print('carregarCervejas #1 - antes do await');

    var jsonString = await http.read(beersUri);

    print('carregarCervejas #2 - depois do await');

    var beersJson = jsonDecode(jsonString);


    tableStateNotifier.value = beersJson as List<dynamic>;

  }
}

final dataService = DataService();
