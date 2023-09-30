import 'package:flutter/material.dart';
import 'package:home_rent/createEditPost/createOrEditPost.dart';
import 'package:home_rent/detail/api/firebaseAPI.dart';
import 'package:home_rent/detail/detail.dart';
import 'package:home_rent/helper_function/function.dart';
import 'package:home_rent/notification/api/firebaseAPI.dart';
import 'package:home_rent/notification/widget/defaultNoti.dart';

class Noti extends StatefulWidget {
  const Noti({super.key, required this.newNoti, required this.currentUser});
  final List<dynamic> newNoti;
  final String currentUser;

  @override
  State<Noti> createState() => _NotiState();
}

class _NotiState extends State<Noti> {
  void handleUpdateNoti() {
    if (widget.newNoti.isNotEmpty) {
      NotiAPI().updateNewNoti(widget.newNoti, widget.currentUser);
      print('Noti from new to old');
    }
  }

  @override
  void initState() {
    super.initState();
    handleUpdateNoti();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            'Notifucation',
            style: TextStyle(fontWeight: FontWeight.bold),
          )),
      body: SafeArea(
        child: StreamBuilder(
            stream: NotiAPI().getData(widget.currentUser),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                ); // Đang nạp dữ liệu
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Lỗi: ${snapshot.error}'),
                ); // Có lỗi xảy ra
              } else if (!snapshot.hasData) {
                return Center(
                  child: Text('Chưa có thông báo mới!'),
                );
              } else {
                Size screenSize = MediaQuery.of(context).size;
                final data = snapshot.data!;
                return ListView.builder(
                    shrinkWrap: true,
                    reverse: true,
                    itemCount: data.length,
                    itemBuilder: (BuildContext context, int index) {
                      final item = data[index];
                      return InkWell(
                        onLongPress: () {
                          print('long press');
                          dialogDeleteNoti(
                              context, item['notiID'], widget.currentUser);
                        },
                        onTap: () {
                          NotiAPI().updateReadNoti(
                          item['notiID'], widget.currentUser);
                          dialogNoti(context, item);
                        },
                        child: Ink(
                          color: item['readed'] == true
                              ? Colors.white
                              : Colors.blue.shade50,
                          padding: EdgeInsets.all(10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 1,
                                child: CircleAvatar(
                                  backgroundImage: NetworkImage(item['avatar']),
                                  backgroundColor: Colors.blueGrey.shade100,
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                flex: 9,
                                child: Container(
                                  padding: EdgeInsets.only(bottom: 5),
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              width: 1,
                                              color: Colors.black12))),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: screenSize.width * 0.65,
                                            child: Text.rich(
                                              TextSpan(
                                                children: [
                                                  TextSpan(
                                                    text: item['name'],
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text:
                                                        "  ${item['content']}",
                                                  ),
                                                ],
                                              ),
                                              maxLines: 3,
                                            ),
                                          ),
                                          Container(
                                              margin: EdgeInsets.only(top: 5),
                                              child: Text(
                                                Helper_Fuction()
                                                    .formatTimestamp(
                                                        item['postTime']),
                                                style: TextStyle(
                                                    color: Colors.black38),
                                              )),
                                        ],
                                      ),
                                      Container(
                                        width: 50,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          color: Colors.blueGrey.shade50,
                                          borderRadius:
                                              BorderRadius.circular(100),
                                        ),
                                        child: Icon(
                                          Icons.notifications,
                                          size: 30,
                                          color: Colors.teal.shade300,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    });
              }
            }),
      ),
    );
  }
}

//Tạo popup cho noti
Future<void> dialogNoti(BuildContext context, Map<String, dynamic> datas) {
  void handlePress() {
    if (datas['type'] == "bookingRequest") {
      print('xác nhận thuê nhà');
      Navigator.of(context).pop();
      NotiAPI().updateFeed(datas['maNha'], datas['sendby']);
      DetailAPI().handleNotification(datas['maNha'], datas['sendto'], datas['sendby'], 'Đã xác nhận bạn đã thuê căn hộ ${datas['feedsData']['tenNha']}', 'noti');
      NotiAPI().deleteNoti(datas['notiID'], datas['sendto']);
      Helper_Fuction().showToastMessege('Chúc mừng bạn, ${datas['name']} đã trở thành người thuê của căn hộ');
    } else if (datas['type'] == "createRequest") {
      print('chuyển tới trang Create edit post');
      Navigator.of(context).pop();
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                CreateOrEditPost(ownerID: datas['sendby'], datas: {}, title: 'Create Post',),
          ));
    } else {
      if(datas.containsKey('feedsData')) {
        Navigator.of(context).pop();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                Detail(datas: datas['feedsData'], currentUser: datas['sendto']),
          ));
      } else {
        Navigator.of(context).pop();
        Helper_Fuction().showToastMessege('Bài viết không tồn tại, có thể đã được xóa bởi hệ thống');
      }
    }
  }

  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          'Thông báo',
          style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 25),
        ),
        content: DefaultNoti(datas: datas),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            child: Text(datas['type'] != 'noti' ? 'Hủy' : 'Tắt thông báo',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          datas['type'] != 'noti'
              ? TextButton(
                  style: TextButton.styleFrom(
                    textStyle: Theme.of(context).textTheme.labelLarge,
                  ),
                  child: Text('Xác nhận',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  onPressed: () {
                    handlePress();
                  },
                )
              : datas['type'] == 'bookingRequest'
              ? Container()
              : Container()
        ],
      );
    },
  );
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Tạo popup xóa noti
Future<void> dialogDeleteNoti(
    BuildContext context, String notiID, String currentUser) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          'Xóa thông báo',
          style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 25),
        ),
        content: Text(
          'Thông báo này sẽ được xóa, bạn có chắc không?',
        ),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            child: Text('Hủy',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            child: Text('Xác nhận',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            onPressed: () {
              NotiAPI().deleteNoti(notiID, currentUser);
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
