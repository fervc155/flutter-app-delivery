import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/models/order.dart';
import 'package:flutter_application_1/src/models/product.dart';
import 'package:flutter_application_1/src/models/user.dart';
import 'package:flutter_application_1/src/providers/order_provider.dart';
import 'package:flutter_application_1/src/providers/user_provider.dart';
import 'package:flutter_application_1/src/utils/share_pref.dart';

class ClientOrdersDetailController {

  late BuildContext context;
  late Function refresh;

  Product? product;

  int counter = 1;
  double productPrice=0;

  SharePref _sharedPref = new SharePref();

  double total = 0;
  Order? order;

  User? user;
  List<User> users = [];
  UserProvider _usersProvider = new UserProvider();
  OrderProvider _ordersProvider = new OrderProvider();
  String idDelivery='';

  Future init(BuildContext context, Function refresh, Order order) async {
    this.context = context;
    this.refresh = refresh;
    this.order = order;
    dynamic userJson = await _sharedPref.user();   
    this.user=  User.fromJson( userJson);

    _usersProvider.init(context, token: user?.sessionToken??'');
    _ordersProvider.init(context, user);
    getTotal();
    getUsers();
    refresh();
  }

  void updateOrder() async {
    Navigator.pushNamed(context, 'client/orders/map', arguments: order?.toJson());
  }

  void getUsers() async {
    users = await _usersProvider.getDeliveryMen();
    refresh();
  }

  void getTotal() {
    total = 0;
    order?.products?.forEach((product) {
      total = total + (product.price??0 * (product.quantity??0));
    });
    refresh();
  }

}