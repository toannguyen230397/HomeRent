import 'package:flutter/material.dart';
import 'package:home_rent/detail/api/firebaseAPI.dart';
import 'package:home_rent/detail/widget/bannerSilder.dart';
import 'package:home_rent/detail/widget/bottomSheet.dart';
import 'package:home_rent/detail/widget/contract.dart';
import 'package:home_rent/detail/widget/zoomImage.dart';
import 'package:home_rent/helper_function/function.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Detail extends StatefulWidget {
  const Detail({super.key, required this.datas, required this.currentUser});
  final Map<String, dynamic> datas;
  final String currentUser;

  @override
  State<Detail> createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> datas = widget.datas;
    List<dynamic> Banner = datas['housePhotos'];
    List<dynamic> Photos = datas['interiorPhotos'];
    List<dynamic> Furniture = datas['furniture'];
    List<dynamic> favoriteList = datas['favorite'];
    bool isFavorite = favoriteList.contains(widget.currentUser);
    Size screenSize = MediaQuery.of(context).size;

    String getCurrentUserType() {
      if (datas['renter'] != '' && widget.currentUser == datas['renter']) {
        return 'renter';
      } else if (widget.currentUser == datas['owner']) {
        return 'owner';
      } else if (widget.currentUser == 'admin') {
        return 'admin';
      } else {
        return 'user';
      }
    }

    String currentUserType = getCurrentUserType();

    void followHandle() {
      if (isFavorite) {
        DetailAPI()
            .handleFavorite(datas['maNha'], isFavorite, widget.currentUser);
        setState(() {
          isFavorite = !isFavorite;
        });
        favoriteList.remove(widget.currentUser);
        Helper_Fuction().showToastMessege('Bạn đã bỏ theo dõi bài viết');
      } else {
        DetailAPI()
            .handleFavorite(datas['maNha'], isFavorite, widget.currentUser);
        setState(() {
          isFavorite = !isFavorite;
        });
        favoriteList.add(widget.currentUser);
        Helper_Fuction().showToastMessege('Bạn đã theo dõi bài viết');
      }
    }

    return Scaffold(
        extendBodyBehindAppBar: true,
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BannerSlider(Banner: Banner, datas: datas),
              Container(
                margin: EdgeInsets.only(left: 10, right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "RENT",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '${datas['price']} VNĐ',
                          style: TextStyle(
                              color: Colors.teal.shade300,
                              fontSize: 25,
                              fontWeight: FontWeight.bold),
                        )
                      ],
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
                            BottomSheetHandle().showBottomSheet(context, followHandle, isFavorite, datas['maNha'], widget.currentUser, datas['owner'], currentUserType, datas['renter'], datas);
                          },
                          icon: Icon(
                            currentUserType == 'user'
                                ? Icons.favorite
                                : currentUserType == 'owner' || currentUserType == 'admin'
                                    ? Icons.build
                                    : Icons.report,
                            color: isFavorite && currentUserType == 'user'
                                ? Colors.red
                                : Colors.black,
                            size: 30,
                          )),
                    )
                  ],
                ),
              ),
              Container(
                margin:
                    EdgeInsets.only(top: 20, bottom: 20, left: 10, right: 10),
                child: Text(datas['desc'],
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black45)),
              ),
              Container(
                margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Địa chỉ: ",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        )),
                    Text(
                        "${datas['province']}, ${datas['district']}, ${datas['ward']}",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black45)),
                  ],
                ),
              ),
              Container(
                  margin: EdgeInsets.only(left: 10, right: 10),
                  child: Row(
                    children: [
                      Icon(Icons.map),
                      InkWell(
                          onTap: () {
                            Helper_Fuction().launchGoogleMap(
                                datas['latitude'], datas['longitude'], "Test");
                          },
                          child: Text(' Xem bản đồ',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.teal.shade300)))
                    ],
                  )),
              Container(
                  margin:
                      EdgeInsets.only(top: 20, bottom: 20, left: 10, right: 10),
                  child: Text('ẢNH NỘI THẤT',
                      style: TextStyle(fontWeight: FontWeight.bold))),
              interiorPhotos(screenSize: screenSize, Photos: Photos),
              Container(
                  margin:
                      EdgeInsets.only(top: 20, bottom: 10, left: 10, right: 10),
                  child: Text('CÁC TRAMG BỊ CÓ SẴN',
                      style: TextStyle(fontWeight: FontWeight.bold))),
              FURNITURE(screenSize: screenSize, Furniture: Furniture),
              datas['renter'] == '' && currentUserType == 'owner'
                  ? Container(
                      margin: EdgeInsets.only(
                          left: 10, right: 10, top: 20, bottom: 20),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
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
                    )
                  : widget.currentUser == 'admin'
                  ? Column(
                    children: [
                      Contract(
                          currentUser: widget.currentUser,
                          currentUserType: currentUserType,
                          API: DetailAPI().getUserData(datas['owner'])),
                      datas['renter'] != ''
                      ? Contract(
                        currentUser: widget.currentUser,
                        currentUserType: currentUserType,
                        API: DetailAPI().getUserData(datas['renter']))
                      : Container()
                    ],
                  )
                  : Contract(
                      currentUser: widget.currentUser,
                      currentUserType: currentUserType,
                      API: currentUserType == 'owner' && datas['renter'] != ''
                          ? DetailAPI().getUserData(datas['renter'])
                          : DetailAPI().getUserData(datas['owner']))
            ],
          ),
        ));
  }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////

class interiorPhotos extends StatelessWidget {
  const interiorPhotos({
    super.key,
    required this.screenSize,
    required this.Photos,
  });

  final Size screenSize;
  final List Photos;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: screenSize.width * 0.35,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: Photos.length,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.only(left: 10, right: 10),
            width: screenSize.width * 0.5,
            child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ZoomImage(Url: Photos[index]),
                        ));
                  },
                  child: CachedNetworkImage(
                    imageUrl: Photos[index],
                    fit: BoxFit.fill,
                    placeholder: (context, url) => Container(
                      color: Colors.blueGrey.shade300,
                      width: screenSize.width * 0.5,
                      child: Center(
                          child: CircularProgressIndicator(
                        color: Colors.white,
                      )),
                    ),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                )),
          );
        },
      ),
    );
  }
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
class FURNITURE extends StatelessWidget {
  const FURNITURE(
      {super.key, required this.screenSize, required this.Furniture});
  final Size screenSize;
  final Furniture;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: screenSize.width * 0.05,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: Furniture.length,
          itemBuilder: (context, index) {
            final item = Furniture[index];
            return Container(
              margin: EdgeInsets.only(left: 10, right: 10),
              child: Row(
                children: [
                  Icon(
                    item == 'TV'
                        ? Icons.connected_tv
                        : item == 'Wifi'
                            ? Icons.wifi
                            : item == 'Điều hòa'
                            ? Icons.ac_unit
                            : Icons.bed,
                    size: 30,
                  ),
                  Text(
                    "  ${item}",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )
                ],
              ),
            );
          }),
    );
  }
}
