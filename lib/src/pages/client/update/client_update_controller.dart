import "dart:convert";
import "dart:io";

import "package:flutter/material.dart";
import "package:flutter_application_1/src/models/user.dart";
import "package:flutter_application_1/src/providers/user_provider.dart";
import "package:flutter_application_1/src/utils/my_snapbar.dart";
import "package:flutter_application_1/src/utils/share_pref.dart";
import "package:fluttertoast/fluttertoast.dart";
import "package:image_picker/image_picker.dart";
import "package:sn_progress_dialog/sn_progress_dialog.dart";

class ClientUpdateController {

  late BuildContext context;
  late Function refresh;
  bool isEnabled=true;
  late User user = new User.fromJson({});
  SharePref share = new SharePref();

  init(BuildContext c, Function refresh)async  {
    this.context = c;
    this.refresh = refresh;
    pd = new ProgressDialog(context: context);
    dynamic userJson = await share.user();

    if(userJson == null) {
      return;
    }
    
    this.user =  User.fromJson( userJson);
    this.name.text = this.user.name ?? '';
    this.lastname.text = this.user.lastname ?? '';
    this.phone.text = this.user.phone ?? '';

    uProvider.init(c, token:this.user.sessionToken??'');
   
    refresh();

  }

  late ProgressDialog pd;
  UserProvider uProvider = new UserProvider();

  TextEditingController name = new TextEditingController();
  TextEditingController lastname = new TextEditingController();
  TextEditingController phone = new TextEditingController();
  PickedFile? xf;
  File? file;
 

  void goToLoginPage() {
    Navigator.pushNamed(context, 'login');
  }

  getImage() {
     if(this.user.image != null ) {
      return  NetworkImage(this.user.image!);
     }
     
    return AssetImage('assets/img/user_profile.png') as ImageProvider<Object>?;
  }
  void updateData() async {
    String name = this.name.text.trim();
    String lastname = this.lastname.text.trim();
    String phone = this.phone.text.trim();
   
  if( name.isEmpty || lastname.isEmpty || phone.isEmpty ) {
    MySnapbar.show(context, "Debes ingresar todos los campos");
    return;
  }


  pd.show(max:100, msg:'Espere un momento');

    User myUser = new User(
      id: user.id,
      name:name,
      lastname:lastname,
      phone:phone,
    );


    this.isEnabled=false;
    final responseApi = await uProvider.update(myUser);


    if(responseApi['success'] == true) {

      pd.close();

        Fluttertoast.showToast(msg: 'Correcto');
        Navigator.pushNamedAndRemoveUntil(context, 'client/products/list' , (route) => false);
        final userJson =responseApi['user'];
        this.user = User.fromJson(userJson);
          share.save('user', userJson);
          refresh();
      } else {
        print('error in res $responseApi');
        MySnapbar.show(context, responseApi['message']);
      }
      
      

      pd.close();
      this.isEnabled=true;  


  }



  void updateImage() async {

    if(file==null){
      return;
    }


    pd.show(max:100, msg:'Espere un momento');


    this.isEnabled=false;
    Stream? stream = await uProvider.updateImage(this.user, file!);

 
    if(stream!=null){
      stream.listen((res)async {


       final responseApi = (json.decode(res));

      if(responseApi['success'] == true) {

       
        if(res!=null) {
          Fluttertoast.showToast(msg: 'Correcto');
          final userRes = responseApi['user'];
          this.user = User.fromJson(userRes);
          share.save('user', userRes);
          refresh(); 
           pd.close();


        }

          
          
      } else {
          print(res);
          MySnapbar.show(context, responseApi['message']);
        }
       });
      }

      pd.close();
      this.isEnabled=true; 


  }


  pop() {
    Navigator.pop(context);
  }


  Future selectImage(ImageSource image) async{

    xf = await ImagePicker().getImage(source: image);
    if(xf!=null) {
      file = File(xf!.path);
    }

    Navigator.pop(context);
    updateImage();
  }
  showAlertDialog() {
    Widget galleryButton = ElevatedButton(
      onPressed: (){
        selectImage(ImageSource.gallery);
        
      },
      child: Text('galeria')
    );
    
    Widget cameraButton = ElevatedButton(
      onPressed: (){
        selectImage(ImageSource.camera);
        
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
}