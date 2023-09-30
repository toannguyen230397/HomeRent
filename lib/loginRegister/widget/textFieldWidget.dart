import 'package:flutter/material.dart';

class TextFieldWidget extends StatelessWidget {
  const TextFieldWidget(
      {super.key,
      required this.label,
      required this.icon,
      required this.isPassword,
      required this.controller,
      required this.type});
  final String label;
  final Icon icon;
  final bool isPassword;
  final TextEditingController controller;
  final String type;

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
        obscureText: isPassword,
        controller: controller,
        keyboardType: type == 'phoneNumber' ? TextInputType.number : TextInputType.text,
        maxLength: type == 'phoneNumber' ? 11 : null,
        style:
            TextStyle(color: Colors.teal.shade300, fontWeight: FontWeight.bold),
        decoration: InputDecoration(
            counterText: "",
            border: InputBorder.none,
            prefixIcon: icon,
            hintText: label,
            hintStyle: TextStyle(
                color: Colors.teal.shade300.withOpacity(0.5),
                fontWeight: FontWeight.bold)),
      ),
    );
  }
}