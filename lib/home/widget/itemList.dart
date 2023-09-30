import 'package:flutter/material.dart';
import 'package:home_rent/detail/detail.dart';
import 'package:cached_network_image/cached_network_image.dart';

class itemList extends StatefulWidget {
  const itemList({super.key, required this.datas, required this.currentUser});
  final List<Map<String, dynamic>> datas;
  final String currentUser;

  @override
  State<itemList> createState() => _itemListState();
}

class _itemListState extends State<itemList> {
  TextEditingController searchInput_Controller = TextEditingController();
  String searchInput = '';
  String priceValue = "0";
  List<String> priceList = ["0", "1000", "2000", "3000"];
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    //Khởi tạo list datas
    List<Map<String, dynamic>> datas = widget.datas;
    int priceConvert = int.parse(priceValue);

    //Lọc datas khi priceSelect được chọn có giá trị lớn hơn 0
    if (priceConvert > 0) {
      datas = datas.where((item) => item['price'] <= priceConvert).toList();
    }

    //lọc một list mới tù datas với dữ liệu search
    List<Map<String, dynamic>> filteredData = datas
        .where((item) => item['tenNha']
            .toLowerCase()
            .contains(searchInput_Controller.text.toLowerCase()))
        .toList();

    final WhiteColor = Colors.white;
    final greyColor = Colors.grey;
    return Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: screenSize.width,
              margin: EdgeInsets.only(left: 10, right: 10),
              color: Colors.white,
              child: DropdownButton<String>(
                underline: SizedBox(),
                padding: EdgeInsets.only(left: 10, right: 10),
                value: priceValue,
                items: priceList.map((item) => DropdownMenuItem<String>(
                  value: item,
                  child: Text(item == "0" ? "Giá mặc định" : "${item} trở xuống", style: TextStyle(color: Colors.teal.shade300),),
                  )).toList(),
                onChanged: (value) {
                  setState(() {
                    priceValue = value!;
                  });
                },
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 10, right: 10),
              padding: EdgeInsets.only(left: 10, right: 5),
              decoration: BoxDecoration(
                color: WhiteColor,
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(10.0),
                    bottomLeft: Radius.circular(10.0)),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Colors.blueGrey.shade500,
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
                  setState(() {});
                },
                decoration: InputDecoration(
                  border: InputBorder.none,
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
                  hintText: 'Search',
                ),
              ),
            ),
          ],
        ),
        Expanded(
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: searchInput_Controller.text.isNotEmpty
                  ? filteredData.length
                  : datas.length,
              itemBuilder: (BuildContext context, int index) {
                final item = searchInput_Controller.text.isNotEmpty
                    ? filteredData[index]
                    : datas[index];
                return InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Detail(
                              datas: item, currentUser: widget.currentUser),
                        ));
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 30, left: 10, right: 10),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: WhiteColor,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: screenSize.width,
                          height: screenSize.height * 0.3,
                          child: CachedNetworkImage(
                            imageUrl: item['housePhotos'][0],
                            fit: BoxFit.fill,
                            placeholder: (context, url) => Container(
                              color: Colors.blueGrey.shade100,
                              width: screenSize.width,
                              height: screenSize.height * 0.3,
                              child: Center(
                                  child: CircularProgressIndicator(
                                color: Colors.white,
                              )),
                            ),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item['tenNha'],
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                item['province'] + ', ' + item['district'],
                                style: TextStyle(color: greyColor),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10, bottom: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                child: Row(
                                  children: [
                                    Container(
                                        width: 70,
                                        decoration: BoxDecoration(
                                          color: Colors.cyan.shade50,
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        padding: EdgeInsets.all(5),
                                        child: Center(
                                          child: Text(
                                            "${item['rooms']} Phòng",
                                            style: TextStyle(
                                                color: Colors.teal.shade300),
                                          ),
                                        )),
                                    Container(
                                        width: 70,
                                        margin: EdgeInsets.only(left: 10),
                                        decoration: BoxDecoration(
                                          color: Colors.cyan.shade50,
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        padding: EdgeInsets.all(5),
                                        child: Center(
                                          child: Text(
                                            "${item['floors']} Lầu",
                                            style: TextStyle(
                                                color: Colors.teal.shade300),
                                          ),
                                        ))
                                  ],
                                ),
                              ),
                              Text(
                                '${item['price']} VNĐ',
                                style: TextStyle(
                                    color: Colors.teal.shade300,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              }),
        ),
      ],
    );
  }
}
