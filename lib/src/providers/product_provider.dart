

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/api/environment.dart';
import 'package:flutter_application_1/src/models/product.dart';
import 'package:flutter_application_1/src/models/user.dart';
import 'package:flutter_application_1/src/utils/share_pref.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

class ProductProvider {

  String _url = Environment.API_DELIVERY;
  String _api = '/api/products';

  late BuildContext context;
  late User sessionUser;

  init(BuildContext context, user) {
    this.context=context;
    this.sessionUser = user;
  }

  Future<Stream?> create(Product product, List<File> files) async {
    try {
      Uri uri = Uri.http(_url, '$_api/create');
      final request = http.MultipartRequest('POST', uri);
      request.headers['Authorization'] = sessionUser.sessionToken ?? '';

      for(int i=0;i<files.length;i++){
        final image = files[i];
         final length = await image.length();
      request.files.add(http.MultipartFile(
        'image',
        http.ByteStream(image.openRead().cast()),
        length,
        filename: path.basename(image.path)  
      ));

      }


      request.fields['product']=json.encode(product.toJson());
      final response = await request.send(); 
      return response.stream.transform(utf8.decoder);

      
    }catch(e) {
      print(e);
      return null;
    }
  
  }

 Future<List<Product>> getByCategory(String idCategory) async {



    try{
      Uri url = Uri.http(_url, '$_api/findByCategory/${idCategory}');
      Map <String, String> headers= {
        'Content-type': 'application/json',
        'Authorization': sessionUser.sessionToken?? '',
      };

      final res = await http.get(url, headers: headers);

      if(res.statusCode==401) {
        Fluttertoast.showToast(msg: 'session expirada');
        new SharePref().logout(context);
      }

      final data = json.decode(res.body);
      Product p = Product.fromJsonList(data);
      return p.toList;

    } catch(e){
      print(e);
      return [];
    }
  }

}