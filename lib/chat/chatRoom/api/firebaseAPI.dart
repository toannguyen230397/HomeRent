import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class ChatRoomAPI {
  CollectionReference chatRef = FirebaseFirestore.instance
      .collection('Chats'); //Chỉ mục tới Collection Chats
  
  final storageRef = FirebaseStorage.instance.ref();

  //API dùng để tạo ID cho chat room
  void createChatRoom(
      String chatRoomID, String currentUser, String partnerUser) async {
    final snapshot = await chatRef.doc(chatRoomID).get();
    if (snapshot.exists) {
      print('Chatroom is exists');
    } else {
      await chatRef.doc(chatRoomID).set({
        "chatRoomID": chatRoomID,
        "members": [currentUser, partnerUser],
        "online": [currentUser],
        "lastmesseges": {
          "messege": "",
          "postime": 0,
          "reader": [currentUser, partnerUser],
          "sendby": "",
          "type": "",
        },
        "messeges": [],
      });
    }
  }

  //API dùng để lấy dữ liệu tin nhắn realtime
  Stream<Map<String, dynamic>> getData(String docID, String currentUser) {
    addUserIDToReaded(docID, currentUser);
    return chatRef.doc(docID).snapshots().map((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        return documentSnapshot.data() as Map<String, dynamic>;
      } else {
        throw Exception("Document does not exist");
      }
    });
  }

  void handleOnline(String chatRoomID, String appState, String currentUser) async {
    final snapshot = await chatRef.doc(chatRoomID).get();
    if(snapshot.exists)
    {
      if(appState == 'active')
      {
        await chatRef.doc(chatRoomID).update({
          'online': FieldValue.arrayUnion([currentUser])
        });
      }
      else
      {
        await chatRef.doc(chatRoomID).update({
          'online': FieldValue.arrayRemove([currentUser])
        });
      }
    }
    else
    {
      print('Chưa có dữ liệu phòng chat để cập nhật online cho user');
    }
  }

  void handlerMessege (String chatRoomID, String currentUser, String messege, String type, List<dynamic> reader) async {
    int timestamp = DateTime.now().millisecondsSinceEpoch;

    Map<String, dynamic> newMessage = {
      "sendby": currentUser,
      "messege": messege,
      "postTime": timestamp,
      "type": type,
      "reader": reader,
    };

    await chatRef.doc(chatRoomID).update({'messeges': FieldValue.arrayUnion([newMessage])});
    await chatRef.doc(chatRoomID).update({'lastmesseges': newMessage});
  }

  void addUserIDToReaded(String docID, String userID) async {
    final snapshot = await chatRef.doc(docID).get();

    if (snapshot.exists) {
      final Map<String, dynamic> datas = snapshot.data() as Map<String, dynamic>;
      List<dynamic> messeges = datas['messeges'];
      Map<String, dynamic> lastmesseges = datas['lastmesseges'];
      messeges = messeges.map((messeges) {
        if (!messeges['reader'].contains(userID)) {
          messeges['reader'].add(userID);
        }
        return messeges;
      }).toList();

      if(lastmesseges.isNotEmpty)
      {
        if (!lastmesseges['reader'].contains(userID)) {
          lastmesseges['reader'].add(userID);
        }
      }

      await chatRef.doc(docID).update({'messeges': messeges});
      await chatRef.doc(docID).update({'lastmesseges': lastmesseges});
    }
  }

  //upload File lên storage và gửi tin nhắn hình ảnh
  void sendImageMessege(File image, String chatRoomID, String currentUser, List<dynamic> reader) async {
    String fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
    try {
      final reference = storageRef.child('ChatImages/$fileName');
      final UploadTask uploadTask = reference.putFile(image);
      await uploadTask.whenComplete(() async {
        print('Tải tệp $fileName lên Firebase Storage thành công.');
        final String downloadURL = await reference.getDownloadURL();
        handlerMessege(chatRoomID, currentUser, downloadURL, 'Image', reader);
      });
    } catch (e) {
      print('Lỗi khi tải tệp $fileName lên Firebase Storage: $e');
    }
  }

//   Stream<List<Map<String, dynamic>>> Test(String currentUser) {
//   return chatRef
//       .where('member', arrayContains: currentUser)
//       .snapshots()
//       .map((QuerySnapshot querySnapshot) {
//     List<Map<String, dynamic>> data = [];
//     querySnapshot.docs.forEach((QueryDocumentSnapshot documentSnapshot) {
//       data.add(documentSnapshot.data() as Map<String, dynamic>);
//     });

//     if (data.isNotEmpty) {
//       return data;
//     } else {
//       throw Exception("Document does not exist");
//     }
//   });
// }
}
