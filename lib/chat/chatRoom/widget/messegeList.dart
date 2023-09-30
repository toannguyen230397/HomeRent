import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:home_rent/detail/widget/zoomImage.dart';
import 'package:home_rent/helper_function/function.dart';

class MessegeList extends StatefulWidget {
  const MessegeList(
      {super.key,
      required this.datas,
      required this.currentUser,
      required this.partnerUser});
  final List<dynamic> datas;
  final String currentUser;
  final String partnerUser;

  @override
  State<MessegeList> createState() => _MessegeListState();
}

class _MessegeListState extends State<MessegeList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        reverse: true,
        shrinkWrap: true,
        itemCount: widget.datas.length,
        itemBuilder: (BuildContext context, int index) {
          Size screenSize = MediaQuery.of(context).size;
          var item = widget.datas[index];
          bool sendbyMe = item['sendby'] == widget.currentUser;
          List reader = item['reader'];
          bool isReader = reader.contains(widget.partnerUser);
          return Align(
            alignment: sendbyMe ? Alignment.centerRight : Alignment.centerLeft,
            child: item['type'] == 'Text'
                ? Container(
                    constraints:
                        BoxConstraints(maxWidth: screenSize.width * 0.5),
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: sendbyMe
                          ? Colors.teal.shade300
                          : Colors.blueGrey.shade50,
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: Colors.black45,
                          blurRadius: 20.0,
                          spreadRadius: -20.0,
                          offset: Offset(0.0, 25.0),
                        )
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: sendbyMe
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      children: [
                        Text(item['messege'],
                            style: TextStyle(
                                fontSize: 18,
                                color: sendbyMe ? Colors.white : Colors.black,
                                )),
                        Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            sendbyMe
                                ? isReader
                                    ? Icon(Icons.check, color: Colors.white)
                                    : SizedBox(width: 0)
                                : SizedBox(width: 0),
                            sendbyMe
                                ? isReader
                                    ? SizedBox(
                                        width: 10,
                                      )
                                    : SizedBox(width: 0)
                                : SizedBox(width: 0),
                            Text(
                                Helper_Fuction()
                                    .formatTimestamp(item['postTime']),
                                style: TextStyle(
                                    fontSize: 13,
                                    color: sendbyMe
                                        ? Colors.white70
                                        : Colors.black45)),
                          ],
                        )
                      ],
                    ),
                  )
                : Container(
                    constraints:
                        BoxConstraints(maxWidth: screenSize.width * 0.5),
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: Colors.black45,
                          blurRadius: 20.0,
                          spreadRadius: -20.0,
                          offset: Offset(0.0, 25.0),
                        )
                      ],
                    ),
                    child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ZoomImage(Url: item['messege']),
                        ));
                  },
                  child: CachedNetworkImage(
                    imageUrl: item['messege'],
                    fit: BoxFit.fill,
                    placeholder: (context, url) => Container(
                      color: Colors.blueGrey.shade300,
                      width: screenSize.width * 0.5,
                      height: screenSize.width * 0.5,
                      child: Center(
                          child: CircularProgressIndicator(
                        color: Colors.white,
                      )),
                    ),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                )), 
                  ),
          );
        });
  }
}
