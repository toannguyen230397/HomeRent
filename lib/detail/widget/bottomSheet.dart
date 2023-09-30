import 'package:flutter/material.dart';
import 'package:home_rent/createEditPost/createOrEditPost.dart';
import 'package:home_rent/detail/api/firebaseAPI.dart';
import 'package:home_rent/detail/widget/bottoSheetSelect.dart';
import 'package:home_rent/helper_function/function.dart';

class BottomSheetHandle {

   Future<void> showBottomSheet(BuildContext context, Function function, bool isFavorite, String maNha, String currentUser, String partnerUser, String currentUserType, String renter, Map<String, dynamic> datas) {    
    return showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        Size screenSize = MediaQuery.of(context).size;
        return Container(
          width: screenSize.width,
          padding: EdgeInsets.only(top: 30),
          child: currentUserType == 'user'
          ? userBottomSheet(maNha: maNha, currentUser: currentUser, partnerUser: partnerUser, function: function, isFavorite: isFavorite, screenSize: screenSize, renter: renter,)
          : currentUserType == 'owner'
          ? ownerBottomSheet(maNha: maNha, currentUser: currentUser, screenSize: screenSize)
          : currentUserType == 'renter'
          ? renterBottomSheet(maNha: maNha, currentUser: currentUser, screenSize: screenSize)
          : adminBottomSheet(screenSize: screenSize, datas: datas,)
        );
      },
    );
  }
}

class userBottomSheet extends StatelessWidget {
  const userBottomSheet({super.key, required this.maNha, required this.currentUser, required this.partnerUser, required this.function, required this.isFavorite, required this.screenSize, required this.renter});
  final String maNha;
  final String currentUser;
  final String partnerUser;
  final Function function;
  final bool isFavorite;
  final Size screenSize;
  final String renter;

  @override
  Widget build(BuildContext context) {
    void requestBooking() {
       DetailAPI().handleNotification(maNha, currentUser, partnerUser, 'Gửi yêu cầu đặt căn hộ của bạn', 'bookingRequest');
       Helper_Fuction().showToastMessege('Bạn đã gửi yêu cầu đặt căn hộ tới chủ hộ');
       print('Gửi yêu cầu đặt căn hộ');
    }
    return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: () {
                  function();
                  Navigator.of(context).pop();
                },
                child: BottomSheetSelect(screenSize: screenSize, title: isFavorite ? 'Bỏ Lưu bài viết' : 'Lưu bài viết'),
              ),
              renter != ''
              ? Container()
              : InkWell(
                  onTap: () {
                    requestBooking();
                    Navigator.of(context).pop();
                  },
                  child: BottomSheetSelect(screenSize: screenSize, title: 'Gửi yêu cầu đặt nhà tới chủ hộ'),
                )
            ],
          );
  }
}

class ownerBottomSheet extends StatelessWidget {
  const ownerBottomSheet({super.key, required this.maNha, required this.currentUser, required this.screenSize});
  final String maNha;
  final String currentUser;
  final Size screenSize;

  @override
  Widget build(BuildContext context) {
    void requestDelete() {
       DetailAPI().handleNotification(maNha, currentUser, 'admin', 'Yêu cầu bỏ bài viết', 'deleteRequest');
       Helper_Fuction().showToastMessege('Bạn đã gửi yêu cầu xóa bài viết');
       print('Gửi yêu cầu xóa bài viết');
    }

    void requestEdit() {
       DetailAPI().handleNotification(maNha, currentUser, 'admin', 'Yêu cầu chỉnh sửa bài viết', 'editRequest');
       Helper_Fuction().showToastMessege('Bạn đã gửi yêu cầu chỉnh sửa bài viết');
       print('Gửi yêu cầu chỉnh sửa bài viết');
    }
    return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: () {
                  requestDelete();
                  Navigator.of(context).pop();
                },
                child: BottomSheetSelect(screenSize: screenSize, title: 'Gửi yêu cầu bỏ bài viết'),
              ),
              InkWell(
                onTap: () {
                  requestEdit();
                  Navigator.of(context).pop();
                },
                child: BottomSheetSelect(screenSize: screenSize, title: 'Gửi yêu cầu sửa lại thông tin'),
              )
            ],
          );
  }
}

class renterBottomSheet extends StatelessWidget {
  const renterBottomSheet({super.key, required this.screenSize, required this.maNha, required this.currentUser,});
  final Size screenSize;
  final String maNha;
  final String currentUser;

  void requestReport() {
      DetailAPI().handleNotification(maNha, currentUser, 'admin', 'Gửi tố cáo bài viết', 'reportRequest');
      Helper_Fuction().showToastMessege('Bạn đã gửi tố cáo bài viết');
      print('Gửi tố cáo bài viết');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: () {
                  requestReport();
                  Navigator.of(context).pop();
                },
                child: BottomSheetSelect(screenSize: screenSize, title: 'Gửi báo cáo bài viết này'),
              )
            ],
          );
  }
}

class adminBottomSheet extends StatelessWidget {
  const adminBottomSheet({super.key, required this.screenSize, required this.datas});
  final Size screenSize;
  final Map<String, dynamic> datas;

  @override
  Widget build(BuildContext context) {
    return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: () {
                  DetailAPI().handleDeletePost(datas['maNha'], datas['owner'], datas['renter']);
                  Helper_Fuction().showToastMessege('Xóa bài viết thành công');
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                child: BottomSheetSelect(screenSize: screenSize, title: 'Xóa bài viết'),
              ),
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            CreateOrEditPost(ownerID: datas['owner'], datas: datas, title: 'Edit Post'),
                  ));
                },
                child: BottomSheetSelect(screenSize: screenSize, title: 'Sửa thông tin bài viết'),
              )
            ],
          );
  }
}