import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/models/user.dart';
import 'package:flutter_application_1/src/utils/share_pref.dart';


class ListController{


  late BuildContext context;
  SharePref share = new SharePref();
  GlobalKey<ScaffoldState> key = new GlobalKey();
  User? user;
  Function? refresh;

  init(BuildContext c, Function refresh) async {
    this.context = c;
    dynamic userJson = await share.read('user') ?? Map<String, dynamic>.from({});
    this.refresh =refresh;
    if(userJson is Map == false) {
      userJson = jsonDecode(jsonDecode(userJson));
    }
    
    User user =  User.fromJson( userJson);
    this.user=user;
    refresh();
  
  }

  logout()  {
    share.logout(context);
  }

  openDrawer() {
    key.currentState!.openDrawer();
  }

  hasRoles() {
    if(user!=null) {
      return user!.roles!.length>1;
    }

    return false;
  }

  gotoRoles() {
    Navigator.pushNamedAndRemoveUntil(context, 'roles', (route) => false);
  }
}