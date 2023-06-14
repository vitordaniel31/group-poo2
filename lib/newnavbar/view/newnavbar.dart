import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class NewNavBar extends HookWidget {

  const NewNavBar({super.key, dynamic itemSelectedCallback}):
    _itemSelectedCallback = itemSelectedCallback ?? int;

  final dynamic _itemSelectedCallback;

  @override

  Widget build(BuildContext context) {

    final state = useState(1);

    

    return BottomNavigationBar(

      onTap: (index){

        state.value = index;

        _itemSelectedCallback(index);                

      }, 

      currentIndex: state.value,

      items: const [

        BottomNavigationBarItem(

          label: 'Cafés',

          icon: Icon(Icons.coffee_outlined),

        ),


        BottomNavigationBarItem(
            label: 'Cervejas', icon: Icon(Icons.local_drink_outlined),),
        BottomNavigationBarItem(
          label: 'Nações', icon: Icon(Icons.flag_outlined),)
      ],);
  }
}
