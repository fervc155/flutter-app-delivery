

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_1/src/models/address.dart';
import 'package:flutter_application_1/src/models/user.dart';
import 'package:flutter_application_1/src/pages/client/map/client_address_map_page.dart';
import 'package:flutter_application_1/src/providers/address_provider.dart';
import 'package:flutter_application_1/src/utils/share_pref.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class ClientAddressCreateController 
{
  late BuildContext context;
  late Function refresh;

  TextEditingController refPointController = new TextEditingController();
  TextEditingController addressController = new TextEditingController();
  TextEditingController cityController = new TextEditingController();
  AddressProvider provider = new AddressProvider();
  SharePref share = new SharePref();
  
  late Map<String, dynamic> refPoint;
  late User user;


  init(BuildContext context, refresh) async
  {
    this.context =context;
    this.refresh=refresh;

    dynamic userJson = await share.user();   
    this.user =  User.fromJson( userJson);
    this.provider.init(context, user);
  }


  void openMap() async {
    refPoint = await showMaterialModalBottomSheet(
      context: context, 
      isDismissible: false,
      enableDrag: false,
      builder: (context)=> ClientAddressMapPage()
    );

  
    refPointController.text=refPoint['address'];
    refresh();

  }
  

  void createAddress() async {
    String address = addressController.text;
    String city = cityController.text;
    double lat = refPoint['lat']??0;
    double lng = refPoint['lng']??0;

    if(address.isEmpty || city.isEmpty || lat==0 || lng==0 )  {
      Fluttertoast.showToast(msg:'Completa los datos');
      return;
    }  

    Address a = new Address(
      address: address,
      neighborhood: city,
      lat: lat,
      lng: lng,
      idUser: user.id
    );

    dynamic response = await provider.create(a);

    if(response.success || response['success']) {
      Fluttertoast.showToast(msg:'Guardado');
    }

    
  }
}