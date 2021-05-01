// import 'package:flutter/material.dart';

// class DropdownContainer extends StatelessWidget {
//   Function fn;
//   List<String> items;
//   String value;

//   DropdownContainer({this.fn, this.items, this.value});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 10),
//       width: double.infinity,
//       child: DropdownButton(
//         underline: SizedBox(),
//         value: _selDifficulty,
//         onChanged: (value) {
//           print(value);
//           setDifficulty(value);
//         },
//         icon: Icon(Icons.arrow_drop_down_sharp),
//         elevation: 3,
//         isExpanded: true,
//         hint: Text("Difficulty"),
//         items: items
//             .map(
//               (item) => DropdownMenuItem(
//                 value: item,
//                 child: Text(item),
//               ),
//             )
//             .toList(),
//       ),
//     );
//   }
// }
