

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/models/product.dart';
import 'package:flutter_application_1/src/utils/share_pref.dart';

class ClientOrdersCreateController
{
  late BuildContext context;
  late Function refresh;
  Product? product;
  SharePref share = new SharePref();
  double total=0.0;

  List<Product> selectedProducts = [];

  init(BuildContext context, refresh) async
  {
    this.context=context;
    this.refresh=refresh;
    this.product=product;
    dynamic jsonList= await share.read('order') ?? '[]';
    jsonList = jsonDecode(jsonList);
    selectedProducts = Product.fromJsonList(jsonList).toList;

    loadTotal();
    refresh();
  }

  

  loadTotal() {

    total=0;
   selectedProducts.forEach((p){
    final price =(p.price??0)*(p.quantity??0);
    this.total+=( price);
   });
   refresh();
    
  }

  order(){

    Navigator.pushNamed(context, 'client/address/list');
  }


  remove(Product product){
    int index = selectedProducts.indexWhere((p) => product.id==p.id);
    selectedProducts.removeAt(index);
    int quantity =selectedProducts[index].quantity ?? 0;
    selectedProducts[index].quantity=quantity-1;  
    total-=  product.subtotal() ;
    refresh();
  }      


  reduceItem(Product product){
    int index = selectedProducts.indexWhere((p) => product.id==p.id);

    int quantity =selectedProducts[index].quantity ?? 0;
    if(quantity<=1){
      return;
    }
    selectedProducts[index].quantity=quantity-1;
    total-= product.price??0;
    share.save('order', selectedProducts );

    refresh();
  }        

  increaseItem(Product product){
    int index = selectedProducts.indexWhere((p) => product.id==p.id);

    int quantity =selectedProducts[index].quantity ?? 0;
    selectedProducts[index].quantity=quantity+1;
    total+= product.price??0;
    share.save('order', selectedProducts );

   
    refresh();

  }


}