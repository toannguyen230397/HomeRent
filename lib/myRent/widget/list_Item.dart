import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:home_rent/detail/detail.dart';

class list_Item extends StatelessWidget {
  const list_Item({
    super.key,
    required this.data,
    required this.currentUser,
  });

  final List<Map<String, dynamic>> data;
  final String currentUser;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: data.length,
        itemBuilder: (BuildContext context, int index) {
          Size screenSize = MediaQuery.of(context).size;
          final item = data[index];
          return InkWell(
            onTap: () {
              Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Detail(datas: item, currentUser: currentUser),
              ));
            },
            child: Container(
              margin: EdgeInsets.all(10),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: CachedNetworkImage(
                        imageUrl: item['housePhotos'][0],
                        fit: BoxFit.fill,
                        placeholder: (context, url) => Container(
                          color: Colors.blueGrey.shade300,
                          width: screenSize.width * 0.5,
                          child: Center(
                              child: CircularProgressIndicator(
                            color: Colors.white,
                          )),
                        ),
                        errorWidget: (context, url, error) =>
                            Icon(Icons.error),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    flex: 7,
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  width: 1, color: Colors.black12))),
                      padding: EdgeInsets.only(bottom: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['tenNha'],
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                          Row(
                            children: [
                              Text('Chủ hộ: ', style: TextStyle(fontWeight: FontWeight.bold),),
                              Text(item['ownerName'])
                            ],
                          ),
                          Row(
                            children: [
                              Text('Người thuê: ', style: TextStyle(fontWeight: FontWeight.bold),),
                              Container(
                                  margin: EdgeInsets.only(top: 5),
                                  width: 50,
                                  decoration: BoxDecoration(
                                    color: Colors.cyan.shade50,
                                    borderRadius:
                                        BorderRadius.circular(5),
                                  ),
                                  padding: EdgeInsets.all(5),
                                  child: Center(
                                    child: Text(
                                      "Bạn",
                                      style: TextStyle(
                                          color: Colors.teal.shade300),
                                    ),
                                  )),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
