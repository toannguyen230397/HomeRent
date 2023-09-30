import 'dart:io';

import 'package:flutter/material.dart';
import 'package:home_rent/chat/chatRoom/api/firebaseAPI.dart';
import 'package:home_rent/chat/chatRoom/widget/messegeList.dart';
import 'package:home_rent/helper_function/function.dart';
import 'package:image_picker/image_picker.dart';

class ChatRoom extends StatefulWidget {
  const ChatRoom(
      {super.key,
      required this.currentUser,
      required this.partnerUser,
      required this.partnerUserAvatar,
      required this.partnerUserName,
      required this.partnerUserType});
  final String currentUser;
  final String partnerUser;
  final String partnerUserAvatar;
  final String partnerUserName;
  final String partnerUserType;

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> with WidgetsBindingObserver {
  TextEditingController messegeInput = TextEditingController();
  File? imageSelected;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    handleCreateChatRoom();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    String chatRoomID =
        Helper_Fuction().createChatRoomId(widget.currentUser, widget.partnerUser);
    print(state);
    if (state == AppLifecycleState.resumed) {
      ChatRoomAPI().handleOnline(chatRoomID, 'active', widget.currentUser);
    } else {
      ChatRoomAPI().handleOnline(chatRoomID, '!active', widget.currentUser);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void handleCreateChatRoom() {
    String chatRoomID =
        Helper_Fuction().createChatRoomId(widget.currentUser, widget.partnerUser);
    ChatRoomAPI()
        .createChatRoom(chatRoomID, widget.currentUser, widget.partnerUser);
    ChatRoomAPI().handleOnline(chatRoomID, 'active', widget.currentUser);
  }

  void handleSendImage(String chatRoomID, String currentUser, List<dynamic> reader) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        imageSelected = File(image.path);
      });
    }

    if(imageSelected != null) {
      ChatRoomAPI().sendImageMessege(imageSelected!, chatRoomID, currentUser, reader);
    }
  }

  void ButtomPress(String chatRoomID, String currentUser, String messege, List<dynamic> reader) {
    if (messegeInput.text.trim().length > 0) {
      ChatRoomAPI()
          .handlerMessege(chatRoomID, currentUser, messege, 'Text', reader);
      messegeInput.clear();
    }
    FocusManager.instance.primaryFocus?.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    String chatRoomID =
        Helper_Fuction().createChatRoomId(widget.currentUser, widget.partnerUser);
    return WillPopScope(
      onWillPop: () async {
        ChatRoomAPI().handleOnline(chatRoomID, '!active', widget.currentUser);
        return true;
      },
      child: Scaffold(
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
          title: Container(
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(widget.partnerUserAvatar),
                  backgroundColor: Colors.blueGrey.shade100,
                ),
                SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.partnerUserName,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(widget.partnerUserType,
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.black45,
                        ))
                  ],
                ),
              ],
            ),
          ),
        ),
        body: SafeArea(
            child: StreamBuilder(
                stream: ChatRoomAPI().getData(chatRoomID, widget.currentUser),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    print('Lỗi: ${snapshot.error}');
                    return Container();
                  } else {
                    final data = snapshot.data!;
                    List datas = data['messeges'];
                    datas = datas.reversed.toList();
                    return Column(
                      children: [
                        Expanded(
                          child: MessegeList(datas: datas, currentUser: widget.currentUser, partnerUser: widget.partnerUser)
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border(
                              top: BorderSide(
                                color: Colors.black26,
                                width: 1,
                              ),
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 9,
                                child: TextField(
                                  controller: messegeInput,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    prefixIcon: IconButton(
                                      onPressed: () {
                                        handleSendImage(
                                          chatRoomID,
                                          widget.currentUser,
                                          data['online']
                                        );
                                      },
                                      icon: Icon(Icons.photo),
                                    ),
                                    hintText: 'Nhập tin nhắn...',
                                  ),
                                ),
                              ),
                              Expanded(
                                  flex: 1,
                                  child: IconButton(
                                    onPressed: () {
                                      ButtomPress(
                                          chatRoomID,
                                          widget.currentUser,
                                          messegeInput.text,
                                          data['online']);
                                    },
                                    icon: Icon(
                                      Icons.send,
                                      color: Colors.teal.shade300,
                                    ),
                                  ))
                            ],
                          ),
                        )
                      ],
                    );
                  }
                })),
      ),
    );
  }
}
