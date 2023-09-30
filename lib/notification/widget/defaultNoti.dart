import 'package:flutter/material.dart';
import 'package:home_rent/chat/chatRoom/chatRoom.dart';
import 'package:home_rent/detail/detail.dart';
import 'package:home_rent/helper_function/function.dart';

class DefaultNoti extends StatelessWidget {
  const DefaultNoti({super.key, required this.datas});
  final Map<String, dynamic> datas;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        NewWidget(datas: datas, type: 'Người gửi:  '),
        Container(
          margin: EdgeInsets.only(bottom: 10),
          child: Row(
            children: [
              Expanded(
                  flex: 3,
                  child: Text('Liên lạc:  ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ))),
              Expanded(
                flex: 5,
                child: Row(
                  children: [
                    Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: Colors.blueGrey.shade100,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: IconButton(
                          onPressed: () {
                            Helper_Fuction()
                                .makePhoneCall(datas['phoneNumber']);
                          },
                          icon: Icon(
                            Icons.phone,
                            size: 15,
                            color: Colors.teal.shade300,
                          )),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: Colors.blueGrey.shade100,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: IconButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChatRoom(
                                    currentUser: datas['sendto'],
                                    partnerUser: datas['userID'],
                                    partnerUserAvatar: datas['avatar'],
                                    partnerUserName: datas['name'],
                                    partnerUserType: datas['userType'],
                                  ),
                                ));
                          },
                          icon: Icon(
                            Icons.message,
                            size: 15,
                            color: Colors.teal.shade300,
                          )),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        NewWidget(datas: datas, type: 'Nội dung:  '),
        datas['type'] != 'createRequest'
            ? NewWidget(datas: datas, type: 'Mã nhà:  ')
            : Container(),
        NewWidget(datas: datas, type: 'Vào lúc:  '),
      ],
    );
  }
}

class NewWidget extends StatelessWidget {
  const NewWidget({
    super.key,
    required this.datas,
    required this.type,
  });

  final Map<String, dynamic> datas;
  final String type;

  @override
  Widget build(BuildContext context) {
    String content() {
      if (type == 'Người gửi:  ') {
        return datas['name'];
      } else if (type == 'Nội dung:  ') {
        return datas['content'];
      } else if (type == 'Mã nhà:  ') {
        return datas['maNha'];
      } else if (type == 'Vào lúc:  ') {
        return Helper_Fuction().formatTimestamp(datas['postTime']);
      } else {
        return '';
      }
    }

    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              type,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          Expanded(
              flex: 5,
              child: type == 'Mã nhà:  '
                  ? InkWell(
                      onTap: () {
                        if (datas.containsKey('feedsData')) {
                          Navigator.of(context).pop();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Detail(
                                    datas: datas['feedsData'],
                                    currentUser: datas['sendto']),
                              ));
                        } else {
                          Navigator.of(context).pop();
                          Helper_Fuction().showToastMessege(
                              'Bài viết không tồn tại, có thể đã được xóa bởi hệ thống');
                        }
                      },
                      child: Text(
                        content(),
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      ))
                  : Text(content())),
        ],
      ),
    );
  }
}
