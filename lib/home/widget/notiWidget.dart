import 'package:flutter/material.dart';
import 'package:home_rent/chat/chat.dart';
import 'package:home_rent/home/api/firebaseAPI.dart';
import 'package:home_rent/notification/notification.dart';

class notificationLenghth extends StatefulWidget {
  const notificationLenghth(
      {super.key, required this.currentUser, required this.iconType});
  final String currentUser;
  final String iconType;

  @override
  State<notificationLenghth> createState() => _notificationLenghthState();
}

class _notificationLenghthState extends State<notificationLenghth> {
  @override
  Widget build(BuildContext context) {
    List<dynamic> newNoti = [];
    return IconButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => widget.iconType == 'message'
                    ? Chat(currentUser: widget.currentUser)
                    : Noti(newNoti: newNoti, currentUser: widget.currentUser),
              ));
        },
        icon: Stack(children: <Widget>[
          Icon(
            widget.iconType == 'message' ? Icons.message : Icons.notifications,
            size: 30,
          ),
          StreamBuilder(
              stream: widget.iconType == 'message'
                  ? HomeAPI().getNewMessegesLength(widget.currentUser)
                  : HomeAPI().getNewNotiLength(widget.currentUser),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  print('loading...');
                  return Container();
                } else if (snapshot.hasError) {
                  print('Lỗi: ${snapshot.error}');
                  return Container();
                } else {
                  final data = snapshot.data!;
                  bool hasNewMessege = data.length > 0;
                  int dataLength = data.length;
                  newNoti = data;
                  return Positioned(
                      left: 0.0,
                      top: -5.0,
                      child: hasNewMessege
                          ? Container(
                              padding: EdgeInsets.all(5.0),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.red,
                              ),
                              child: Text(
                                dataLength >= 10 ? 'N' : dataLength.toString(),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                          : Container());
                }
              })
        ]));
  }
}