import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class imagesWidget extends StatefulWidget {
  const imagesWidget(
      {super.key,
      required this.imageList,
      required this.ImagesURL,
      required this.title});
  final List<File> imageList;
  final List<dynamic> ImagesURL;
  final String title;

  @override
  State<imagesWidget> createState() => _imagesWidgetState();
}

class _imagesWidgetState extends State<imagesWidget> {
  void pickerMultiImages(
      List<File> selectedImages, List<dynamic> ImagesURL) async {
    selectedImages.clear();
    final ImagePicker picker = ImagePicker();
    final List<XFile> images = await picker.pickMultiImage();
    if (images.isNotEmpty) {
      for (var i = 0; i < images.length; i++) {
        selectedImages.add(File(images[i].path));
      }
      ImagesURL.clear();
      setState(() {});
      print(selectedImages);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.only(top: 20, bottom: 10, left: 10, right: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(left: 30, right: 30),
            child: Text(widget.title,
                style: TextStyle(
                    color: Colors.teal.shade300, fontWeight: FontWeight.bold)),
          ),
          SizedBox(
            height: 10,
          ),
          widget.imageList.isEmpty && widget.ImagesURL.isEmpty
              ? Center(
                  child: InkWell(
                    onTap: () {
                      pickerMultiImages(widget.imageList, widget.ImagesURL);
                    },
                    child: Container(
                      width: screenSize.width * 0.5,
                      height: screenSize.width * 0.35,
                      decoration: BoxDecoration(
                          color: Colors.blueGrey.shade100,
                          borderRadius: BorderRadius.circular(10)),
                      child: Icon(
                        Icons.add_a_photo,
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
              : SizedBox(
                  height: screenSize.width * 0.35,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.ImagesURL.isNotEmpty
                        ? widget.ImagesURL.length
                        : widget.imageList.length,
                    itemBuilder: (context, index) {
                      return Container(
                          margin: EdgeInsets.only(right: 20),
                          decoration: BoxDecoration(
                              color: Colors.blueGrey.shade100,
                              borderRadius: BorderRadius.circular(10)),
                          width: screenSize.width * 0.5,
                          child: InkWell(
                            onTap: () {
                              pickerMultiImages(
                                  widget.imageList, widget.ImagesURL);
                            },
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: widget.ImagesURL.isNotEmpty
                                    ? Image.network(widget.ImagesURL[index],
                                        fit: BoxFit.fill)
                                    : Image.file(widget.imageList[index],
                                        fit: BoxFit.fill)),
                          ));
                    },
                  ),
                ),
        ],
      ),
    );
  }
}
