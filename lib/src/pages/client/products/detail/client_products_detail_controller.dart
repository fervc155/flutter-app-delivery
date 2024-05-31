

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/models/product.dart';
import 'package:flutter_application_1/src/utils/share_pref.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ClientProductDetailController
{
  late BuildContext context;
  late Function refresh;
  Product? product;
  SharePref share = new SharePref();

  int counter=1;
  double price =0.0;
  List<Product> selectedProducts = [];

  init(BuildContext context, refresh, Product product) async
  {
    this.context=context;
    this.refresh=refresh;
    this.product=product;
    price=product.price ?? 0;
    dynamic jsonList= await share.read('order') ?? '[]';
    jsonList = jsonDecode(jsonList);
    selectedProducts = Product.fromJsonList(jsonList).toList;
    print(selectedProducts);
    refresh();
  }


  void addToBag(){
    int index = selectedProducts.indexWhere((p) => product!.id==p.id);

    print(index);
    if(index<0){

      if(product!.quantity==null){
        product!.quantity=1;
      }
      selectedProducts.add(product!);
    } else {

      selectedProducts[index].quantity = counter + selectedProducts[index].quantity! ;

      print(selectedProducts[index].quantity);

    }
    share.save('order', selectedProducts );
   
    Fluttertoast.showToast(msg: 'Producto agregado');
  }
  addCounter(){
    counter++;
    price = (this.product?.price ??0) *counter;
    product?.quantity=counter;
    refresh();
  }
  removeCounter(){

    if(counter<=1){
      return;
    }
    counter--;
    price = (this.product?.price ??0) *counter;
    product?.quantity=counter;
    refresh();
  }
}