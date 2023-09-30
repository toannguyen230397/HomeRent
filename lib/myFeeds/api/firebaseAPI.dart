import 'package:cloud_firestore/cloud_firestore.dart';

class myFeedsAPI {
   CollectionReference feedsRef = FirebaseFirestore.instance
      .collection('Feeds'); //Chỉ mục tới Collection Feeds
  
    CollectionReference usersRef = FirebaseFirestore.instance
      .collection('Users'); //Chỉ mục tới Collection Users

  Future<List<Map<String, dynamic>>> getData(String currentUser) async {
    final snapshot = await feedsRef.where('owner', isEqualTo: currentUser).get();
    final responseData = await Future.wait(snapshot.docs.map((doc) async {
      final data = doc.data() as Map<String, dynamic>;
      return data;
    }).toList());
    return responseData;
  }
}