import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/models/category.dart';
import 'package:flutter_application_1/src/models/product.dart';
import 'package:flutter_application_1/src/models/user.dart';
import 'package:flutter_application_1/src/providers/category_provider.dart';
import 'package:flutter_application_1/src/providers/product_provider.dart';
import 'package:flutter_application_1/src/utils/my_snapbar.dart';
import 'package:flutter_application_1/src/utils/share_pref.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';


class RestaurantProductCreateController {


  late BuildContext context;
  late  Function refresh;
  ProductProvider provider = new ProductProvider();
  CategoryProvider categoryProvider = new CategoryProvider();
  SharePref share = new SharePref();
  late User user;
  TextEditingController name = new TextEditingController();
  TextEditingController description = new TextEditingController();
  TextEditingController price = new TextEditingController();
  String idCategory='';
 List<Category> categories =[];
  PickedFile? xf;
  File? file1;
  File? file2;
  File? file3;
 late ProgressDialog dialog;
 

  void getCategories() async{

     this.categories = await categoryProvider.getAll();
     this.idCategory = this.categories[0].id??'';
     refresh();

  }



  Future selectImage(ImageSource image, int number) async{

    xf = await ImagePicker().getImage(source: image);
    if(xf!=null) {
      if(number==1) file1 = File(xf!.path);
      if(number==2) file2 = File(xf!.path);
      if(number==3) file3 = File(xf!.path);
      
    }

    Navigator.pop(context);
    refresh();
  }
  showAlertDialog(int numberFile) {
    Widget galleryButton = ElevatedButton(
      onPressed: (){
        selectImage(ImageSource.gallery, numberFile);
      },
      child: Text('galeria')
    );
    
    Widget cameraButton = ElevatedButton(
      onPressed: (){
        selectImage(ImageSource.camera, numberFile);
      },
      child: Text('camara')
    );

    AlertDialog alertDialog = AlertDialog(
      title: Text('Selecciona tu imagen'),
      actions: [ galleryButton, cameraButton],
    );


    showDialog(context: context, builder: (BuildContext context) {
      return alertDialog;
    });
  }

  
  init(BuildContext context, refresh) async  {
    this.context= context;
    this.refresh =refresh;
    dynamic json = await share.user();
    this.user =User.fromJson(json);
    provider.init(context, this.user);
    categoryProvider.init(context, this.user);
    this.getCategories();
    dialog = new ProgressDialog(context: context);

  }


  void createProduct() async {
    String name = this.name.text;
    String description = this.description.text;
    double price = double.parse(this.price.text);
    if(name.isEmpty || description.isEmpty || this.price.text.isEmpty) {
      MySnapbar.show(context, 'Completa los campos');
      return;
    }

    if(file1==null || file2==null || file3==null) {
      MySnapbar.show(context, 'Completa los campos');
      return;
    }

    if(idCategory=='') {
      MySnapbar.show(context, 'Completa los campos');
      return;
    }


    Product c = new Product(
      name:name,
      description:description,
      price:price,
      idCategory: int.parse(idCategory),
      
    );

    Stream? stream = await provider.create(c, [
      file1!, file2!, file3!
    ]);


 
    if(stream!=null) 
    {
      this.dialog.show(max:100, msg:'Espera un momento');
      stream.listen((res) {

        final resJson = json.decode(res);
        print(res);

        if(resJson['success']){
          this.name.text='';
          this.description.text='';
          this.price.text='';
          this.idCategory= this.categories[0].id??'';;
          this.file1=null;
          this.file2=null;
          this.file3=null;
          this.dialog.close();
          MySnapbar.show(context, 'Categoria creada correctamente');
          refresh();
        }

      });

}

   
  }

}