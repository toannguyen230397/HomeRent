import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

import 'package:home_rent/detail/api/firebaseAPI.dart';

class CreatePostEditAPI {
  CollectionReference feedRef = FirebaseFirestore.instance.collection('Feeds'); //Chỉ mục tới Collection Feeds
  CollectionReference userRef = FirebaseFirestore.instance.collection('Users'); //Chỉ mục tới Collection Users
  
  final storageRef = FirebaseStorage.instance.ref();

  void createPost(
    String ownerID,
    String renterID,
    String tenNha,
    int price,
    String rooms,
    String floors,
    String latitude,
    String longitude,
    List<dynamic> furniture,
    List<File> housePhotos,
    List<File> interiorPhotos,
    String province,
    String district,
    String ward,
    String desc,
    ) async {
    int timestamp = DateTime.now().millisecondsSinceEpoch;    
    final docRef = feedRef.doc();
    final docUserRef = userRef.doc(ownerID);
    List<String> housePhotosURL = [];
    List<String> interiorPhotosURL = [];

    try {
      for (int i = 0; i < housePhotos.length; i++) {
        final File file = housePhotos[i];
        String fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
        final reference = storageRef.child('FeedsImage/$fileName');
        final UploadTask uploadTask = reference.putFile(file);
        await uploadTask.whenComplete(() async {
        print('Tải tệp $fileName lên Firebase Storage thành công.');
          final String downloadURL = await reference.getDownloadURL();
          housePhotosURL.add(downloadURL);
        });
      }

      for (int i = 0; i < interiorPhotos.length; i++) {
        final File file = interiorPhotos[i];
        String fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
        final reference = storageRef.child('FeedsImage/$fileName');
        final UploadTask uploadTask = reference.putFile(file);
        await uploadTask.whenComplete(() async {
        print('Tải tệp $fileName lên Firebase Storage thành công.');
          final String downloadURL = await reference.getDownloadURL();
          interiorPhotosURL.add(downloadURL);
        });
      }

      if(housePhotosURL.isNotEmpty || interiorPhotosURL.isNotEmpty){
        String docID = docRef.id.toString();
        await docRef.set({
          "maNha": docID,
          "owner": ownerID,
          "renter": renterID,
          "tenNha": tenNha,
          "price": price,
          "rooms": rooms,
          "floors": floors,
          "favorite": [],
          "housePhotos": housePhotosURL,
          "interiorPhotos": interiorPhotosURL,
          "furniture": furniture,
          "latitude": latitude,
          "longitude": longitude,
          "province": province,
          "district": district,
          "ward": ward,
          "desc": desc,
          "postTime": timestamp.toString(),
        });

        await docUserRef.update({
          "type": "Owner",
        });

        DetailAPI().handleNotification(docID, 'admin', ownerID, 'bài viết của bạn đã được tạo bời hệ thống', 'noti');
      }
    } catch(e) {
      print("Lỗi ${e}");
    }
  }

  void updatePost(
    String docID,
    String ownerID,
    String renterID,
    String tenNha,
    int price,
    String rooms,
    String floors,
    String latitude,
    String longitude,
    List<dynamic> furniture,
    List<File> housePhotos,
    List<File> interiorPhotos,
    List<dynamic> houseImagesURL,
    List<dynamic> furnitureImagesURL,
    String province,
    String district,
    String ward,
    String desc,
  ) async {
    final docRef = feedRef.doc(docID);
    List<String> housePhotosURL = [];
    List<String> interiorPhotosURL = [];
    bool isNewHousePhotos = houseImagesURL.isEmpty;
    bool isNewinteriorPhotos = furnitureImagesURL.isEmpty;

    try {
      if(isNewHousePhotos) {
        for (int i = 0; i < housePhotos.length; i++) {
          final File file = housePhotos[i];
          String fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
          final reference = storageRef.child('FeedsImage/$fileName');
          final UploadTask uploadTask = reference.putFile(file);
          await uploadTask.whenComplete(() async {
          print('Tải tệp $fileName lên Firebase Storage thành công.');
            final String downloadURL = await reference.getDownloadURL();
            housePhotosURL.add(downloadURL);
          });
        }
      }

      if(isNewinteriorPhotos) {
        for (int i = 0; i < interiorPhotos.length; i++) {
          final File file = interiorPhotos[i];
          String fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
          final reference = storageRef.child('FeedsImage/$fileName');
          final UploadTask uploadTask = reference.putFile(file);
          await uploadTask.whenComplete(() async {
          print('Tải tệp $fileName lên Firebase Storage thành công.');
            final String downloadURL = await reference.getDownloadURL();
            interiorPhotosURL.add(downloadURL);
          });
        }
      }
        await docRef.update({
          "renter": renterID,
          "tenNha": tenNha,
          "price": price,
          "rooms": rooms,
          "floors": floors,
          "housePhotos": isNewHousePhotos ? housePhotosURL : houseImagesURL,
          "interiorPhotos": isNewinteriorPhotos ? interiorPhotosURL : furnitureImagesURL,
          "furniture": furniture,
          "latitude": latitude,
          "longitude": longitude,
          "province": province,
          "district": district,
          "ward": ward,
          "desc": desc,
        });

        if(renterID.isEmpty) {
          DetailAPI().handleNotification(docID, 'admin', ownerID, 'bài viết của bạn đã được cập nhật bời hệ thống', 'noti');
        } else {
          DetailAPI().handleNotification(docID, 'admin', ownerID, 'bài viết của bạn đã được cập nhật bời hệ thống', 'noti');
          DetailAPI().handleNotification(docID, 'admin', renterID, 'bài viết về căn hộ bạn thuê đã được cập nhật bời hệ thống', 'noti');
        }
        
    } catch(e) {
      print("error ${e}");
    }
  }
}