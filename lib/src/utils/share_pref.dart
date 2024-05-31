import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class SharePref {


  save(String key, value)  async {
    final prefs = await SharedPreferences.getInstance();

    if(value is String == false) {
      value = json.encode(value);
    }
    prefs.setString(key, value);
  }

  Future<dynamic> read(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }


    Future<dynamic> user() async {
     dynamic user = await this.read('user');

     if(user!=null) {
      while (user is String) {
        user = json.decode(user);
      } 

      return user;
     }

     return null;
  }


  Future<bool> contains(String key) async {
      final prefs = await SharedPreferences.getInstance();
      return prefs.containsKey(key);
  }

  Future<bool> remove(String key) async {
      final prefs = await SharedPreferences.getInstance();
      return prefs.remove(key);
  }


  void logout(BuildContext context) async {
    await remove('user');
    Navigator.pushNamedAndRemoveUntil(context, 'login', (route)=>false);
  }
  
}