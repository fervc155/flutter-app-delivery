import "dart:convert";
import "dart:io";

import "package:flutter/material.dart";
import "package:flutter_application_1/src/models/user.dart";
import "package:flutter_application_1/src/providers/user_provider.dart";
import "package:flutter_application_1/src/utils/my_snapbar.dart";
import "package:image_picker/image_picker.dart";
import "package:sn_progress_dialog/sn_progress_dialog.dart";

class RegisterController {

  late BuildContext context;
  Function? refresh;
  bool isEnabled=true;

  init(BuildContext c, Function refresh) {
    this.context = c;
    uProvider.init(c);
    this.refresh = refresh;
    pd = new ProgressDialog(context: context);

  }

  late ProgressDialog pd;
  UserProvider uProvider = new UserProvider();

  TextEditingController email = new TextEditingController();
  TextEditingController name = new TextEditingController();
  TextEditingController lastname = new TextEditingController();
  TextEditingController phone = new TextEditingController();
  TextEditingController password = new TextEditingController();
  TextEditingController passwordconfirm = new TextEditingController();
  PickedFile? xf;
  File? file;
 

  void goToLoginPage() {
    Navigator.pushNamed(context, 'login');
  }

  void register() async {
    String email = this.email.text.trim();
    String name = this.name.text.trim();
    String lastname = this.lastname.text.trim();
    String phone = this.phone.text.trim();
    String password = this.password.text.trim();
    String passwordconfirm = this.passwordconfirm.text.trim();

  if(email.isEmpty || name.isEmpty || lastname.isEmpty || phone.isEmpty || password.isEmpty || passwordconfirm.isEmpty) {
    MySnapbar.show(context, "Debes ingresar todos los campos");
    return;
  }

  if(password != passwordconfirm) {
      MySnapbar.show(context, "Las passworrd no son iguales");
    return;
  };

  if(password.length<6) {
    MySnapbar.show(context, "Las passworrd min 6 caracteres");
    return;
  }

  if(file == null) {
    MySnapbar.show(context, 'Porfavor selecciona una imagen');
    return;
  }

  pd.show(max:100, msg:'Espere un momento');

    User user = new User(
      email:email,
      name:name,
      lastname:lastname,
      phone:phone,
      password:password

    );


  this.isEnabled=false;
    Stream? stream = await uProvider.createaWithImage(user, file!);

  

     if(stream!=null){
       stream.listen((res) {
        final responseApi = (json.decode(res));
    
        if(responseApi['success'] == true) {
          MySnapbar.show(context,  'Correcto, Ahora inicia sesion');
          Navigator.pushNamedAndRemoveUntil(context, 'login', (route) => false);
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
    refresh!();
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