import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:lottie/lottie.dart' as lottie;
import '../../repository/api/ApiMyPage.dart';

class GroupMap extends StatefulWidget {
  final String description;
  final int groupId;

  const GroupMap({
    required this.description,
    required this.groupId,
    super.key,
  });

  @override
  State<GroupMap> createState() => _GroupMapState();
}

class _GroupMapState extends State<GroupMap> {
  late GoogleMapController mapController;
  final Set<Marker> markers = {};
  bool isLocationLoaded = false;

  @override
  void initState() {
    super.initState();
    getGroupMap();
  }

  void getGroupMap() async {
    try {
      Response res = await getGroupLocationList(widget.groupId);
      List<dynamic> locations = res.data;

      for (var location in locations) {
        List<Location> geolocations = await locationFromAddress(location);
        if (geolocations.isNotEmpty) {
          setState(() {
            markers.add(
              Marker(
                markerId: MarkerId(location),
                position: LatLng(geolocations.first.latitude, geolocations.first.longitude),
                infoWindow: InfoWindow(title: location),
              ),
            );
          });
        }
      }

      setState(() {
        isLocationLoaded = true;
      });
    } catch (e) {
      print("Error: $e");
    }
  }

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.description}"),
      ),
      body: isLocationLoaded
          ? GoogleMap(
              onMapCreated: onMapCreated,
              initialCameraPosition: CameraPosition(
                target: markers.isNotEmpty ? markers.first.position : LatLng(0, 0),
                zoom: 15.0,
              ),
              markers: markers,
            )
          : Center(child: lottie.Lottie.asset('assets/lotties/orangewalking.json')),
    );
  }
}
