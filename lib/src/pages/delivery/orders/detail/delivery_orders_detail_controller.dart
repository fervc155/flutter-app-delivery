import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/models/order.dart';
import 'package:flutter_application_1/src/models/product.dart';
import 'package:flutter_application_1/src/models/response_api.dart';
import 'package:flutter_application_1/src/models/user.dart';
import 'package:flutter_application_1/src/providers/order_provider.dart';
import 'package:flutter_application_1/src/providers/user_provider.dart';
import 'package:flutter_application_1/src/utils/share_pref.dart';
import 'package:fluttertoast/fluttertoast.dart';

class DeliveryOrdersDetailController {

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
  String idDelivery='';

  init(BuildContext context, Function refresh, Order order) async {
    this.context = context;
    this.refresh = refresh;
    this.order = order;
    dynamic userJson = await _sharedPref.user();   
    this.user=  User.fromJson( userJson);

    _ordersProvider.init(context, user);
    getTotal();
    getUsers();
    refresh();
  }

  updateOrder() async {
    if (order?.status == 'DESPACHADO') {
      ResponseApi? responseApi = await _ordersProvider.updateToOnTheWay(order!);
      Fluttertoast.showToast(msg: responseApi?.message ?? '', toastLength: Toast.LENGTH_LONG);
      if (responseApi?.success ?? false) {
        Navigator.pushNamed(context, 'delivery/orders/map', arguments: order?.toJson());
      }
    }
    else {
      Navigator.pushNamed(context, 'delivery/orders/map', arguments: order?.toJson());
    }
  }

  void getUsers() async {
    users = await _usersProvider.getDeliveryMen();
    refresh();
  }

  void getTotal() {
    total = 0;
    order?.products?.forEach((product) {
      total = total + ((product.price??0) * (product.quantity??0));
    });
    refresh();
  }

}