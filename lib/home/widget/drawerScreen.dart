import 'package:flutter/material.dart';
import 'package:home_rent/detail/api/firebaseAPI.dart';
import 'package:home_rent/helper_function/function.dart';
import 'package:home_rent/loginRegister/loginOrRegister.dart';
import 'package:home_rent/loginRegister/api/firebaseAPI.dart';

class drawerScreen extends StatelessWidget {
  const drawerScreen({
    super.key,
    required this.currentUser,
    required this.title,
    required this.icon,
    required this.screenToNavigate,
  });

  final String currentUser;
  final String title;
  final Widget screenToNavigate;
  final Icon icon;

  @override
  Widget build(BuildContext context) {
    void handleLogout() {
      LoginRegisterAPI().handleLogout();
      Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) =>
        LoginOrRegister(),
      ));
    }
    return ListTile(
      title: Container(
        padding: EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
            border:
                Border(bottom: BorderSide(width: 1, color: Colors.black12))),
        child: Row(
          children: [
            icon,
            SizedBox(
              width: 5,
            ),
            Text(
              title,
              style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      onTap: () {
        if(title == 'Gửi yêu cầu đăng bài'){
          DetailAPI().handleNotification('', currentUser, 'admin', ' Đã gửi yêu cầu tạo bài viết căn hộ cho thue', 'createRequest');
          Helper_Fuction().showToastMessege('Bạn đã gửi yêu cầu đến Admin');
          Navigator.pop(context);
        } else if(title == 'Đăng xuất') {
          handleLogout();
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => screenToNavigate,
            ));
        }
      },
    );
  }
}