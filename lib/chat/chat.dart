import 'package:flutter/material.dart';
import 'package:home_rent/chat/api/firebaseAPI.dart';
import 'package:home_rent/chat/chatRoom/chatRoom.dart';
import 'package:home_rent/helper_function/function.dart';

class Chat extends StatefulWidget {
  const Chat({super.key, required this.currentUser});
  final String currentUser;

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
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
          title: Text('Messeger', style: TextStyle(fontWeight: FontWeight.bold),)
        ),
      body: SafeArea(
          child: StreamBuilder(
              stream: ChatAPI().getData(widget.currentUser),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Lỗi: ${snapshot.error}'),
                  );
                } else {
                  final datas = snapshot.data!;
                  if (datas.length == 0) {
                    return Center(
                      child: Text('Chưa có đối tượng Chat...'),
                    );
                  } else {
                    return ListView.builder(
                        shrinkWrap: true,
                        reverse: true,
                        itemCount: datas.length,
                        itemBuilder: (BuildContext context, int index) {
                          Size screenSize = MediaQuery.of(context).size;
                          final item = datas[index];
                          List reader = item['lastmesseges']['reader'];
                          bool isRead = reader.contains(widget.currentUser);
                          bool sendbyMe = item['lastmesseges']['sendby'] == widget.currentUser;
                          if(item['lastmesseges']['messege'] != '')
                          {
                            return InkWell(
                            onTap: () {
                              Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ChatRoom(
                                          currentUser: widget.currentUser,
                                          partnerUser: item['userID'],
                                          partnerUserAvatar: item['avatar'],
                                          partnerUserName: item['name'],
                                          partnerUserType: item['userType'],
                                      ),
                                    ));
                            },
                            child: Container(
                              margin: EdgeInsets.all(10),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: CircleAvatar(
                                      backgroundImage:
                                          NetworkImage(item['avatar']),
                                      backgroundColor: Colors.blueGrey.shade100,
                                    ),
                                  ),
                                  SizedBox(width: 10,),
                                  Expanded(
                                    flex: 9,
                                    child: Container(
                                      padding: EdgeInsets.only(bottom: 5, top: 5),
                                      decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1, color: Colors.black12))),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(item['name'], style: TextStyle(
                                                // color: isRead ? Colors.black38 : Colors.black,
                                                fontWeight: isRead ? FontWeight.normal : FontWeight.bold,
                                                fontSize: 18,
                                              ),),
                                              Container(
                                                width: screenSize.width * 0.5,
                                                child: item['lastmesseges']['type'] == 'Text'
                                                ? Text(sendbyMe ? "Bạn: ${item['lastmesseges']['messege']}" : item['lastmesseges']['messege'],
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      color: isRead ? Colors.black38 : Colors.black,
                                                      fontWeight: isRead ? FontWeight.normal : FontWeight.bold,
                                                    )
                                                  )
                                                : Text(sendbyMe ? "Bạn: Đã gửi một ảnh" : 'Đã gửi một ảnh',
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      color: isRead ? Colors.black38 : Colors.black,
                                                      fontWeight: isRead ? FontWeight.normal : FontWeight.bold,
                                                    )
                                                  )
                                              )
                                            ],
                                          ),
                                          Text(Helper_Fuction().formatTimestamp(item['lastmesseges']['postTime']), style: TextStyle(
                                                color: isRead ? Colors.black38 : Colors.black,
                                                fontWeight: isRead ? FontWeight.bold : FontWeight.normal,
                                              ),)
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                          } else {
                            return Container();
                          }
                        });
                  }
                }
              })),
    );
  }
}
