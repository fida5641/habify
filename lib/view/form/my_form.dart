// import 'package:flutter/material.dart';

// class MyFormWidget extends StatelessWidget {
//  const MyFormWidget({
//     super.key,
//     required this.hint,
//     required this.icon, required this.controller,required this.isTarget,
//   });
//   final String hint;
//   final Icon icon;
//   final TextEditingController controller;
//   final bool isTarget;
//   @override
//   Widget build(BuildContext context) {
//     return TextFormField(
//       controller: controller,
//       keyboardType:isTarget? TextInputType.number:null, 
//       decoration:
//           InputDecoration(hintText: hint, icon: icon, border: InputBorder.none),
//     );
//   }
// }