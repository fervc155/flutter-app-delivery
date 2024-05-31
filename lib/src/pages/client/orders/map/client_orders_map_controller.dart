import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/api/environment.dart';
import 'package:flutter_application_1/src/models/order.dart';
import 'package:flutter_application_1/src/models/user.dart';
import 'package:flutter_application_1/src/providers/order_provider.dart';
import 'package:flutter_application_1/src/utils/my_colors.dart';
import 'package:flutter_application_1/src/utils/share_pref.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as location;
import 'package:url_launcher/url_launcher.dart';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';
class ClientOrdersMapController {

  late BuildContext context;
  late Function refresh;
  late Position _position;

  String addressName='';
  LatLng? addressLatLng;

  CameraPosition initialPosition = CameraPosition(
    target: LatLng(1.2125178, -77.2737861),
    zoom: 14
  );

  Completer<GoogleMapController> _mapController = Completer();

  BitmapDescriptor? deliveryMarker;
  BitmapDescriptor? homeMarker;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  Order? order;

  Set<Polyline> polylines = {};
  List<LatLng> points = [];

  OrderProvider _ordersProvider = new OrderProvider();
  User? user;
  SharePref _sharedPref = new SharePref();

  double _distanceBetween=0;
//  IO.Socket socket;


  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    order = Order?.fromJson(ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>);
    deliveryMarker = await createMarkerFromAsset('assets/img/delivery2.png');
    homeMarker = await createMarkerFromAsset('assets/img/home.png');

    // socket = IO.io('http://${Environment.API_DELIVERY}/orders/delivery', <String, dynamic> {
    //   'transports': ['websocket'],
    //   'autoConnect': false
    // });
    // socket.connect();

    // socket.on('position/${order?.id}', (data) {
    //   print('DATA EMITIDA: ${data}');

    //   addMarker(
    //       'delivery',
    //       data['lat'],
    //       data['lng'],
    //       'Tu repartidor',
    //       '',
    //       deliveryMarker
    //   );

    // });

    dynamic userJson = await _sharedPref.user();   
    this.user=  User.fromJson( userJson);
    _ordersProvider.init(context, user);
    print('ORDEN: ${order?.toJson()}');
    checkGPS();
  }

  void isCloseToDeliveryPosition() {
    _distanceBetween = Geolocator.distanceBetween(
        _position.latitude,
        _position.longitude,
        order?.address?.lat??0,
        order?.address?.lng??0
    );

    print('-------- DISTANCIA ${_distanceBetween} ----------');
  }


  Future<void> setPolylines(LatLng from, LatLng to) async {
    PointLatLng pointFrom = PointLatLng(from.latitude, from.longitude);
    PointLatLng pointTo = PointLatLng(to.latitude, to.longitude);
    PolylineResult result = await PolylinePoints().getRouteBetweenCoordinates(
        Environment.API_KEY_MAPS,
        pointFrom,
        pointTo
    );

    for(PointLatLng point in result.points) {
      points.add(LatLng(point.latitude, point.longitude));
    }

    Polyline polyline = Polyline(
        polylineId: PolylineId('poly'),
        color: MyColors.primaryColor,
        points: points,
        width: 6
    );

    polylines.add(polyline);



    refresh();
  }

  void addMarker(
      String markerId,
      double lat,
      double lng,
      String title,
      String content,
      BitmapDescriptor iconMarker) {

    MarkerId id = MarkerId(markerId);
    Marker marker = Marker(
        markerId: id,
        icon: iconMarker,
        position: LatLng(lat, lng),
        infoWindow: InfoWindow(title: title, snippet: content)
    );

    markers[id] = marker;

    refresh();
  }

  void selectRefPoint() {
    Map<String, dynamic> data = {
      'address': addressName,
      'lat': addressLatLng?.latitude ??0,
      'lng': addressLatLng?.longitude??0,
    };
    
    Navigator.pop(context, data);
  }

