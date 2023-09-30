import 'package:flutter/material.dart';

class itemList extends StatefulWidget {
  const itemList({super.key, required this.data, required this.handleSelected, required this.page, required this.handleBack});

  final List<Map<String, dynamic>> data;
  final Function handleSelected;
  final String page;
  final Function handleBack;

  @override
  State<itemList> createState() => _itemListState();
}

class _itemListState extends State<itemList> {
  TextEditingController searchInput_Controller = TextEditingController();
  String searchInput = '';

  @override
  Widget build(BuildContext context) {
    final data = widget.data;
    List<Map<String, dynamic>> filteredData = data
        .where((item) => item['name']
            .toLowerCase()
            .contains(searchInput_Controller.text.toLowerCase()))
        .toList();
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(left: 10, right: 10),
          padding: EdgeInsets.only(left: 5, right: 5, bottom: 5),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(10.0),
                bottomLeft: Radius.circular(10.0)),
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
            controller: searchInput_Controller,
            onChanged: (value) {
              searchInput = value;
              setState(() {                
              });
            },
            decoration: InputDecoration(
              border: InputBorder.none,
              prefixIcon: IconButton(
                onPressed: () {
                  widget.handleBack(widget.page);
                },
                icon: Icon(Icons.arrow_back_ios),
              ),
              suffixIcon: searchInput_Controller.text.isEmpty
                  ? IconButton(
                      onPressed: () {
                        setState(() {});
                      },
                      icon: Icon(Icons.search))
                  : IconButton(
                      onPressed: () {
                        FocusManager.instance.primaryFocus?.unfocus();
                        searchInput_Controller.clear();
                        setState(() {});
                      },
                      icon: Icon(Icons.clear)),
              hintText: widget.page == 'province' ? 'Tìm tỉnh thành' : 'Tìm quận huyện',
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: searchInput_Controller.text.isEmpty ? data.length : filteredData.length,
                  itemBuilder: (BuildContext context, int index) {
                    final item = searchInput_Controller.text.isEmpty ? data[index] : filteredData[index];
                    return Container(
                      padding: EdgeInsets.only(bottom: 10, top: 10),
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  width: 1, color: Colors.black12))),
                      child: Row(
                        children: [
                          Icon(Icons.arrow_right),
                          SizedBox(
                            width: 5,
                          ),
                          InkWell(
                            onTap: () {
                              if(widget.page == 'province'){
                                widget.handleSelected(item['name'].toString(), item['code'].toString());
                              }else{
                                widget.handleSelected(item['name'].toString());
                              }
                            },
                            child: Text(
                              item['name'],
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
        ),
      ],
    );
  }
}