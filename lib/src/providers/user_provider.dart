
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/api/environment.dart';
import 'package:flutter_application_1/src/models/response_api.dart';
import 'package:flutter_application_1/src/models/user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:path/path.dart' as path;

class UserProvider {
  
  String _url = Environment.API_DELIVERY;
  String _api = '/api/users';

  BuildContext? context;

  init(BuildContext context) {
    this.context = context;
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
}