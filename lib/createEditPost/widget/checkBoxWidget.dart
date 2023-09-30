import 'package:flutter/material.dart';

class checkBoxWidget extends StatefulWidget {
  const checkBoxWidget(
      {super.key, required this.item, required this.checkedItems});
  final String item;
  final List<dynamic> checkedItems;

  @override
  State<checkBoxWidget> createState() => _checkBoxWidgetState();
}

class _checkBoxWidgetState extends State<checkBoxWidget> {
  
  void handleCheckBoxChange(String item) {
    setState(() {
      if (widget.checkedItems.contains(item)) {
        widget.checkedItems.remove(item);
        print(widget.checkedItems);
      } else {
        widget.checkedItems.add(item);
        print(widget.checkedItems);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isChecked = widget.checkedItems.contains(widget.item);
    return Container(
      child: Row(
        children: [
          Checkbox(
            value: isChecked,
            onChanged: (value) {
              handleCheckBoxChange(widget.item);
            },
          ),
          Text(
            widget.item,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}