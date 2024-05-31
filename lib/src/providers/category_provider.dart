

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/api/environment.dart';
import 'package:flutter_application_1/src/models/category.dart';
import 'package:flutter_application_1/src/models/response_api.dart';
import 'package:flutter_application_1/src/models/user.dart';
import 'package:flutter_application_1/src/utils/share_pref.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class CategoryProvider {

  String _url = Environment.API_DELIVERY;
  String _api = '/api/categories';

  late BuildContext context;
  late User sessionUser;

  init(BuildContext context, user) {
    this.context=context;
    this.sessionUser = user;
  }

  Future<ResponseApi?> create(Category user) async {
    Uri url = Uri.http(_url, '$_api/create');

    String bodyParams = json.encode(user.toJson());
    Map<String, String> headers = {
      'Content-type':'application/json',
      'Authorization': sessionUser.sessionToken ?? ''
    };



    try {
      final response  = await  http.post(url, headers:headers, body:bodyParams);
      if(response.statusCode==401) {
        new SharePref().logout(context);
      }
      final data = json.decode(response.body);
      if(data['success']){
        return  ResponseApi.fromJson(data);
      
      } else {
        throw data;
      }
    } catch (e) {
      print('Error $e');
      return null;
    }
  
  }


  Future<List<Category>> getAll() async {


    try{
      Uri url = Uri.http(_url, '$_api/getAll');
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
      Category category = Category.fromJsonList(data);
      return category.toList;

    } catch(e){
      print(e);
      return [];
    }
  }

}