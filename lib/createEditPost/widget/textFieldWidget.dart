import 'package:flutter/material.dart';

class TextFieldWidget extends StatelessWidget {
  const TextFieldWidget(
      {super.key,
      required this.label,
      required this.icon,
      required this.type,
      required this.line,
      required this.enable,
      required this.controller});
  final String label;
  final Icon icon;
  final String type;
  final int line;
  final bool enable;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20, bottom: 10, left: 40, right: 40),
      padding: EdgeInsets.only(left: 10, right: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.blueGrey.shade300,
            blurRadius: 20.0,
            spreadRadius: -20.0,
            offset: Offset(0.0, 25.0),
          )
        ],
      ),
      child: TextField(
        controller: controller,
        readOnly: !enable,
        maxLines: line,
        keyboardType:
            type == 'number' ? TextInputType.number : TextInputType.text,
        style:
            TextStyle(color: Colors.teal.shade300, fontWeight: FontWeight.bold),
        decoration: InputDecoration(
            border: InputBorder.none,
            prefixIcon: type == 'richText' ? null : icon,
            hintText: label,
            hintStyle: TextStyle(
                color: Colors.teal.shade300.withOpacity(0.5),
                fontWeight: FontWeight.bold)),
      ),
    );
  }
}