import 'package:flutter/material.dart';
import 'package:home_rent/followFeeds/api/firebaseAPI.dart';
import 'package:home_rent/followFeeds/widget/list_Item.dart';

class FollowFeeds extends StatelessWidget {
  const FollowFeeds({super.key, required this.currentUser});
  final String currentUser;

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
          title: Text(
            'Danh sách căn hộ đã lưu',
            style: TextStyle(fontWeight: FontWeight.bold),
          )),
      body: SafeArea(
        child: FutureBuilder(
            future: followAPI().getData(currentUser),
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
                final data = snapshot.data!;
                if (data.isEmpty) {
                  return Center(child: Text('Không có danh sách nào!'));
                }
                return list_Item(data: data, currentUser: currentUser);
              }
            }),
      ),
    );
  }
}
