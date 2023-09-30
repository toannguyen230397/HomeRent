import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:home_rent/helper_function/function.dart';

class LoginRegisterAPI {
  CollectionReference useRef = FirebaseFirestore.instance.collection('Users');
  final storageRef = FirebaseStorage.instance.ref();

  void handleRegister(String email, String name, String password, File avatar, String phoneNumber, Function handleLoading, Function handleCompleteLoading) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password
      );

      final user = userCredential.user;
      String fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
      String imageURL = '';

      final reference = storageRef.child('UsersAvatar/$fileName');
      final UploadTask uploadTask = reference.putFile(avatar);
      await uploadTask.whenComplete(() async {
        print('Tải tệp $fileName lên Firebase Storage thành công.');
        final String downloadURL = await reference.getDownloadURL();
        imageURL = downloadURL;
      });

      await useRef.doc(user?.uid).set({
        "uid": user?.uid,
        "email": email,
        "name": name,
        "phoneNumber": phoneNumber,
        "avatar": imageURL,
        "type": "Renter",
      });
      handleCompleteLoading();
      Helper_Fuction().showToastMessege('Đăng ký thành công!');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        Helper_Fuction().showToastMessege('Mật khẩu quá yếu');
      } else if (e.code == 'email-already-in-use') {
        Helper_Fuction().showToastMessege('Email này đã có người đăng ký trước đó');
      } else if (e.code == 'invalid-email') {
        Helper_Fuction().showToastMessege('Email này không hợp lệ');
      }
      handleLoading();
    }
  }
  
  void handleLogin(String email, String password, Function gotoHomeScreen, Function handleLoading) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password
      );
      final user = userCredential.user;
      String userID = user!.uid;
      String userEmail = user.email.toString();
      print(userEmail);
      if(userID.isNotEmpty){
        final snapshot = await useRef.doc(email == 'admin@gmail.com' ? 'admin' : userID).get();
        if(snapshot.exists) {
          final Map<String, dynamic> responseData = snapshot.data() as Map<String, dynamic>;
          String currentUser = responseData['uid'];
          String currentUserType = responseData['type'];
          gotoHomeScreen(currentUser, currentUserType);
          print('User is loggin');
        }
      }
      handleLoading();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        Helper_Fuction().showToastMessege('Email này chưa được đăng ký');
      } else if (e.code == 'wrong-password') {
        Helper_Fuction().showToastMessege('Sai mật khẩu');
      } else if (e.code == 'invalid-email') {
        Helper_Fuction().showToastMessege('Email không hợp lệ');
      }
      handleLoading();
    }
  }

  void handleLogout() async {
    await FirebaseAuth.instance.signOut();
    print('User is loggout');
  }

  void autoLogin(Function gotoHomeScreen) async {
    try{
      final user = FirebaseAuth.instance.currentUser;
      if(user != null) {
        String userID = user.uid;
        String userEmail = user.email.toString();
        print(userEmail);
        final snapshot = await useRef.doc(userEmail == 'admin@gmail.com' ? 'admin' : userID).get();
          if(snapshot.exists) {
            final Map<String, dynamic> responseData = snapshot.data() as Map<String, dynamic>;
            String currentUser = responseData['uid'];
            String currentUserType = responseData['type'];
            gotoHomeScreen(currentUser, currentUserType);
            print('User is loggin');
          }
      }
    } catch (e) {
      print('Auto-login failed: $e');
    }
  }
}