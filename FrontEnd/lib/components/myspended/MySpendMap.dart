import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';

class MySpendMap extends StatefulWidget {
  final String location;

  const MySpendMap({Key? key, required this.location}) : super(key: key);

  @override
  State<MySpendMap> createState() => _MySpendMapState();
}

class _MySpendMapState extends State<MySpendMap> {
  late GoogleMapController mapController;
  late LatLng center = LatLng(37.566, 126.978);
  bool isLocationLoaded = false;

  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  _getLocation() async {
    try {
      List<Location> locations = await locationFromAddress(widget.location);
      if (locations.isNotEmpty) {
        setState(() {
          center = LatLng(locations.first.latitude, locations.first.longitude);
          isLocationLoaded = true;
        });
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    Set<Marker> markers = {
      Marker(
        markerId: MarkerId('someMarker'),
        position: center,
        infoWindow: InfoWindow(
          title: widget.location,
        ),
      ),
    };

    return Container(
      width: 450.w,
      height: 450.h,
      child: isLocationLoaded
          ? GoogleMap(
              onMapCreated: onMapCreated,
              initialCameraPosition: CameraPosition(
                target: center,
                zoom: 15.0,
              ),
              markers: markers,
            )
          : Center(child: CircularProgressIndicator()),
    );
  }
}
