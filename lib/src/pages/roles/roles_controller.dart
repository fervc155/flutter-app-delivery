import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/models/user.dart';
import 'package:flutter_application_1/src/utils/share_pref.dart';

class RolesController {

  late BuildContext context;
  SharePref share = new SharePref();
  User? user;
  Function? refresh;

  init(BuildContext c, Function refresh) async {

    this.context = c;
    this.refresh=refresh;

    dynamic userJson = await share.user();

        
     User user =  User.fromJson( userJson);
     if(user.sessionToken!=null) {
      this.user = user;
      refresh();
     }


  }

  void gotoPage(String route) {
    Navigator.pushNamedAndRemoveUntil(context, route, (route) => false);
  }

}
   