import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/models/category.dart';
import 'package:flutter_application_1/src/models/response_api.dart';
import 'package:flutter_application_1/src/models/user.dart';
import 'package:flutter_application_1/src/providers/category_provider.dart';
import 'package:flutter_application_1/src/utils/my_snapbar.dart';
import 'package:flutter_application_1/src/utils/share_pref.dart';


class RestaurantCategoryCreateController {


 late BuildContext context;
 late  Function refresh;
 CategoryProvider provider = new CategoryProvider();
 SharePref share = new SharePref();
 late User user;
  TextEditingController name = new TextEditingController();
  TextEditingController description = new TextEditingController();
  
  init(BuildContext context, refresh) async  {
    this.context= context;
    this.refresh =refresh;
    dynamic json = await share.user();
    this.user =User.fromJson(json);
    provider.init(context, this.user);
  }

  void createCategory() async {
    String name = this.name.text;
    String description = this.description.text;

    if(name.isEmpty || description.isEmpty) {
      MySnapbar.show(context, 'Completa los campos');
    }

    Category c = new Category(
      name:name,
      description:description
    );

    ResponseApi? res = await provider.create(c);

    if(res?.success ?? false) {
      MySnapbar.show(context, 'Categoria creada correctamente');
      this.name.text='';
      this.description.text='';

    }
  }

}