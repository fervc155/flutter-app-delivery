
import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/models/user.dart';
import 'package:flutter_application_1/src/utils/share_pref.dart';


class ListController{


  late BuildContext context;
  SharePref share = new SharePref();
  GlobalKey<ScaffoldState> key = new GlobalKey();
  User? user;
  late Function refresh;

  init(BuildContext c, Function refresh) async {
    dynamic userJson = await share.user();   
    this.user=  User.fromJson( userJson);

    this.context = c;
    this.refresh =refresh;
    await this.refreshMenu();
  
  }


  refreshMenu() async {
      dynamic userJson = await share.user();   
      this.user=  User.fromJson( userJson);
      refresh();
  }

  logout()  {
    share.logout(context);
  }

  openDrawer() {
    key.currentState?.openDrawer();
  }

  hasRoles() {
    if(user!=null) {
      return user!.roles!.length>1;
    }

    return false;
  }

  void gotoUpdatePage() {
    Navigator.pushNamed(context, 'client/update');
  }

  gotoRoles() {
    Navigator.pushNamedAndRemoveUntil(context, 'roles', (route) => false);
  }


  void gotoCategoryCreate(){
    Navigator.pushNamed(context, 'restaurant/categories/create');
  }
  
  void goToOrdersList() {
    Navigator.pushNamed(context, 'client/orders/list');
  }
}