import "package:flutter/material.dart";

class RegisterController {

  late BuildContext context;

  init(BuildContext c) {
    this.context = c;
  }


  TextEditingController email = new TextEditingController();
  TextEditingController name = new TextEditingController();
  TextEditingController lastname = new TextEditingController();
  TextEditingController phone = new TextEditingController();
  TextEditingController password = new TextEditingController();
  TextEditingController passwordconfirm = new TextEditingController();
  

  void goToLoginPage() {
    Navigator.pushNamed(context, 'login');
  }

  void register() {
    String email = this.email.text.trim();
    String name = this.name.text.trim();
    String lastname = this.lastname.text.trim();
    String phone = this.phone.text.trim();
    String password = this.password.text.trim();
    String passwordconfirm = this.passwordconfirm.text.trim();


    print(email);
    print(name);
    print(lastname);
    print(phone);
    print(password);
    print(passwordconfirm);
  }
}