import 'package:cloud_firestore/cloud_firestore.dart';

class HomeAPI {
  CollectionReference feedsRef = FirebaseFirestore.instance
      .collection('Feeds'); //Chỉ mục tới Collection Feeds
  CollectionReference chatRef = FirebaseFirestore.instance
      .collection('Chats'); //Chỉ mục tới Collection Chats
  CollectionReference usersRef = FirebaseFirestore.instance
      .collection('Users'); //Chỉ mục tới Collection Users

  //API dùng để lấy thông tin của tất cả bài đăng
  Future<List<Map<String, dynamic>>> fetchData() async {
    final snapshot = await feedsRef.get();
    final List<Map<String, dynamic>> responseData =
        snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    return responseData;
  }

  Stream<List<Map<String, dynamic>>> getData(String currentUserType) async* {
    final snapshot = await feedsRef.get();
    if (snapshot.docs.isNotEmpty) {
      final List<Map<String, dynamic>> responseData = snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
      final List<String> docID =
          responseData.map((data) => data['maNha'] as String).toList();

      if (currentUserType == 'admin') {
        yield* feedsRef
            .where('maNha', whereIn: docID)
            .snapshots()
            .map((QuerySnapshot querySnapshot) {
          List<Map<String, dynamic>> dataList = [];
          querySnapshot.docs.forEach((doc) {
            Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
            if (data.isNotEmpty) {
              dataList.add(data);
            }
          });
          if (dataList.isNotEmpty) {
            dataList.sort((a, b) {
              var aTimeStamp = a['postTime'];
              var bTimeStamp = b['postTime'];
              return bTimeStamp.compareTo(aTimeStamp);
            });
            return dataList;
          } else {
            return [];
          }
        });
      } else {
        yield* feedsRef
            .where('maNha', whereIn: docID)
            .where('renter', isEqualTo: '')
            .snapshots()
            .map((QuerySnapshot querySnapshot) {
          List<Map<String, dynamic>> dataList = [];
          querySnapshot.docs.forEach((doc) {
            Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
            if (data.isNotEmpty) {
              dataList.add(data);
            }
          });
          if (dataList.isNotEmpty) {
            dataList.sort((a, b) {
              var aTimeStamp = a['postTime'];
              var bTimeStamp = b['postTime'];
              return bTimeStamp.compareTo(aTimeStamp);
            });
            return dataList;
          } else {
            return [];
          }
        });
      }
    }
  }

  Stream<List<dynamic>> getNewMessegesLength(String currentUser) {
    return chatRef
        .where('members', arrayContains: currentUser)
        .snapshots()
        .map((QuerySnapshot querySnapshot) {
      List<dynamic> newMessegeList = [];
      querySnapshot.docs.forEach((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        List<dynamic> reader =
            List<dynamic>.from(data['lastmesseges']['reader']);

        if (!reader.contains(currentUser)) {
          newMessegeList.add(currentUser);
        }
      });
      print(newMessegeList.length);
      return newMessegeList;
    });
  }

  Stream<List<dynamic>> getNewNotiLength(String currentUser) {
    return usersRef
        .doc(currentUser)
        .collection('notification')
        .where('new', isEqualTo: true)
        .snapshots()
        .map((QuerySnapshot querySnapshot) {
      List<String> newNotiList = [];
      querySnapshot.docs.forEach((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        if (data.isNotEmpty) {
          newNotiList.add(data['notiID']);
        }
      });
      print(newNotiList.length);
      return newNotiList;
    });
  }
}
