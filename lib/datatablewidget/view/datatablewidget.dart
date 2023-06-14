import 'package:flutter/material.dart';

class DataTableWidget extends StatelessWidget {


  final List<dynamic> jsonObjects;

  final List<String> columnNames;

  final List<String> propertyNames;


  DataTableWidget( {this.jsonObjects = const [], 
    this.columnNames = const ['Nome','Estilo','IBU'], 
    this.propertyNames= const ['name', 'style', 'ibu']});


  @override

  Widget build(BuildContext context) {

    return DataTable(

      columns: columnNames.map( 

                (name) => DataColumn(

                  label: Expanded(

                    child: Text(name, style: TextStyle(fontStyle: FontStyle.italic))

                  )

                )

              ).toList()       

      ,

      rows: jsonObjects.map( 

        (obj) => DataRow(

            cells: propertyNames.map(

              (propName) => DataCell(Text(obj[propName].toString())),

            ).toList(),

          ),

        ).toList(),);

  }
}
