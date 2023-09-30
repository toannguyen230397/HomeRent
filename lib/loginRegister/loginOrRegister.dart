import 'dart:io';

import 'package:flutter/material.dart';
import 'package:home_rent/helper_function/function.dart';
import 'package:home_rent/home/home.dart';
import 'package:home_rent/loginRegister/api/firebaseAPI.dart';
import 'package:home_rent/loginRegister/widget/textFieldWidget.dart';
import 'package:image_picker/image_picker.dart';

class LoginOrRegister extends StatefulWidget {
  const LoginOrRegister({super.key});

  @override
  State<LoginOrRegister> createState() => _LoginOrRegisterState();
}

class _LoginOrRegisterState extends State<LoginOrRegister> {
  final pageController = PageController();
  TextEditingController email_Controller = TextEditingController();
  TextEditingController password_Controller = TextEditingController();
  TextEditingController name_Controller = TextEditingController();
  TextEditingController phoneNumber_Controller = TextEditingController();
  File? imageSelected;
  bool isLoading = false;

  void handleDefaultLoading() {
    setState(() {
      isLoading = !isLoading;
    });
  }

  void handleRegisLoading() {
    setState(() {
      isLoading = !isLoading;
    });
    comeBack();
  }

  void goNextPage() {
    FocusManager.instance.primaryFocus?.unfocus();
    pageController.animateToPage(1,
        duration: const Duration(seconds: 1), curve: Curves.easeInOut);
  }

  void comeBack() {
    email_Controller.clear();
    password_Controller.clear();
    name_Controller.clear();
    phoneNumber_Controller.clear();
    setState(() {
      imageSelected = null;
    });
    pageController.animateToPage(0,
        duration: const Duration(seconds: 1), curve: Curves.easeInOut);
  }

  void gotoHomeScreen(String currentUser, String currentUserType) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) =>
        Home(currentUser: currentUser, currentUserType: currentUserType,),
    ));
  }

  void pickerImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        imageSelected = File(image.path);
      });
      print(imageSelected);
    }
  }

  void initState() {
    super.initState();
    LoginRegisterAPI().autoLogin(gotoHomeScreen);
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade50,
      body: SafeArea(
          child: PageView(
        controller: pageController,
        physics: NeverScrollableScrollPhysics(),
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: screenSize.width,
                  height: screenSize.height * 0.3,
                  child: Center(
                    child: Image.asset('assets/images/icon.png', width: 150, height: 150,),
                  ),
                ),
                TextFieldWidget(
                  isPassword: false,
                  label: 'địa chỉ Email',
                  icon: Icon(Icons.person),
                  controller: email_Controller,
                  type: 'text',
                ),
                TextFieldWidget(
                  isPassword: true,
                  label: 'mật khẩu',
                  icon: Icon(Icons.lock),
                  controller: password_Controller,
                  type: 'text',
                ),
                Container(
                  margin: EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('chưa có tài khoản?',
                          style: TextStyle(color: Colors.black38)),
                      SizedBox(
                        width: 10,
                      ),
                      InkWell(
                          onTap: () {
                            goNextPage();
                          },
                          child: Text(
                            'Đăng ký',
                            style: TextStyle(
                                color: Colors.teal.shade300,
                                fontWeight: FontWeight.bold),
                          ))
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    FocusManager.instance.primaryFocus?.unfocus();
                    final email = email_Controller.text;
                    final password = password_Controller.text;
                    if(email.isNotEmpty && password.isNotEmpty) {
                      setState(() {
                        isLoading = !isLoading;
                      });
                      LoginRegisterAPI().handleLogin(email, password, gotoHomeScreen, handleDefaultLoading);
                    } else {
                      Helper_Fuction().showToastMessege('Vui lòng nhập đủ thông tin');
                    }
                  },
                  child: Container(
                    width: screenSize.width,
                    height: screenSize.height * 0.06,
                    margin: EdgeInsets.only(left: 40, right: 40),
                    decoration: BoxDecoration(
                      color: Colors.teal.shade300,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: isLoading
                          ? SizedBox(
                              width: 15,
                              height: 15,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              'Đăng nhập',
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                    ),
                  ),
                )
              ],
            ),
          ), ///////////////////////////////////////////////////////////////////// kết thúc page Login
          SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: screenSize.width,
                  height: screenSize.height * 0.3,
                  child: Center(
                    child: InkWell(
                      onTap: () {
                        pickerImage();
                      },
                      child: Container(
                        width: screenSize.width * 0.4,
                        height: screenSize.width * 0.4,
                        decoration: BoxDecoration(
                            color: Colors.blueGrey.shade100,
                            borderRadius: BorderRadius.circular(100)),
                        child: imageSelected != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: Image.file(
                                  imageSelected!,
                                  fit: BoxFit.fill,
                                ))
                            : Icon(
                                Icons.add_a_photo,
                                color: Colors.white,
                              ),
                      ),
                    ),
                  ),
                ),
                TextFieldWidget(
                  isPassword: false,
                  label: 'địa chỉ Email',
                  icon: Icon(Icons.person),
                  controller: email_Controller,
                  type: 'text',
                ),
                TextFieldWidget(
                  isPassword: false,
                  label: 'họ tên',
                  icon: Icon(Icons.person),
                  controller: name_Controller,
                  type: 'text',
                ),
                TextFieldWidget(
                  isPassword: true,
                  label: 'mật khẩu',
                  icon: Icon(Icons.lock),
                  controller: password_Controller,
                  type: 'text',
                ),
                TextFieldWidget(
                  isPassword: false,
                  label: 'số điện thoại',
                  icon: Icon(Icons.phone),
                  controller: phoneNumber_Controller,
                  type: 'phoneNumber',
                ),
                Container(
                  margin: EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('hủy bỏ đăng ký?',
                          style: TextStyle(color: Colors.black38)),
                      SizedBox(
                        width: 10,
                      ),
                      InkWell(
                          onTap: () {
                            comeBack();
                          },
                          child: Text(
                            'Quay lại',
                            style: TextStyle(
                                color: Colors.teal.shade300,
                                fontWeight: FontWeight.bold),
                          ))
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    FocusManager.instance.primaryFocus?.unfocus();
                    final email = email_Controller.text;
                    final name = name_Controller.text;
                    final password = password_Controller.text;
                    final phoneNumber = phoneNumber_Controller.text;
                    if(email.isEmpty || name.isEmpty || password.isEmpty || phoneNumber.isEmpty || imageSelected == null) {
                      Helper_Fuction().showToastMessege('Vui lòng nhập đủ thông tin');
                    } else {
                      setState(() {
                        isLoading = !isLoading;
                      });
                      LoginRegisterAPI().handleRegister(email, name, password, imageSelected!, phoneNumber, handleDefaultLoading, handleRegisLoading);
                    }
                  },
                  child: Container(
                    width: screenSize.width,
                    height: screenSize.height * 0.06,
                    margin: EdgeInsets.only(left: 40, right: 40),
                    decoration: BoxDecoration(
                      color: Colors.teal.shade300,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: isLoading
                          ? SizedBox(
                              width: 15,
                              height: 15,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              'Đăng ký',
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      )),
    );
  }
}
