import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:home_rent/detail/widget/zoomImage.dart';
import 'package:cached_network_image/cached_network_image.dart';

class BannerSlider extends StatelessWidget {
  const BannerSlider({super.key, required this.Banner, required this.datas});
  final List<dynamic> Banner;
  final Map<String, dynamic> datas;

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return Stack(
      children: <Widget>[
        CarouselSlider(
          options: CarouselOptions(
            height: screenSize.height * 0.4,
            autoPlay: true,
            reverse: true,
            viewportFraction: 1,
            autoPlayInterval: Duration(seconds: 5),
          ),
          items: Banner.map((item) {
            return Builder(
              builder: (BuildContext context) {
                return ShaderMask(
                    shaderCallback: (screenSize) {
                      return LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black,
                          Colors.black87,
                          Colors.transparent
                        ],
                      ).createShader(Rect.fromLTRB(
                          0, 0, screenSize.width, screenSize.height));
                    },
                    blendMode: BlendMode.dstIn,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ZoomImage(Url: item),
                            ));
                      },
                      child: CachedNetworkImage(
                        imageUrl: item,
                        fit: BoxFit.fill,
                        placeholder: (context, url) => Container(
                          color: Colors.blueGrey.shade100,
                          width: screenSize.width,
                          child: Center(
                              child: CircularProgressIndicator(
                            color: Colors.white,
                          )),
                        ),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    ));
              },
            );
          }).toList(),
        ),
        Positioned(
          left: 10.0,
          bottom: 20.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: Row(
                  children: [
                    Icon(Icons.location_city),
                    Text(
                      datas['district'],
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ],
                ),
              ),
              Container(
                width: screenSize.width * 0.7,
                child: Text(
                  datas['tenNha'],
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.black54,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
