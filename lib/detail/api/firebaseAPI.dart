import 'package:cloud_firestore/cloud_firestore.dart';

class DetailAPI {
  CollectionReference usersRef = FirebaseFirestore.instance
      .collection('Users'); //Chỉ mục tới Collection Users
  CollectionReference feedsRef = FirebaseFirestore.instance
      .collection('Feeds'); //Chỉ mục tới Collection Users

  //API dùng để lấy thông tin của tất cả user
  Future<List<Map<String, dynamic>>> fetchData() async {
    final snapshot = await usersRef.get();
    final List<Map<String, dynamic>> responseData =
        snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    return responseData;
  }

  //API dùng để lấy thông tin của user theo id
  Future<Map<String, dynamic>> getUserData(String userID) async {
    final snapshot = await usersRef.doc(userID).get();
    final Map<String, dynamic> responseData = snapshot.data() as Map<String, dynamic>;
    return responseData;
  }

  //API dùng để lấy thông tin chi tiết của bài đăng
  Future<Map<String, dynamic>> getData(String docID) async {
    final snapshot = await feedsRef.doc(docID).get();
    final Map<String, dynamic> responseData = snapshot.data() as Map<String, dynamic>;
    return responseData;
  }

  void handleFavorite(String feedID, bool isFavorite, String currentUser) async {
    final snapshot = await feedsRef.doc(feedID).get();
    if(snapshot.exists)
    {
      if(!isFavorite)
      {
        await feedsRef.doc(feedID).update({
          'favorite': FieldValue.arrayUnion([currentUser])
        });
      }
      else if(isFavorite)
      {
        await feedsRef.doc(feedID).update({
          'favorite': FieldValue.arrayRemove([currentUser])
        });
      }
    }
  }

  void handleNotification(String maNha, String currentUser, String partnerUser, String content, String type) async {
    int timestamp = DateTime.now().millisecondsSinceEpoch;    
    final docRef = usersRef.doc(partnerUser).collection('notification').doc();    
    await docRef.set({
        "notiID": docRef.id,
        "sendby": currentUser,
        "sendto": partnerUser,
        "maNha": maNha,
        "content": content,
        "postTime": timestamp,
        "new": true,
        "readed": false,
        "type": type,
    });
  }

  void handleNotiToCreatePost(String currentUser, String content, String type) async {
    int timestamp = DateTime.now().millisecondsSinceEpoch;    
    final docRef = usersRef.doc('admin').collection('notification').doc();    
    await docRef.set({
        "notiID": docRef.id,
        "sendby": currentUser,
        "sendto": 'admin',
        "content": content,
        "postTime": timestamp,
        "new": true,
        "readed": false,
        "type": type,
    });
  }
  
  void handleDeletePost(String docID, String ownerID, String renterID) async {
    final docRef = feedsRef.doc(docID);
    await docRef.delete();
    DetailAPI().handleNotification(docID, 'admin', ownerID, 'bài viết của bạn đã được xóa bời hệ thống', 'noti');
    if(renterID.isNotEmpty) {
      DetailAPI().handleNotification(docID, 'admin', renterID, 'bài viết về căn hộ bạn thuê đã được xóa bời hệ thống', 'noti');
    }
    print('document is deleted');
  }
}
