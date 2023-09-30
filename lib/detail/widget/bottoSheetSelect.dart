import 'package:flutter/material.dart';

class BottomSheetSelect extends StatelessWidget {
  const BottomSheetSelect(
      {super.key,
      required this.screenSize,
      required this.title
      });
  final Size screenSize;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: screenSize.width,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            border:
                Border(bottom: BorderSide(width: 1, color: Colors.black12))),
        child: Text(
              title,
              style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            ));
  }
}
