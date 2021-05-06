import 'package:flutter/material.dart';

class DropdownContainer extends StatelessWidget {
  final Function onDropdownSelect;
  final List<String> items;
  final String value;
  final String hint;

  DropdownContainer({this.onDropdownSelect, this.items, this.value, this.hint});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      width: double.infinity,
      child: DropdownButton(
        dropdownColor: Colors.grey.shade100.withOpacity(.9),
        style: TextStyle(color: Colors.pink),
        underline: SizedBox(),
        value: value,
        onChanged: (String val) {
          print(val);
          onDropdownSelect(val);
        },
        icon: Icon(Icons.arrow_drop_down_sharp, color: Colors.pink,),
        elevation: 3,
        isExpanded: true,
        hint: Text(hint, style: TextStyle(color: Colors.pink),),
        items: items
            .map(
              (item) => DropdownMenuItem(
                value: item,
                child: Text(item),
              ),
            )
            .toList(),
      ),
    );
  }
}
