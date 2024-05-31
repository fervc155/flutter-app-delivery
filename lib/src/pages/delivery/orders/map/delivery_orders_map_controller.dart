import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/api/environment.dart';
import 'package:flutter_application_1/src/models/order.dart';
import 'package:flutter_application_1/src/models/response_api.dart';
import 'package:flutter_application_1/src/models/user.dart';
import 'package:flutter_application_1/src/providers/order_provider.dart';
import 'package:flutter_application_1/src/utils/my_colors.dart';
import 'package:flutter_application_1/src/utils/my_snapbar.dart';
import 'package:flutter_application_1/src/utils/share_pref.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as location;
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
//import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:url_launcher/url_launcher.dart';


class DeliveryOrdersMapController {

  late BuildContext context;
  late Function refresh;
  Position? _position;
  StreamSubscription? _positionStream;

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

 // PushNotificationsProvider pushNotificationsProvider = new PushNotificationsProvider();

  bool isClose = false;

 // IO.Socket socket;

  init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    this.order = Order?.fromJson(ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>);
    
    deliveryMarker = await createMarkerFromAsset('assets/img/delivery2.png');
    homeMarker = await createMarkerFromAsset('assets/img/home.png');

    // socket = IO.io('http://${Environment.API_DELIVERY}/orders/delivery', <String, dynamic> {
    //   'transports': ['websocket'],
    //   'autoConnect': false
    // });
    // socket.connect();

    dynamic userJson = await _sharedPref.user();   
    this.user=  User.fromJson( userJson);

    _ordersProvider.init(context, user);
    print('ORDEN: ${order?.toJson()}');
    checkGPS();
  }

  void sendNotification(String tokenDelivery) {

    // Map<String, dynamic> data = {
    //   'click_action': 'FLUTTER_NOTIFICATION_CLICK'
    // };

    // pushNotificationsProvider.sendMessage(
    //     tokenDelivery,
    //     data,
    //     'REPARTIDOR ACERCANDOSE',
    //     'Tu repartidor esta cerca al lugar de entrega'
    // );
  }

  void saveLocation() async {
    order?.lat = _position?.latitude;
    order?.lng = _position?.longitude;
    await _ordersProvider.updateLatLng(order!);
  }

  void emitPosition() {
    // socket.emit('position', {
    //   'id_order': order?.id,
    //   'lat': _position.latitude,
    //   'lng': _position.longitude,
    // });
  }

  void isCloseToDeliveryPosition() {
    _distanceBetween = Geolocator.distanceBetween(
        _position?.latitude ??0,
        _position?.longitude ??0,
        order?.address?.lat ??0,
        order?.address?.lng ??0,
    );

    print('-------- DIOSTANCIA ${_distanceBetween} ----------');

    if (_distanceBetween <= 200 && !isClose) {
      print('-------- ESTA CERCA ${_distanceBetween} ----------');
     // print('-------- TOKEN ${order?.client.notificationToken} ----------');
     /// sendNotification(order?.client.notificationToken);
      isClose = true;
    }


  }

  void launchWaze() async {
    var url = 'waze://?ll=${order?.address?.lat.toString()},${order?.address?.lng.toString()}';
    var fallbackUrl =
        'https://waze.com/ul?ll=${order?.address?.lat.toString()},${order?.address?.lng.toString()}&navigate=yes';
    try {
      bool launched =
      await launchUrl(Uri.parse(url));
      if (!launched) {
        await launchUrl(Uri.parse(fallbackUrl));
      }
    } catch (e) {
      await launchUrl(Uri.parse(fallbackUrl));
    }
  }

  void launchGoogleMaps() async {
   var url = 'google.navigation:q=${order?.address?.lat.toString()},${order?.address?.lng.toString()}';
    var fallbackUrl =
        'https://www.google.com/maps/search/?api=1&query=${order?.address?.lat.toString()},${order?.address?.lng.toString()}';
    try {
      bool launched =
      await launchUrl(Uri.parse(url));
      if (!launched) {
        await launchUrl(Uri.parse(fallbackUrl));
      }
    } catch (e) {
      await launchUrl(Uri.parse(fallbackUrl));
    }
  }

  void updateToDelivered() async {

    if (_distanceBetween <= 200) {
      ResponseApi? responseApi = await _ordersProvider.updateToDelivered(order!);
      if (responseApi?.success??false) {
        Fluttertoast.showToast(msg: responseApi?.message??'', toastLength: Toast.LENGTH_LONG);
        Navigator.pushNamedAndRemoveUntil(context, 'delivery/orders/list', (route) => false);
      }
    }
    else {
      MySnapbar.show(context, 'Debes estar mas cerca a la posicion de entrega');
    }
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



// socket_io_client

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
      'lat': addressLatLng?.latitude,
      'lng': addressLatLng?.longitude,
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
          String direction = address[0].thoroughfare??'';
          String street = address[0].subThoroughfare??'';
          String city = address[0].locality??'';
          String department = address[0].administrativeArea??'';
        //  String country = address[0].country??'';
          addressName = '$direction #$street, $city, $department';
          addressLatLng = new LatLng(lat, lng);
          // print('LAT: ${addressLatLng.latitude}');
          // print('LNG: ${addressLatLng.longitude}');

          refresh();
        }
      

    
  }

  void onMapCreated(GoogleMapController controller) {
    _mapController.complete(controller);
  }

  void dispose() {
    _positionStream?.cancel();
   // socket?.disconnect();
  }

  void updateLocation() async {
    try {

      await _determinePosition(); // OBTENER LA POSICION ACTUAL Y TAMBIEN SOLICITAR LOS PERMISOS
      _position = await Geolocator.getLastKnownPosition(); // LAT Y LNG
      saveLocation();

      animateCameraToPosition(_position?.latitude??0, _position?.longitude??0);
      addMarker(
          'delivery',
          _position?.latitude??0,
          _position?.longitude??0,
          'Tu posicion',
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

      LatLng from = new LatLng(_position?.latitude??0, _position?.longitude??0);
      LatLng to = new LatLng(order?.address?.lat??0, order?.address?.lng??0);

      setPolylines(from, to);
      
      // _positionStream = Geolocator.getPositionStream(
      //     desiredAccuracy: LocationAccuracy.best,
      //     distanceFilter: 1
      // ).listen((Position position) {
        
      //   _position = position;

      //   emitPosition();
        
      //   addMarker(
      //       'delivery',
      //       _position.latitude,
      //       _position.longitude,
      //       'Tu posicion',
      //       '',
      //       deliveryMarker
      //   );
        
      //   animateCameraToPosition(_position.latitude, _position.longitude);
      //   isCloseToDeliveryPosition();

      //   refresh();
        
      // });

    } catch(e) {
      print('Error: $e');
    }
  }

  void call() {
//    launchUrl(Uri.parse("tel://${order?.client?.phone??''}"));
    launchUrl(Uri.parse("tel://3313131313"));
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