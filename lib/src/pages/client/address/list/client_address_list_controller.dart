

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/models/address.dart';
import 'package:flutter_application_1/src/models/order.dart';
import 'package:flutter_application_1/src/models/product.dart';
import 'package:flutter_application_1/src/models/user.dart';
import 'package:flutter_application_1/src/providers/address_provider.dart';
import 'package:flutter_application_1/src/providers/order_provider.dart';
import 'package:flutter_application_1/src/utils/share_pref.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ClientAddressListController 
{
  late BuildContext context;
  late Function refresh;
  late User user;
  bool ready=false;
  SharePref share = new SharePref();
  List<Address> addresses= [];
  AddressProvider provider = new AddressProvider();
  dynamic selected=0;
  List<Product> selectedProducts = [];
  OrderProvider orderProvider = new OrderProvider();

  init(BuildContext context, refresh) async 
  {
    this.context =context;
    this.refresh=refresh;
    dynamic userJson = await share.user();   
    this.user =  User.fromJson( userJson);
    this.provider.init(context, user);
    this.orderProvider.init(context, user);
    this.ready=true;
    this.loadAddress();
    print('ya');
  }

  int radioValue=0;

  handleRadio(int? value){
    this.radioValue=value ?? 0;
    refresh();
  }

  Future<List<Address>>? loadAddress() async {
    print('llamando a user');
    dynamic res = await this.provider.getByUser(this.user.id);

    if(res?.length > 0) {
      this.addresses= res;
      this.selected=res[0].id;
      refresh();
      return this.addresses;
    }

    return [];

  }



  createOrder() async {
    dynamic jsonList= await share.read('order') ?? '[]';
    jsonList = jsonDecode(jsonList);
    selectedProducts = Product.fromJsonList(jsonList).toList;



    Order order = new Order(
      idClient:this.user.id??'',
      idAddress: this.addresses[int.parse(this.selected)].id,
      products:  selectedProducts

    );

    dynamic res = await orderProvider.create(order);


    if(res.success || res['success']) {
      await share.save('order', []);
      Fluttertoast.showToast(msg:'Guardado');
      Navigator.pushNamedAndRemoveUntil(context, 'client/products/list', (route) => false);


    }
  }

  addAddress() async{
    await Navigator.pushNamed(context, 'client/address/create');
    
    this.loadAddress();
  }
}