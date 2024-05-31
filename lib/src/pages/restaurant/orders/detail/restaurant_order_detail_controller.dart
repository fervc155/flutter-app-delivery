import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/models/order.dart';
import 'package:flutter_application_1/src/models/product.dart';
import 'package:flutter_application_1/src/models/response_api.dart';
import 'package:flutter_application_1/src/models/user.dart';
import 'package:flutter_application_1/src/providers/order_provider.dart';
import 'package:flutter_application_1/src/providers/user_provider.dart';
import 'package:flutter_application_1/src/utils/share_pref.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RestaurantOrdersDetailController {

  late BuildContext context;
  late Function refresh;

  late Product product;

  int counter = 1;
  double productPrice=0;

  SharePref _sharedPref = new SharePref();

  double total = 0;
  Order? order;

  late User user;
  List<User> users = [];
  UserProvider _usersProvider = new UserProvider();
  OrderProvider _ordersProvider = new OrderProvider();
  //PushNotificationsProvider pushNotificationsProvider = new PushNotificationsProvider();
  String? idDelivery;

  init(BuildContext context, Function refresh, Order order) async {
    this.context = context;
    this.refresh = refresh;
    this.order = order;
    dynamic json = await _sharedPref.user();
    this.user =User.fromJson(json);
  
    _usersProvider.init(context, token:user.sessionToken??'');
    _ordersProvider.init(context, user);

    getTotal();
    getUsers();
    refresh();
  }

  void sendNotification(String tokenDelivery) {

    // Map<String, dynamic> data = {
    //   'click_action': 'FLUTTER_NOTIFICATION_CLICK'
    // };

    // pushNotificationsProvider.sendMessage(
    //     tokenDelivery,
    //     data,
    //     'PEDIDO ASIGNADO',
    //     'te han asignado un pedido'
    // );
  }

  void updateOrder() async {
    if (idDelivery != null) {
      order!.idDelivery = idDelivery;
      ResponseApi? responseApi = await _ordersProvider.updateToDispatched(order!);

    //  User deliveryUser = await _usersProvider.getById(order!.idDelivery??'');
     // sendNotification(deliveryUser.notificationToken);

      Fluttertoast.showToast(msg: responseApi?.message ??'', toastLength: Toast.LENGTH_LONG);
      Navigator.pop(context, true);
    }
    else {
      Fluttertoast.showToast(msg: 'Selecciona el repartidor');
    }
  }

  void getUsers() async {
    users = await _usersProvider.getDeliveryMen();
    print(users);
    refresh();
  }

  void getTotal() {
    total = 0;
    order!.products?.forEach((product) {
      total = total + ((product.price ??0)* (product.quantity??0));
    });
    refresh();
  }

}