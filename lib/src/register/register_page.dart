import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_application_1/src/register/register_controller.dart';
import 'package:flutter_application_1/src/utils/my_colors.dart';


class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  RegisterController _Register = new RegisterController();

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) { 
      _Register.init(context);
    });
  }

  @override
  Widget build(BuildContext context) {

    Widget _circleRegister() {
      return Container(
        width: 300,
        height: 230,
        decoration: BoxDecoration( 
          borderRadius: BorderRadius.circular(100),
          color: MyColors.primaryColor,
        ),
      //  child: ,

      );
    }

    Widget _textRegister() {
      return Row(
        children: [
          IconButton(
            icon:Icon(Icons.arrow_back_ios),
            onPressed: (){},
            color:Colors.white
          ),
          Text('REGISTRO', 
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20
            )
          )
        
        ]
      );
  }



    Widget _imageBanner() {
      return Container(
        margin: EdgeInsets.only(
          top: 150,
          bottom:30,
          ),
        child:  CircleAvatar(
          radius: 60,
          backgroundImage: AssetImage('assets/img/user_profile.png'),)
      );
    }

    Widget _RegisterButton() {
      return Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
        child: ElevatedButton(
        onPressed: _Register.register, 
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

    Widget _HaveAccount() {
      return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            Text('tienes cuenta?'),
            SizedBox(width: 10),
                        GestureDetector(
              onTap: (){
                _Register.goToLoginPage();
              },
              child:             Text('Login', style: TextStyle(fontWeight: FontWeight.bold, color: MyColors.primaryColor),)

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
              controller: _Register.email,
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

    Widget _inputTextName() {
      return Container(
            margin: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
            decoration: BoxDecoration(
              color: MyColors.primaryColorLight,
              borderRadius: BorderRadius.circular(100),
            ),
            child: TextField( 
                              controller: _Register.name,

              decoration: InputDecoration(
                hintText: 'Nombre',
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(15),
                hintStyle:  TextStyle(color: MyColors.primaryHintText),
                prefixIcon: Icon(
                  Icons.person,
                  color: MyColors.primaryColor),
                ),
              )
          );
    }
    Widget _inputTextPhone() {
      return Container(
            margin: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
            decoration: BoxDecoration(
              color: MyColors.primaryColorLight,
              borderRadius: BorderRadius.circular(100),
            ),
            child: TextField( 
                              controller: _Register.phone,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                hintText: 'Telefono',
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(15),
                hintStyle:  TextStyle(color: MyColors.primaryHintText),
                prefixIcon: Icon(
                  Icons.phone,
                  color: MyColors.primaryColor),
                ),
              )
          );
    }
    Widget _inputTextPasswordConfirm() {
      return Container(
            margin: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
            decoration: BoxDecoration(
              color: MyColors.primaryColorLight,
              borderRadius: BorderRadius.circular(100),
            ),
            child: TextField( 
              obscureText: true,
                              controller: _Register.password,

              decoration: InputDecoration(
                hintText: 'Repetir password',
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(15),
                hintStyle:  TextStyle(color: MyColors.primaryHintText),
                prefixIcon: Icon(
                  Icons.lock_outline_sharp,
                  color: MyColors.primaryColor),
                ),
              )
          );
    }

    Widget _inputTextLastname() {
      return Container(
            margin: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
            decoration: BoxDecoration(
              color: MyColors.primaryColorLight,
              borderRadius: BorderRadius.circular(100),
            ),
            child: TextField( 
                              controller: _Register.lastname,

              decoration: InputDecoration(
                hintText: 'Apellido',
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(15),
                hintStyle:  TextStyle(color: MyColors.primaryHintText),
                prefixIcon: Icon(
                  Icons.person_outline,
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
                controller: _Register.passwordconfirm,
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
              child: _circleRegister()
            ),
            Positioned(
              top:60,
              left: 30,
              child: _textRegister()
              ),
            SingleChildScrollView(
              child: Column(
              children: [
                _imageBanner(),
                _inputTextEmail(),
                _inputTextName(),
                _inputTextLastname(),
                _inputTextPhone(),
                _inputTextPassword(),
                _inputTextPasswordConfirm(),
                 SizedBox(height: 20),
                _RegisterButton(),
                SizedBox(height: 20),
                _HaveAccount()
              ],
                ),
            ),
          ]
        ),
      )
    );
  }
}