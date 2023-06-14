import 'package:chargames/dataservice/dataservice.dart';
import 'package:chargames/datatablewidget/datatablewidget.dart';
import 'package:chargames/newnavbar/newnavbar.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override

  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      debugShowCheckedModeBanner:false,
      home: Scaffold(
        appBar: AppBar( 
          title: const Text('Dicas'),
          ),
        body: ValueListenableBuilder(
          valueListenable: dataService.tableStateNotifier,
          builder:(_, value, __){
            return DataTableWidget(
              jsonObjects:value, 
              propertyNames: ['name','style','ibu'], 
              columnNames: ['Nome', 'Estilo', 'IBU']
            );
          }
        ),
        bottomNavigationBar: NewNavBar(itemSelectedCallback: dataService.carregar),
      ),);
  }
}
