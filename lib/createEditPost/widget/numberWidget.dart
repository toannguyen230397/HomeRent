import 'package:flutter/material.dart';

class numberWidget extends StatefulWidget {
  const numberWidget({super.key, required this.controller});
  final TextEditingController controller;

  @override
  State<numberWidget> createState() => _numberWidgetState();
}

class _numberWidgetState extends State<numberWidget> {
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Container(
      width: screenSize.width * 0.2,
      padding: EdgeInsets.only(left: 10),
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
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: widget.controller,
              keyboardType: TextInputType.number,
              style: TextStyle(
                  color: Colors.teal.shade300, fontWeight: FontWeight.bold),
              decoration: InputDecoration(border: InputBorder.none),
            ),
          ),
          Column(
            children: [
              Container(
                child: InkWell(
                    onTap: () {
                      int currentValue = int.parse(widget.controller.text);
                      setState(() {
                        currentValue++;
                        widget.controller.text = (currentValue).toString();
                      });
                    },
                    child: Icon(
                      Icons.arrow_drop_up,
                      color: Colors.black38,
                    )),
              ),
              Container(
                child: InkWell(
                    onTap: () {
                      int currentValue = int.parse(widget.controller.text);
                      setState(() {
                        print("Setting state");
                        currentValue--;
                        widget.controller.text =
                            (currentValue > 0 ? currentValue : 0).toString();
                      });
                    },
                    child: Icon(
                      Icons.arrow_drop_down,
                      color: Colors.black38,
                    )),
              ),
            ],
          )
        ],
      ),
    );
  }
}