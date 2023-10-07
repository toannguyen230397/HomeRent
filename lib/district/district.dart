import 'package:flutter/material.dart';
import 'package:home_rent/district/api/fetchAPI.dart';
import 'package:home_rent/district/widget/itemList.dart';

class getDistrict extends StatefulWidget {
  const getDistrict(
      {super.key, required this.getAdress, required this.screen});    
  final Function getAdress;
  final String screen;
  @override
  State<getDistrict> createState() => _getDistrictState();
}

class _getDistrictState extends State<getDistrict> {
  final controller = PageController();
  String provinceCode = '';
  String provinceName = '';
  String districtName = '';

  void getProvinceCode(String name, String code) {
    provinceCode = code;
    provinceName = name;
    FocusManager.instance.primaryFocus?.unfocus();
    controller.animateToPage(1, duration: const Duration(seconds: 1), curve: Curves.easeInOut);
  }

  void handleBack(String page) {
    if(page == 'province'){
      Navigator.pop(context);
    } else {
      controller.animateToPage(0, duration: const Duration(seconds: 1), curve: Curves.easeInOut);
    }
  }

  void getDistrictName(String name) {
    districtName = name;
    print('${provinceName}, ${districtName}');
    widget.getAdress(provinceName, districtName);
    Navigator.pop(context);
  }

  void getLocation(String name) {
    districtName = name;
    String address = '${provinceName}, ${districtName}';
    widget.getAdress(address);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: PageView(
        controller: controller,
        physics: NeverScrollableScrollPhysics(),
        children: [
          FutureBuilder(
              future: FetchAPI().getProvinceData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  ); // Đang nạp dữ liệu
                } else if (snapshot.hasError) {
                  print('cant load data');
                  return Center(
                    child: Text('Lỗi: ${snapshot.error}'),
                  ); // Có lỗi xảy ra
                } else {
                  final data = snapshot.data!;
                  return itemList(data: data, handleSelected: getProvinceCode, page: 'province', handleBack: handleBack,);
                }
              }),
          FutureBuilder(
              future: FetchAPI().getDistrictData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  ); // Đang nạp dữ liệu
                } else if (snapshot.hasError) {
                  print('cant load data');
                  return Center(
                    child: Text('Lỗi: ${snapshot.error}'),
                  ); // Có lỗi xảy ra
                } else {
                  final data = snapshot.data!;
                  List<Map<String, dynamic>> filteredData = data
                  .where((item) => item['province_code'].toString()
                      .toLowerCase()
                      .contains(provinceCode.toLowerCase()))
                  .toList();
                  return itemList(data: filteredData, handleSelected: widget.screen == 'map' ? getLocation : getDistrictName, page: 'district', handleBack: handleBack,);
                }
              })
        ],
      )),
    );
  }
}






// InkWell(
//             onTap: () {
//               widget.updateState('Thành phố Biên Hòa');
//             },
//             child: Text('abc'))

