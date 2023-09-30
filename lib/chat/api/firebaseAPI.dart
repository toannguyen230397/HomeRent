import 'package:cloud_firestore/cloud_firestore.dart';

class ChatAPI {
  CollectionReference chatRef = FirebaseFirestore.instance
      .collection('Chats'); //Chỉ mục tới Collection Chats
  
  CollectionReference usersRef = FirebaseFirestore.instance
      .collection('Users'); //Chỉ mục tới Collection Users

  Stream<List<Map<String, dynamic>>> getData(String currentUser) {
  return chatRef
      .where('members', arrayContains: currentUser)
      .snapshots()
      .asyncMap((QuerySnapshot querySnapshot) async {
    List<Map<String, dynamic>> dataList = [];
    await Future.forEach(querySnapshot.docs, (doc) async {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      List<String> members = List<String>.from(data['members']);
      String otherUserID = members.firstWhere((member) => member != currentUser);

      DocumentSnapshot documentSnapshot = await usersRef.doc(otherUserID).get();
      if (documentSnapshot.exists) {
        data['userID'] = otherUserID;
        data['userType'] = documentSnapshot['type'];
        data['avatar'] = documentSnapshot['avatar'];
        data['name'] = documentSnapshot['name'];
      }
      dataList.add(data);
    });
    if (dataList.isNotEmpty) {
      // dataList.sort((a,b) {
      //   var aTimeStamp = a['lastmesseges']['postTime'];
      //   var bTimeStamp = b['lastmesseges']['postTime'];
      //   return aTimeStamp.compareTo(bTimeStamp);
      // });
      return dataList;
    } else {
      return [];
    }
  });
}

}
