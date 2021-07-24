import 'package:flutter/material.dart';

abstract class DropdownItem {
  String labelShow();
}

class AppDropDraw<T extends DropdownItem> extends StatelessWidget {
  String hint;
  T valueSelected;
  ValueChanged<T> onChangeCallback;
  List<T> listaItens = List();


  AppDropDraw(this.hint, this.valueSelected, this.onChangeCallback,
      this.listaItens);

  @override
  Widget build(BuildContext context) {
    return DropdownButton<T>(
        hint: Text(hint),
        isExpanded: true,
        value: valueSelected,
        items: getItems(),
        onChanged: (value){
          onChangeCallback(value);
        });
  }

  List<DropdownMenuItem<T>> getItems() {
    List<DropdownMenuItem<T>> list = listaItens.map<DropdownMenuItem<T>>((valor) {
        return DropdownMenuItem<T>(
          value: valor,
          child: Text("${valor.labelShow()}"),
        );

      }).toList();

    return list;
  }

}

//COMO UTILIZAR
// A classe que for para o dropdawn vai necessitar extends para DropdownItem

//var objSeleted =  SampleDropdawn("Paraguai", 30);
//
//var listaObj = [
//  SampleDropdawn("Brasil", 10),
//  SampleDropdawn("Argentina", 20),
//  SampleDropdawn("Paraguai", 30),
//  SampleDropdawn("Colombia", 40),
//];

//AppDropDraw<SampleDropdawn>("HINT", objSeleted, (SampleDropdawn val) => _objSelected(val), listaObj),

//Pode utilizar uma strem builder
//_objSelected(SampleDropdawn val) {
//  print("SELECIONADO: ${val.focusFire}");
//  setState(() {
//    objSeleted = val;
//  });
//
//}

