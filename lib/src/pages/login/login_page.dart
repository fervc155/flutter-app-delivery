import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_application_1/src/pages/login/login_controller.dart';
import 'package:flutter_application_1/src/utils/my_colors.dart';
import 'package:lottie/lottie.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  LoginController _login = new LoginController();

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) { 
      _login.init(context);
    });
  }

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


    Widget _lottieAnimation() {
      return Lottie.asset('assets/json/login.json', width: 350, height: 200,  fit: BoxFit.fill);
    }
    Widget _imageBanner() {
      return Container(
        margin: EdgeInsets.only(
          top: 150,
          bottom: MediaQuery.of(context).size.height * 0.2,
          ),
        child: _lottieAnimation()
      );
    }

    Widget _loginButton() {
      return Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
        child: ElevatedButton(
        onPressed:_login.login, 
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
                        GestureDetector(
              onTap: (){
                _login.goToRegisterPage();
              },
              child:             Text('Registrate', style: TextStyle(fontWeight: FontWeight.bold, color: MyColors.primaryColor),)

            ),
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
              controller: _login.email,
              keyboardType: TextInputType.emailAddress,
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
              obscureText: true,
              controller: _login.password,
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
            SingleChildScrollView(
              child: Column(
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
            ),
          ]
        ),
      )
    );
  }
}