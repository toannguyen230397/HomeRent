import 'dart:io';

import 'package:flutter/material.dart';
import 'package:home_rent/createEditPost/api/firebaseAPI.dart';
import 'package:home_rent/createEditPost/widget/checkBoxWidget.dart';
import 'package:home_rent/createEditPost/widget/imageWidget.dart';
import 'package:home_rent/createEditPost/widget/numberWidget.dart';
import 'package:home_rent/createEditPost/widget/textFieldWidget.dart';
import 'package:home_rent/district/district.dart';
import 'package:home_rent/helper_function/function.dart';

class CreateOrEditPost extends StatefulWidget {
  const CreateOrEditPost({super.key, required this.ownerID, required this.datas, required this.title});
  final String ownerID;
  final Map<String, dynamic> datas;
  final String title;

  @override
  State<CreateOrEditPost> createState() => _CreateOrEditPostState();
}

class _CreateOrEditPostState extends State<CreateOrEditPost> {

  TextEditingController owner_Controller = TextEditingController();
  TextEditingController renter_Controller = TextEditingController();
  TextEditingController tenNha_Controller = TextEditingController();
  TextEditingController price_Controller = TextEditingController();
  TextEditingController roomNumber_Controller = TextEditingController();
  TextEditingController floorNumber_Controller = TextEditingController();
  TextEditingController ward_Controller = TextEditingController();
  TextEditingController latitude_Controller = TextEditingController();
  TextEditingController longitude_Controller = TextEditingController();
  TextEditingController desc_Controller = TextEditingController();


  String docID = '';
  String district = '';
  String province = '';
  List<File> houseImages = [];
  List<File> furnitureImages = [];
  List<dynamic> furniture = [];

  List<dynamic> houseImagesURL = [];
  List<dynamic> furnitureImagesURL = [];

  void getProvincetName(String value) {
    province = value;
  }

  void getDistrictName(String value) {
    district = value;
    setState(() {});
  }

  void checkScreen() {
    final datas = widget.datas;
    if(datas.isEmpty) {
      owner_Controller.text = widget.ownerID;
      roomNumber_Controller.text = '0';
      floorNumber_Controller.text = '0';
    } else {
      docID = datas['maNha'];
      owner_Controller.text = datas['owner'];
      renter_Controller.text = datas['renter'];
      tenNha_Controller.text = datas['tenNha'];
      price_Controller.text = datas['price'].toString();
      roomNumber_Controller.text = datas['rooms'];
      floorNumber_Controller.text = datas['floors'];
      houseImagesURL = datas['housePhotos'];
      furnitureImagesURL = datas['interiorPhotos'];
      furniture = datas['furniture'];
      province = datas['province'];
      district = datas['district'];
      ward_Controller.text = datas['ward'];
      latitude_Controller.text = datas['latitude'];
      longitude_Controller.text = datas['longitude'];
      desc_Controller.text = datas['desc'];  
    }
  }

  void initState() {
    super.initState();
    checkScreen();
  }

