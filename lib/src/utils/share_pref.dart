import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class SharePref {


  save(String key, value)  async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, json.encode(value));
  }

  Future<dynamic> read(String key) async {
     final prefs = await SharedPreferences.getInstance();
   
    if(prefs.getString(key) == null) {
      return null;
    }

    return json.encode(prefs.getString(key));
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