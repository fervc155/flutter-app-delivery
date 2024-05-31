// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/pages/client/orders/list/client_orders_list_page.dart';
import 'package:flutter_application_1/src/pages/client/orders/map/client_orders_map_page.dart';
import 'package:flutter_application_1/src/pages/delivery/orders/list/delivery_orders_list_page.dart';
import 'package:flutter_application_1/src/pages/client/address/create/client_address_create_page.dart';
import 'package:flutter_application_1/src/pages/client/address/list/client_address_list_page.dart';
import 'package:flutter_application_1/src/pages/client/map/client_address_map_page.dart';
import 'package:flutter_application_1/src/pages/client/orders/create/client_orders_create_page.dart';
import 'package:flutter_application_1/src/pages/client/products/list/client_products_list_page.dart';
import 'package:flutter_application_1/src/pages/client/update/client_update_page.dart';
import 'package:flutter_application_1/src/pages/delivery/orders/map/delivery_orders_map_page.dart';
import 'package:flutter_application_1/src/pages/login/login_page.dart';
import 'package:flutter_application_1/src/pages/register/register_page.dart';
import 'package:flutter_application_1/src/pages/restaurant/categories/create/restaurant_categories_create_page.dart';
import 'package:flutter_application_1/src/pages/restaurant/orders/list/restaurant_orders_list_page.dart';
import 'package:flutter_application_1/src/pages/restaurant/products/create/restaurant_products_create_page.dart';
import 'package:flutter_application_1/src/pages/roles/roles_page.dart';
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
        appBarTheme: AppBarTheme(elevation: 0)
      ),
      title: 'Delivery app flutter',
      initialRoute: 'login',
      debugShowCheckedModeBanner: false,
      routes: {
        'login':  (BuildContext bc) => LoginPage(),
        'register':  (BuildContext bc) => RegisterPage(),
        'roles': (BuildContext bc)=> RolesPage(),
     
        'client/products/list': (BuildContext bc)=> ClientProductsListPage(),
        'client/orders/list' : (BuildContext context) => ClientOrdersListPage(),
        'client/orders/map' : (BuildContext context) => ClientOrdersMapPage(),
        
        'client/orders/create': (BuildContext bc)=> ClientOrdersCreatePage(),
        'client/address/create': (BuildContext bc)=> ClientAddressCreatePage(),
        'client/address/list': (BuildContext bc)=> ClientAddressListPage(),
        'client/address/map': (BuildContext bc)=> ClientAddressMapPage(),
        'client/update': (BuildContext bc)=> ClientUpdatePage(),
     
        'delivery/orders/list': (BuildContext bc)=> DeliveryOrdersListPage(),
        'delivery/orders/map': (BuildContext bc)=> DeliveryOrdersMapPage(),

        'restaurant/orders/list': (BuildContext bc)=> RestaurantOrdersListPage(),
        'restaurant/categories/create': (BuildContext bc)=> RestaurantCategoryCreate(),
        'restaurant/products/create': (BuildContext bc)=>  RestaurantProductCreate(),
      }
    );
  }

 
}