  @override
  Widget build(BuildContext context) {
    bool isEditScreen = widget.datas.isNotEmpty;
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade50,
      appBar: AppBar(
          backgroundColor: Colors.blueGrey.shade100,
          surfaceTintColor: Colors.white,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back_ios_new,
                size: 30,
              )),
          leadingWidth: 30,
          title: Text(
            widget.title,
            style: TextStyle(fontWeight: FontWeight.bold),
          )),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFieldWidget(
                  label: 'Chủ hộ',
                  icon: Icon(Icons.person),
                  type: 'text',
                  line: 1,
                  enable: false,
                  controller: owner_Controller,
                ),
                TextFieldWidget(
                  label: 'Người thuê',
                  icon: Icon(Icons.person),
                  type: 'text',
                  line: 1,
                  enable: isEditScreen ? true : false,
                  controller: renter_Controller,
                ),
                TextFieldWidget(
                  label: 'Tên căn hộ',
                  icon: Icon(Icons.house),
                  type: 'text',
                  line: 1,
                  enable: true,
                  controller: tenNha_Controller,
                ),
                TextFieldWidget(
                  label: 'Giá thuê',
                  icon: Icon(Icons.money),
                  type: 'number',
                  line: 1,
                  enable: true,
                  controller: price_Controller,
                ),
                Container(
                  margin:
                      EdgeInsets.only(top: 20, bottom: 10, left: 40, right: 40),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: Row(
                          children: [
                            Text(
                              'Số phòng: ',
                              style: TextStyle(
                                  color: Colors.teal.shade300,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            numberWidget(
                              controller: roomNumber_Controller,
                            )
                          ],
                        ),
                      ),
                      Container(
                        child: Row(
                          children: [
                            Text(
                              'Số lầu: ',
                              style: TextStyle(
                                  color: Colors.teal.shade300,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            numberWidget(
                              controller: floorNumber_Controller,
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                imagesWidget(
                  imageList: houseImages,
                  ImagesURL: houseImagesURL,
                  title: 'Ảnh ngôi nhà: ',
                ),
                imagesWidget(
                  imageList: furnitureImages,
                  ImagesURL: furnitureImagesURL,
                  title: 'Ảnh nội thất: ',
                ),
                Container(
                    margin: EdgeInsets.only(
                        top: 20, bottom: 10, left: 40, right: 40),
                    padding: EdgeInsets.all(10),
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Nội thất có sẵn: ',
                          style: TextStyle(
                              color: Colors.teal.shade300,
                              fontWeight: FontWeight.bold),
                        ),
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                checkBoxWidget(
                                    item: 'TV', checkedItems: furniture),
                                checkBoxWidget(
                                    item: 'Giường', checkedItems: furniture),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                checkBoxWidget(
                                    item: 'Điều hòa', checkedItems: furniture),
                                checkBoxWidget(
                                    item: 'Wifi', checkedItems: furniture),
                              ],
                            ),
                          ],
                        ),
                      ],
                    )),
                Container(
                  width: screenSize.width,
                  height: screenSize.height * 0.06,
                  margin:
                      EdgeInsets.only(top: 20, bottom: 10, left: 40, right: 40),
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
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => getDistrict(
                              getProvinceName: getProvincetName,
                              getDistrictName: getDistrictName,
                            ),
                          ));
                    },
                    child: Row(
                      children: [
                        Text(
                          province == '' && district == ''
                              ? 'Chọn tỉnh thành, quận huyện'
                              : '${province}, ${district}',
                          style: TextStyle(
                              color: province == '' && district == ''
                                  ? Colors.teal.shade300.withOpacity(0.5)
                                  : Colors.teal.shade300,
                              fontWeight: FontWeight.bold),
                        ),
                        Icon(Icons.arrow_drop_down)
                      ],
                    ),
                  ),
                ),
                TextFieldWidget(
                  label: 'Nhập địa chỉ phường xã, số nhà',
                  icon: Icon(Icons.location_on),
                  type: 'richText',
                  line: 1,
                  enable: true,
                  controller: ward_Controller,
                ),
                TextFieldWidget(
                  label: 'Vĩ độ:',
                  icon: Icon(Icons.location_on),
                  type: 'number',
                  line: 1,
                  enable: true,
                  controller: latitude_Controller,
                ),
                TextFieldWidget(
                  label: 'Kinh độ:',
                  icon: Icon(Icons.location_on),
                  type: 'number',
                  line: 1,
                  enable: true,
                  controller: longitude_Controller,
                ),
                TextFieldWidget(
                  label: 'Viết mô tả:',
                  icon: Icon(Icons.note),
                  type: 'richText',
                  line: 8,
                  enable: true,
                  controller: desc_Controller,
                ),
                InkWell(
                  onTap: () {
                    final ownerID = owner_Controller.text;
                    final renterID = renter_Controller.text;
                    final tenNha = tenNha_Controller.text;
                    final price = price_Controller.text.isEmpty ? 0 : int.parse(price_Controller.text);
                    final rooms = roomNumber_Controller.text;
                    final floors = floorNumber_Controller.text;
                    final latitude = latitude_Controller.text;
                    final longitude = longitude_Controller.text;
                    final ward = ward_Controller.text;
                    final desc = desc_Controller.text;
                    bool textFieldEmpty = tenNha.isEmpty || price == 0 || rooms == "0" || floors == "0" || latitude.isEmpty || longitude.isEmpty || ward.isEmpty || desc.isEmpty;
                    bool proviDistrEmpty = province.isEmpty && district.isEmpty;
                    if(isEditScreen) {
                      if(textFieldEmpty || proviDistrEmpty || furniture.isEmpty) {
                        Helper_Fuction().showToastMessege('Vui lòng nhập đủ thông tin!');
                      } else {
                        CreatePostEditAPI().updatePost(docID, ownerID, renterID, tenNha, price, rooms, floors, latitude, longitude, furniture, houseImages, furnitureImages, houseImagesURL, furnitureImagesURL, province, district, ward, desc);
                        Navigator.pop(context);
                        Navigator.pop(context);
                        Helper_Fuction().showToastMessege('Chỉnh sửa thành công!');
                      }
                    } else {
                      if(textFieldEmpty || proviDistrEmpty || houseImages.isEmpty || furnitureImages.isEmpty || furniture.isEmpty) {
                        Helper_Fuction().showToastMessege('Vui lòng nhập đủ thông tin!');
                      } else {
                        CreatePostEditAPI().createPost(ownerID, renterID, tenNha, price, rooms, floors, latitude, longitude, furniture, houseImages, furnitureImages, province, district, ward, desc);
                        Navigator.pop(context);
                        Helper_Fuction().showToastMessege('Đăng bài thành công!');
                      }
                    }
                  },
                  child: Container(
                    width: screenSize.width,
                    height: screenSize.height * 0.06,
                    margin:
                        EdgeInsets.only(top: 20, bottom: 10, left: 40, right: 40),
                    padding: EdgeInsets.only(left: 10, right: 10),
                    decoration: BoxDecoration(
                      color: Colors.teal.shade300,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(isEditScreen ? 'Chỉnh sửa' : 'Đăng Bài', style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}