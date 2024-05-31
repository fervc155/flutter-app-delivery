

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as location;

class ClientAddressMapController 
{
  late BuildContext context;
  late Function refresh;
  Position? position;
  String address='';
  LatLng? addressPoint;

  init(BuildContext context, refresh)
  {
    this.context =context;
    this.refresh=refresh;
    checkGPS();
  }


  Completer<GoogleMapController> mapController = Completer();

  CameraPosition initialPosition  = CameraPosition(
    target:LatLng(20.584890, -103.332307),
    zoom: 14
  );

zoomIn() async {
  final GoogleMapController controller = await mapController.future;
  controller.animateCamera(CameraUpdate.zoomIn());
}

zoomOut() async {
  final GoogleMapController controller = await mapController.future;
  controller.animateCamera(CameraUpdate.zoomOut());
}


  void selectRefPoint(){
    Map<String, dynamic> data = {
      'address': address,
      'lat': addressPoint?.latitude,
      'lng': addressPoint?.longitude,
    };

    Navigator.pop(context, data);
  }

  Future<Null>  setLocationDraggableInfo() async {
    double lat = initialPosition.target.latitude;
    double lng = initialPosition.target.longitude;

    List<Placemark> address = await placemarkFromCoordinates(lat, lng);

   if(address.length>0){
      String direction = address[0].thoroughfare ?? '';
      String street = address[0].subThoroughfare ?? '';
    //  String city = address[0].locality ?? '';
      String department = address[0].administrativeArea ?? '';
     // String country = address[0].country ?? '';

      this.address = '$direction $street, $department $department';
      
      this.addressPoint = new LatLng(lat, lng);
      refresh();
   }

    

  }

  void onMapCreated(GoogleMapController controller)
  {
    mapController.complete(controller);

  }


  void updateLocation()async{
    try{
      await _determinePosition();
      position = await Geolocator.getLastKnownPosition();
      if(position!=null){
        animateCameraToPosition(position?.latitude ?? 0, position?.longitude ?? 0);
      }
    }catch(e){
      print('Error: $e');
    }

  }

  Future animateCameraToPosition(double lat, double lng) async {
    GoogleMapController controller = await mapController.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        target: LatLng(lat, lng),
        zoom:20
      )
    ));
   
  }

  void checkGPS() async {
    bool isLocationEnabled =  await  Geolocator.isLocationServiceEnabled();
    if(isLocationEnabled){
      updateLocation();
    }else{
      bool locationGPS =await  location.Location().requestService();
      if(locationGPS) {
        updateLocation();
      }
    }
  }

  Future<Position> _determinePosition() async 
  {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
      return Future.error('Location permissions are denied');
      }
    }
    
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
    } 

    return await Geolocator.getCurrentPosition();
  }

}