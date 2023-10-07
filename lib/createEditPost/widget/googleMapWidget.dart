import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:home_rent/district/district.dart';

class GoogleMapWidget extends StatefulWidget {
  const GoogleMapWidget(
      {super.key, required this.getPosition, required this.address});
  final Function getPosition;
  final String address;

  @override
  State<GoogleMapWidget> createState() => _GoogleMapWidgetState();
}

class _GoogleMapWidgetState extends State<GoogleMapWidget> {
  final Completer<GoogleMapController> mapController =
      Completer<GoogleMapController>();
  double latitude = 0.0;
  double longitude = 0.0;

  Future<void> gotoPosition(String address) async {
    List<Location> locations = await locationFromAddress(address);
    if (locations.isNotEmpty) {
      setState(() {
        latitude = locations[0].latitude;
        longitude = locations[0].longitude;
      });
      final GoogleMapController controller = await mapController.future;
      await controller
          .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(locations[0].latitude, locations[0].longitude),
        zoom: 15.0,
      )));
    }
  }

  @override
  void initState() {
    super.initState();
    gotoPosition(widget.address);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back_ios_new,
                size: 30,
              )),
          title: InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => getDistrict(
                      getAdress: gotoPosition,
                      screen: 'map',
                    ),
                  ));
            },
            child: Text(
              'Chọn vị trí căn hộ',
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.teal.shade300),
            ),
          ),
          actions: [
            InkWell(
              onTap: () {
                widget.getPosition(latitude.toString(), longitude.toString());
                Navigator.pop(context);
              },
              child: Container(
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.only(top: 5, bottom: 5),
                decoration: BoxDecoration(
                  color: Colors.teal.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    'Xác nhận',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 10,
            )
          ]),
      body: GoogleMap(
        onMapCreated: (GoogleMapController controller) {
          mapController.complete(controller);
        },
        initialCameraPosition: CameraPosition(
          target: LatLng(latitude, longitude),
          zoom: 15.0,
        ),
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        onTap: (LatLng latLng) {
          setState(() {
            latitude = latLng.latitude;
            longitude = latLng.longitude;
          });
        },
        markers: {
          Marker(
            markerId: MarkerId('get position'),
            position: LatLng(latitude, longitude),
          )
        },
      ),
    );
  }
}
