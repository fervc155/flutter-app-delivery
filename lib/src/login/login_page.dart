import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/utils/my_colors.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {

    Widget _circleLogin() {
      return Container(
        width: 240,
        height: 230,
        decoration: BoxDecoration( 
          borderRadius: BorderRadius.circular(100),
          color: MyColors.primaryColor,
        ),
      //  child: ,

      );
    }

    Widget _textLogin() {
      return Text('LOGIN', 
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 20
      )
      );
    }
    Widget _imageBanner() {
      return Container(
        margin: EdgeInsets.only(
          top: 100,
          bottom: MediaQuery.of(context).size.height * 0.22,
          ),
        child: Image.asset('assets/img/delivery.png', width: 200, height: 200)
      );
    }

    Widget _loginButton() {
      return Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
        child: ElevatedButton(
        onPressed: (){}, 
        child: Text('INGRESAR'), 
        style: ElevatedButton.styleFrom(
          backgroundColor: MyColors.primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30)
          ),
          padding: EdgeInsets.symmetric(vertical: 15)
        )
      )
      );
    }

    Widget _dontHaveAccount() {
      return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            Text('No tienes cuenta?'),
            SizedBox(width: 10),
            Text('Registrate', style: TextStyle(fontWeight: FontWeight.bold, color: MyColors.primaryColor),)
          ],);
    }


    Widget _inputTextEmail() {
      return Container(
            margin: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
            decoration: BoxDecoration(
              color: MyColors.primaryColorLight,
              borderRadius: BorderRadius.circular(100),
            ),
            child: TextField( 
              decoration: InputDecoration(
                hintText: 'Correo electronico',
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(15),
                hintStyle:  TextStyle(color: MyColors.primaryHintText),
                prefixIcon: Icon(
                  Icons.email,
                  color: MyColors.primaryColor),
                ),
              )
          );
    }


    Widget _inputTextPassword() {
      return Container(
            margin: EdgeInsets.symmetric(horizontal: 50),
            decoration: BoxDecoration(
              color: MyColors.primaryColorLight,
              borderRadius: BorderRadius.circular(100),
            ),
            child: TextField( 
              decoration: InputDecoration(
                hintText: 'Password',
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(15),
                hintStyle:  TextStyle(color: MyColors.primaryHintText),
                prefixIcon: Icon(
                  Icons.lock,
                  color: MyColors.primaryColor),
                ),
              )
          );
    }
    return Scaffold(
      body: Container(
        width: double.infinity,
        child: Stack(
          children: [
            Positioned(
              top: -80,
              left: -100,
              child: _circleLogin()
            ),
            Positioned(
              top:60,
              left: 30,
              child: _textLogin()
              ),
            Column(
            children: [
              _imageBanner(),
              _inputTextEmail(),
              _inputTextPassword(),
               SizedBox(height: 20),
              _loginButton(),
              SizedBox(height: 20),
              _dontHaveAccount()
            ],
              ),
          ]
        ),
      )
    );
  }
}