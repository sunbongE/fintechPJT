import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:front/const/colors/Colors.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:lottie/lottie.dart';

class SelectLocation extends StatefulWidget {
  const SelectLocation({Key? key}) : super(key: key);

  @override
  State<SelectLocation> createState() => _SelectLocationState();
}

class _SelectLocationState extends State<SelectLocation> {
  late GoogleMapController mapController;
  final LatLng _center = const LatLng(37.566, 126.978);
  LatLng? _lastMapPosition;
  String address = "";
  Timer? _debounce;
  bool _isLoading = true;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    setState(() {
      _isLoading = false;
    });
  }

  void _onCameraMove(CameraPosition position) {
    _lastMapPosition = position.target;

    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 400), () async {
      List<Placemark> placemarks = await placemarkFromCoordinates(_lastMapPosition!.latitude, _lastMapPosition!.longitude);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        String detailedAddress = _formatAddress(place);
        setState(() {
          address = detailedAddress;
          print(address);
        });
      }
    });
  }

  Future<void> _confirmSelection(BuildContext context) async {
    if (_lastMapPosition != null) {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        _lastMapPosition!.latitude,
        _lastMapPosition!.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        String detailedAddress = _formatAddress(place);
        Navigator.pop(context, detailedAddress);
      }
    }
  }

  String _formatAddress(Placemark place) {
    List<String> addressParts = [];
    if (place.street != null) addressParts.add(place.street!);

    String formattedAddress = addressParts.join(" ");

    return formattedAddress;
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("장소 선택"),
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () => _confirmSelection(context),
          ),
        ],
      ),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 11.0,
            ),
            onCameraMove: _onCameraMove,
            minMaxZoomPreference: MinMaxZoomPreference(5, 20),
          ),
          Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_isLoading)
                  Lottie.asset("assets/lotties/orangewalking.json"),
                FittedBox(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                    decoration: BoxDecoration(
                      color: PRIMARY_COLOR,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(
                      address,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.white,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                Icon(
                  Icons.location_pin,
                  size: 50.0.sp,
                  color: COMPLETE_BUTTON_COLOR,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
