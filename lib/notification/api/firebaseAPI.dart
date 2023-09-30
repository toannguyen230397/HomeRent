import 'package:cloud_firestore/cloud_firestore.dart';

class NotiAPI {
  CollectionReference usersRef = FirebaseFirestore.instance
      .collection('Users'); //Chỉ mục tới Collection Users

  CollectionReference feedsRef = FirebaseFirestore.instance
      .collection('Feeds'); //Chỉ mục tới Collection Feeds

  // Future<List<Map<String, dynamic>>> fetchData(List nonReadNoti, String currentUser) async {
  //   final snapshot = await usersRef.doc(currentUser).collection('notification').get();
  //   final responseData = await Future.wait(snapshot.docs.map((doc) async {
  //     final data = doc.data() as Map<String, dynamic>;
  //     final sendby = data['sendby'];
  //     DocumentSnapshot documentSnapshot = await usersRef.doc(sendby).get();
  //     if (documentSnapshot.exists) {
  //       data['userID'] = documentSnapshot['uid'];
  //       data['userType'] = documentSnapshot['type'];
  //       data['avatar'] = documentSnapshot['avatar'];
  //       data['name'] = documentSnapshot['name'];
  //     }
  //     return data;
  //   }).toList());
  //   updateSeenNoti(nonReadNoti, currentUser);
  //   print(responseData);
  //   return responseData;
  // }

  Stream<List<Map<String, dynamic>>> getData(String currentUser) async* {
    final snapshot =
        await usersRef.doc(currentUser).collection('notification').get();
    if (snapshot.docs.isNotEmpty) {
      final List<Map<String, dynamic>> responseData = snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
      final List<String> notiID =
          responseData.map((data) => data['notiID'] as String).toList();

      yield* usersRef
          .doc(currentUser)
          .collection('notification')
          .where('notiID', whereIn: notiID)
          .snapshots()
          .asyncMap((QuerySnapshot querySnapshot) async {
        List<Map<String, dynamic>> dataList = [];
        await Future.forEach(querySnapshot.docs, (doc) async {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          String sendby = data['sendby'];
          String maNha = data['maNha'];

          if(maNha != ''){
            DocumentSnapshot feedSnapshot = await feedsRef.doc(maNha).get();
            if (feedSnapshot.exists) {
              data['feedsData'] = feedSnapshot.data() as Map<String, dynamic>;
            }
          }

          DocumentSnapshot userSnapshot = await usersRef.doc(sendby).get();
          if (userSnapshot.exists) {
            data['userID'] = userSnapshot['uid'];
            data['userType'] = userSnapshot['type'];
            data['avatar'] = userSnapshot['avatar'];
            data['name'] = userSnapshot['name'];
            if(sendby != 'admin') {
              data['phoneNumber'] = userSnapshot['phoneNumber'];
            }
          }
          dataList.add(data);
        });
        if (dataList.isNotEmpty) {
          dataList.sort((a,b) {
            var aTimeStamp = a['postTime'];
            var bTimeStamp = b['postTime'];
            return aTimeStamp.compareTo(bTimeStamp);
          });
          return dataList;
        } else {
          return [];
        }
      });
    }
  }

  void updateNewNoti(List newNoti, String currentUser) async {
    for (String notiID in newNoti) {
      await usersRef
          .doc(currentUser)
          .collection('notification')
          .doc(notiID)
          .update({
        'new': false,
      });
    }
  }

  void updateReadNoti(String notiID, String currentUser) async {
    await usersRef
        .doc(currentUser)
        .collection('notification')
        .doc(notiID)
        .update({
      'readed': true,
    });
  }

  void deleteNoti(String notiID, String currentUser) async {
    await usersRef
        .doc(currentUser)
        .collection('notification')
        .doc(notiID)
        .delete();
  }

  Future<Map<String, dynamic>> detailData(
      String notiID, String currentUser) async {
    final snapshot = await usersRef
        .doc(currentUser)
        .collection('notification')
        .doc(notiID)
        .get();
    final Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    if (data.isNotEmpty) {
      final maNha = data['maNha'];
      final sendby = data['sendby'];
      DocumentSnapshot documentSnapshot = await feedsRef.doc(maNha).get();
      if (documentSnapshot.exists) {
        data['feedsData'] = documentSnapshot;
      }
      DocumentSnapshot documentSnapshot2 = await usersRef.doc(sendby).get();
      if (documentSnapshot.exists) {
        data['phoneNumber'] = documentSnapshot2['phoneNumber'];
        data['uid'] = documentSnapshot2['uid'];
      }
    }
    return data;
  }

  void updateFeed(String notiID, String currentUser) async {
    await feedsRef
          .doc(notiID)
          .update({
          'renter': currentUser,
          });
  }
}
