import 'package:flutter/material.dart';
import 'package:home_rent/district/district.dart';
import 'package:home_rent/empty.dart';
import 'package:home_rent/followFeeds/followFeeds.dart';
import 'package:home_rent/home/api/firebaseAPI.dart';
import 'package:home_rent/home/widget/drawerScreen.dart';
import 'package:home_rent/home/widget/itemList.dart';
import 'package:home_rent/home/widget/notiWidget.dart';
import 'package:home_rent/loginRegister/loginOrRegister.dart';
import 'package:home_rent/myFeeds/myFeeds.dart';
import 'package:home_rent/myRent/myRent.dart';
import 'package:home_rent/loginRegister/api/firebaseAPI.dart';

class Home extends StatefulWidget {
  const Home(
      {super.key, required this.currentUser, required this.currentUserType});
  final String currentUser;
  final String currentUserType;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String district = '';
  String province = '';

  void getAddress(String provinceName, String districtName) {
    setState(() {
      province = provinceName;
      district = districtName;
    });
  }

  @override
  Widget build(BuildContext context) {
    String currentUser = widget.currentUser;
    String currentUserType = widget.currentUserType;
    GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.teal.shade300,
              ),
              child: Image.asset('assets/images/icon.png', width: 100, height: 100, color: Colors.white,)
            ),
            drawerScreen(
              currentUser: currentUser,
              title: 'Danh sách căn hộ đã lưu',
              icon: Icon(Icons.edit_document),
              screenToNavigate: FollowFeeds(
                currentUser: currentUser,
              ),
            ),
            drawerScreen(
              currentUser: currentUser,
              title: 'Danh sách căn hộ đang thuê',
              icon: Icon(Icons.house),
              screenToNavigate: MyRent(currentUser: currentUser),
            ),
            currentUserType == 'Owner'
                ? drawerScreen(
                    currentUser: currentUser,
                    title: 'Bài đăng của bạn',
                    icon: Icon(Icons.edit_document),
                    screenToNavigate: MyFeeds(currentUser: currentUser),
                  )
                : Container(),
            drawerScreen(
              currentUser: currentUser,
              title: 'Gửi yêu cầu đăng bài',
              icon: Icon(Icons.add),
              screenToNavigate: emptyClass(),
            ),
            drawerScreen(
              currentUser: currentUser,
              title: 'Đăng xuất',
              icon: Icon(Icons.logout),
              screenToNavigate: emptyClass(),
            )
          ],
        ),
      ),
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        leading: currentUserType == 'admin'
            ? IconButton(
                onPressed: () {
                  LoginRegisterAPI().handleLogout();
                  Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                    LoginOrRegister(),
                  ));
                },
                icon: Icon(
                  Icons.logout,
                  size: 30,
                ))
            : IconButton(
                onPressed: () {
                  _scaffoldKey.currentState?.openDrawer();
                },
                icon: Icon(
                  Icons.menu,
                  size: 30,
                )),
        actions: [
          notificationLenghth(currentUser: currentUser, iconType: 'message'),
          notificationLenghth(
              currentUser: currentUser, iconType: 'notification'),
        ],
      ),
      body: SafeArea(
          child: Center(
              child: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.white,
            Colors.blueGrey.shade100,
          ],
        )),
        child: Column(
          children: [
            Container(
              color: Colors.white,
              child: Row(
                children: [
                  Expanded(flex: 1, child: Icon(Icons.location_on)),
                  Expanded(
                      flex: 9,
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => getDistrict(
                                  getAdress: getAddress,
                                  screen: 'home',
                                ),
                              ));
                        },
                        child: Text(
                          district != '' ? district : 'Lọc địa điểm',
                          style: TextStyle(
                              color: district == ''
                                  ? Colors.black
                                  : Colors.teal.shade300,
                              fontWeight: FontWeight.bold,
                              fontSize: 30),
                        ),
                      ))
                ],
              ),
            ),
            Expanded(
                child: StreamBuilder(
                    stream: HomeAPI().getData(currentUserType),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        ); // Đang nạp dữ liệu
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text('Lỗi: ${snapshot.error}'),
                        ); // Có lỗi xảy ra
                      } else {
                        final data = snapshot.data!;
                        List<Map<String, dynamic>> filteredData = data
                            .where((item) => item['district']
                                .toLowerCase()
                                .contains(district.toLowerCase()))
                            .toList();
                        return RefreshIndicator(
                            onRefresh: () {
                              return Future(() {
                                district = '';
                                setState(() {});
                              });
                            },
                            child: itemList(
                                datas: district != '' ? filteredData : data,
                                currentUser: currentUser));
                      }
                    })),
          ],
        ),
      ))),
    );
  }
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////




