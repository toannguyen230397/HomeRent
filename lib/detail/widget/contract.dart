import 'package:flutter/material.dart';
import 'package:home_rent/chat/chatRoom/chatRoom.dart';
import 'package:home_rent/helper_function/function.dart';
import 'package:url_launcher/url_launcher.dart';

class Contract extends StatelessWidget {
  const Contract(
      {super.key,
      required this.currentUser,
      required this.currentUserType,
      required this.API});
  final String currentUser;
  final String currentUserType;
  final Future API;

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri _url = Uri.parse("tel:$phoneNumber");
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: API,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container();
          } else if (snapshot.hasError) {
            return Container();
          } else {
            final partnerData = snapshot.data!;
            return ContractWidget(partnerData: partnerData, currentUser: currentUser);
          }
        });
  }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////




class ContractWidget extends StatelessWidget {
  const ContractWidget({super.key, required this.partnerData, required this.currentUser});
  final Map<String, dynamic> partnerData;
  final String currentUser;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10, top: 20, bottom: 20),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(10.0),
            bottomLeft: Radius.circular(10.0)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Color(0xFFB0BEC5),
            blurRadius: 20.0,
            spreadRadius: -20.0,
            offset: Offset(0.0, 25.0),
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(partnerData['avatar']),
                backgroundColor: Colors.blueGrey.shade100,
              ),
              SizedBox(
                width: 10,
              ),
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(partnerData['name'],
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18)),
                    Text(partnerData['type'])
                  ],
                ),
              ),
            ],
          ),
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.blueGrey.shade50,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: IconButton(
                    onPressed: () {
                      Helper_Fuction().makePhoneCall(partnerData['phoneNumber']);
                    },
                    icon: Icon(
                      Icons.phone,
                      size: 30,
                      color: Colors.teal.shade300,
                    )),
              ),
              SizedBox(
                width: 10,
              ),
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.blueGrey.shade50,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatRoom(
                              currentUser: currentUser,
                              partnerUser: partnerData['uid'],
                              partnerUserAvatar: partnerData['avatar'],
                              partnerUserName: partnerData['name'],
                              partnerUserType: partnerData['type'],
                            ),
                          ));
                    },
                    icon: Icon(
                      Icons.message,
                      size: 30,
                      color: Colors.teal.shade300,
                    )),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
