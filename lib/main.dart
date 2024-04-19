// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/delivery/orders/list/delivery_orders_list_page.dart';
import 'package:flutter_application_1/src/pages/client/products/list/client_products_list_page.dart';
import 'package:flutter_application_1/src/pages/login/login_page.dart';
import 'package:flutter_application_1/src/pages/register/register_page.dart';
import 'package:flutter_application_1/src/restaurant/orders/list/restaurant_orders_list_page.dart';
import 'package:flutter_application_1/src/roles/roles_page.dart';
import 'package:flutter_application_1/src/utils/my_colors.dart';

void main() {
  runApp(const MyApp());
}


class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      theme: ThemeData(
        primaryColor: MyColors.primaryColor,
        fontFamily:'NimbusSans',
      ),
      title: 'Delivery app flutter',
      initialRoute: 'login',
      debugShowCheckedModeBanner: false,
      routes: {
        'login':  (BuildContext bc) => LoginPage(),
        'register':  (BuildContext bc) => RegisterPage(),
        'client/products/list': (BuildContext bc)=> ClientProductsListPage(),
        'restaurant/orders/list': (BuildContext bc)=> RestaurantOrdersListPage(),
        'delivery/orders/list': (BuildContext bc)=> DeliveryOrdersListPage(),
        'roles': (BuildContext bc)=> RolesPage(),
      }
    );
  }

 
}