Future<BitmapDescriptor> createMarkerFromAsset(String assetPath, {double width = 180, double height = 180}) async {
  final ByteData byteData = await rootBundle.load(assetPath);
  final ui.Codec codec = await ui.instantiateImageCodec(
    byteData.buffer.asUint8List(),
    targetWidth: width.toInt(),
    targetHeight: height.toInt(),
  );
  final ui.FrameInfo frameInfo = await codec.getNextFrame();
  final ByteData? resizedByteData = await frameInfo.image.toByteData(format: ui.ImageByteFormat.png);
  final Uint8List resizedBytes = resizedByteData!.buffer.asUint8List();

  return BitmapDescriptor.fromBytes(resizedBytes);
}


  Future<Null> setLocationDraggableInfo() async {

       double lat = initialPosition.target.latitude;
      double lng = initialPosition.target.longitude;

      List<Placemark> address = await placemarkFromCoordinates(lat, lng);

        if (address.length > 0) {
          String direction = address[0].thoroughfare ??'';
          String street = address[0].subThoroughfare ??'';
          String city = address[0].locality ??'';
          String department = address[0].administrativeArea ??'';
    //      String country = address[0].country ??'';
          addressName = '$direction #$street, $city, $department';
          addressLatLng = new LatLng(lat, lng);
          // print('LAT: ${addressLatLng.latitude}');
          // print('LNG: ${addressLatLng.longitude}');

          refresh();
        }
  
  }

  void onMapCreated(GoogleMapController controller) {
 //   controller.setMapStyle('[{"elementType":"geometry","stylers":[{"color":"#f5f5f5"}]},{"elementType":"labels.icon","stylers":[{"visibility":"off"}]},{"elementType":"labels.text.fill","stylers":[{"color":"#616161"}]},{"elementType":"labels.text.stroke","stylers":[{"color":"#f5f5f5"}]},{"featureType":"administrative.land_parcel","elementType":"labels.text.fill","stylers":[{"color":"#bdbdbd"}]},{"featureType":"poi","elementType":"geometry","stylers":[{"color":"#eeeeee"}]},{"featureType":"poi","elementType":"labels.text.fill","stylers":[{"color":"#757575"}]},{"featureType":"poi.park","elementType":"geometry","stylers":[{"color":"#e5e5e5"}]},{"featureType":"poi.park","elementType":"labels.text.fill","stylers":[{"color":"#9e9e9e"}]},{"featureType":"road","elementType":"geometry","stylers":[{"color":"#ffffff"}]},{"featureType":"road.arterial","elementType":"labels.text.fill","stylers":[{"color":"#757575"}]},{"featureType":"road.highway","elementType":"geometry","stylers":[{"color":"#dadada"}]},{"featureType":"road.highway","elementType":"labels.text.fill","stylers":[{"color":"#616161"}]},{"featureType":"road.local","elementType":"labels.text.fill","stylers":[{"color":"#9e9e9e"}]},{"featureType":"transit.line","elementType":"geometry","stylers":[{"color":"#e5e5e5"}]},{"featureType":"transit.station","elementType":"geometry","stylers":[{"color":"#eeeeee"}]},{"featureType":"water","elementType":"geometry","stylers":[{"color":"#c9c9c9"}]},{"featureType":"water","elementType":"labels.text.fill","stylers":[{"color":"#9e9e9e"}]}]');
    _mapController.complete(controller);
  }

  void dispose() {
   // socket?.disconnect();
  }

  void updateLocation() async {
    try {

      await _determinePosition(); // OBTENER LA POSICION ACTUAL Y TAMBIEN SOLICITAR LOS PERMISOS

      // addMarker(
      //     'delivery',
      //     _position.latitude,
      //     _position.longitude,
      //     'Tu posicion',
      //     '',
      //     deliveryMarker
      // );

      animateCameraToPosition(order?.lat??0, order?.lng??0);
      addMarker(
          'delivery',
          order?.lat??0,
          order?.lng??0,
          'Tu repartidor',
          '',
          deliveryMarker!
      );


      addMarker(
          'home',
          order?.address?.lat??0,
          order?.address?.lng??0,
          'Lugar de entrega',
          '',
          homeMarker!
      );

      LatLng from = new LatLng(order?.lat??0, order?.lng??0);
      LatLng to = new LatLng(order?.address?.lat??0, order?.address?.lng??0);

      setPolylines(from, to);
      
      refresh();
    } catch(e) {
      print('Error: $e');
    }
  }

  void call() {
    launchUrl(Uri.parse("tel://${order?.client?.phone??0}"));
  }

  void checkGPS() async {
    bool isLocationEnabled = await Geolocator.isLocationServiceEnabled();

    if (isLocationEnabled) {
      updateLocation();
    }
    else {
      bool locationGPS = await location.Location().requestService();
      if (locationGPS) {
        updateLocation();
      }
    }
  }

  Future animateCameraToPosition(double lat, double lng) async {
    GoogleMapController controller = await _mapController.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
            target: LatLng(lat, lng),
            zoom: 13,
            bearing: 0
        )
      ));
  
  }

  Future<Position> _determinePosition() async {
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
      return Future.error('Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }


}