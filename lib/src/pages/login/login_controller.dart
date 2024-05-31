import "package:flutter/material.dart";
import "package:flutter_application_1/src/models/response_api.dart";
import "package:flutter_application_1/src/models/user.dart";
import "package:flutter_application_1/src/providers/user_provider.dart";
import "package:flutter_application_1/src/utils/my_snapbar.dart";
import "package:flutter_application_1/src/utils/share_pref.dart";

class LoginController {

  late BuildContext context;
  TextEditingController email = new TextEditingController();
  TextEditingController password = new TextEditingController();
  UserProvider userProvider = new UserProvider();
  SharePref share = new SharePref();

  init(BuildContext c) async {

    this.context = c;
    this.userProvider.init(c);

    dynamic userJson = await share.user();

    if(userJson==null) {
      return;
    }    
    User user =  User.fromJson( userJson);
    if(user.sessionToken!=null) {
      if((user.roles?.length ?? 0 )>1) {
        //  Navigator.pushNamedAndRemoveUntil(context, user.roles?[0].route ?? '', (route) => false);
        Navigator.pushNamedAndRemoveUntil(context, 'roles', (route) => false);
      } else {
        Navigator.pushNamedAndRemoveUntil(context, user.roles?[0].route ?? '', (route) => false);

      }
    }


  }


  void goToRegisterPage() {
    Navigator.pushNamed(context, 'register');
  }

  void login() async {
    String email = this.email.text.trim();
    String password = this.password.text.trim();
    ResponseApi? response = await userProvider.login(email, password);

  if(response==null) {
    MySnapbar.show(context, 'hubo un error');
  } else {
    User user = User.fromJson(response.data);

    share.save('user', response.data);


    if((user.roles?.length ?? 0 )>1) {
      Navigator.pushNamedAndRemoveUntil(context, 'roles', (route) => false);
    } else {
      Navigator.pushNamedAndRemoveUntil(context, user.roles?[0].route ?? '', (route) => false);

    }
  }

    
  }
}