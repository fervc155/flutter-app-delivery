
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/api/environment.dart';
import 'package:flutter_application_1/src/models/response_api.dart';
import 'package:flutter_application_1/src/models/user.dart';
import 'package:flutter_application_1/src/utils/share_pref.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:path/path.dart' as path;

class UserProvider {
  
  String _url = Environment.API_DELIVERY;
  String _api = '/api/users';

  BuildContext? context;
  late String token;

  init(BuildContext context, {String token=''}) {
    this.context = context;
    this.token=token;
  }

  Future<ResponseApi?> create(User user) async {
    Uri url = Uri.http(_url, '$_api/create');

    String bodyParams = json.encode(user.toJson());
    Map<String, String> headers = {
      'Content-type':'application/json'
    };



    try {
      final response  = await  http.post(url, headers:headers, body:bodyParams);
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

  Future<ResponseApi?> login(String email, String password) async {
    Uri url = Uri.http(_url, '$_api/login');

    String bodyParams = json.encode({
      'email':email,
      'password':password
    });
    Map<String, String> headers = {
      'Content-type':'application/json'
    };



    try {
      final response  = await  http.post(url, headers:headers, body:bodyParams);
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

  Future<Stream?> createaWithImage(User user, File image) async {
    try {
      Uri uri = Uri.http(_url, '$_api/create');
      final request = http.MultipartRequest('POST', uri);
      final length = await image.length();
      request.files.add(http.MultipartFile(
        'image',
        http.ByteStream(image.openRead().cast()),
        length,
        filename: path.basename(image.path)  
      ));

      request.fields['user']=json.encode(user.toJson());
      final response = await request.send(); 
      return response.stream.transform(utf8.decoder);

      
    }catch(e) {
      print(e);
      return null;
    }
  }

  Future<dynamic> getById(String id) async {
    try {
      Uri uri = Uri.http(_url, '$_api/findById/${id}');
      Map<String, String> headers = {
        'Content-type':'application/json',
        'Authorization':token,
      };

      final res =await http.get(uri, headers: headers);

      if(res.statusCode==401) {
        new SharePref().logout(context!);
      }
      return res.body;

    }catch(e) {
      print('Error ${e}');
      return null;
    }

  }

  dynamic update(User user) async {
    try {
      Uri uri = Uri.http(_url, '$_api/update');
      
      String bodyParams = json.encode(user.toJson());
      Map<String, String> headers = {
        'Content-type':'application/json',
        'Authorization':token,
      };


      final response = await http.put(uri, headers: headers, body: bodyParams);
      if(response.statusCode==401) {
        new SharePref().logout(context!);
      }
      return json.decode(response.body);

      
    }catch(e) {
      print('Error en stream $e');
      return null;
    }
  }


  Future<List<User>> getDeliveryMen() async {
    try {
      Uri url = Uri.http(_url, '$_api/findDeliveryMen');
      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Authorization': token
      };
      final res = await http.get(url, headers: headers);

      if (res.statusCode == 401) { // NO AUTORIZADO
        Fluttertoast.showToast(msg: 'Tu sesion expiro');
        new SharePref().logout(context!);
      }

      final data = json.decode(res.body);
      print(data);
      User user = User.fromJsonList(data);
      return user.toList;
    }
    catch(e) {
      print('Error: $e');
      return [];
    }
  }



  Future<Stream?> updateImage(User user, File image) async {

    try {
      Uri uri = Uri.http(_url, '$_api/updateImage');
  
      final request = http.MultipartRequest('PUT', uri);
      request.headers['Authorization'] = token;

      
      final length = await image.length();
      request.files.add(http.MultipartFile(
        'image',
        http.ByteStream(image.openRead().cast()),
        length,
        filename: path.basename(image.path)  
      ));

      request.fields['user']=json.encode(user.toJson());


      final response = await request.send(); 
      if(response.statusCode==401) {
        new SharePref().logout(context!);
      }
   
      return response.stream.transform(utf8.decoder);

      
    }catch(e) {
      print(e);
      return null;
    }
  }

  void logout(BuildContext ctx) async {
   

  }
}