import "package:flutter/material.dart";

class LoginController {

  late BuildContext context;
  TextEditingController email = new TextEditingController();
  TextEditingController password = new TextEditingController();
  

  init(BuildContext c) {
    this.context = c;
  }


  void goToRegisterPage() {
    Navigator.pushNamed(context, 'register');
  }

  void login() {
    String email = this.email.text.trim();
    String password = this.password.text.trim();

    print('Email: $email ');
    print('password: $password');
    
  }
}