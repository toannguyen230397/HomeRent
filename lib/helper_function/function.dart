import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class Helper_Fuction {
  //định dạng timestamp
  String formatTimestamp(int timestamp) {
    final currentTime = DateTime.now();
    final timeDifference = currentTime.millisecondsSinceEpoch - timestamp;

    // Tính toán số lượng ngày chênh lệch
    final daysDifference = (timeDifference ~/ (1000 * 60 * 60 * 24)).floor();

    if (daysDifference >= 7) {
      // Nếu hơn một tuần, hiển thị ngày tháng dạng dd-mm-yy
      final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
      final day = date.day < 10 ? '0${date.day}' : date.day.toString();
      final month = date.month < 10 ? '0${date.month}' : date.month.toString();
      final year = date.year.toString().substring(2);

      final formattedDate = '$day/$month/$year';
      return formattedDate;
    } else if (daysDifference > 0) {
      // Hiển thị x ngày trước
      return '$daysDifference ngày trước';
    } else {
      // Tính toán số lượng giờ chênh lệch
      final hoursDifference = (timeDifference ~/ (1000 * 60 * 60)).floor();

      if (hoursDifference > 0) {
        // Hiển thị x tiếng trước
        return '$hoursDifference tiếng trước';
      } else {
        // Tính toán số lượng phút chênh lệch
        final minutesDifference = (timeDifference ~/ (1000 * 60)).floor();

        if (minutesDifference > 0) {
          // Hiển thị x phút trước
          return '$minutesDifference phút trước';
        } else {
          // Hiển thị "mới đây"
          return 'mới đây';
        }
      }
    }
  }

  //tạo id cho chat room
  String createChatRoomId(String currentUser, String partnerUser) {
    List<String> userIds = [currentUser, partnerUser];

    userIds.sort();

    String chatRoomId = userIds.join('_');

    print(chatRoomId);
    return chatRoomId;
  }

  //hàm mở google map bằng trình duyệt
  Future<void> launchGoogleMap(
      String latitude, String longitude, String label) async {
    final Uri _url = Uri.parse(
        "https://www.google.com/maps/search/?api=1&query=$latitude,$longitude&query_place_id=$label");
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  //hàm mở chức năng gọi điện kèm sđt của đối phương
  Future<void> makePhoneCall(String phoneNumber) async {
    final Uri _url = Uri.parse("tel:$phoneNumber");
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  //Hàm này hiển thị tin nhắn thông báo lên màn hình
  void showToastMessege(String messege) {
    Fluttertoast.showToast(
      msg: messege,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.CENTER,
      backgroundColor: Colors.teal.shade300,
    );
  }

  //Hàm này cho phép lấy 1 hình trong thư viện
  Future<void> pickerImage(File? imageSelected) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      imageSelected = File(image.path);
    }
  }

  //Hàm này cho phép lấy nhiều hình trong thư viện
  void pickerMultiImages(List<File> selectedImages) async {
    final ImagePicker picker = ImagePicker();
    final List<XFile> images = await picker.pickMultiImage();
    if (images.isNotEmpty) {
      for (var i = 0; i < images.length; i++) {
        selectedImages.add(File(images[i].path));
      }
    }
  }
}
