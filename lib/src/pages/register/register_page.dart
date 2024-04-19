import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_application_1/src/pages/register/register_controller.dart';
import 'package:flutter_application_1/src/utils/my_colors.dart';


class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => controllerPageState();
}

class controllerPageState extends State<RegisterPage> {

  RegisterController controller = new RegisterController();

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) { 
      controller.init(context,refresh);
    });
  }

  refresh() { setState(() {
    
  });}

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
            onPressed: () {print('click');},
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
      return GestureDetector(
        onTap: controller.showAlertDialog,
        child: Container(
          margin: EdgeInsets.only(
            top: 150,
            bottom:30,
            ),
          child:  CircleAvatar(
            radius: 60,
            backgroundImage:  controller.file != null ?
            FileImage(controller.file!)
            : AssetImage('assets/img/user_profile.png') as ImageProvider<Object>?
            )
        )
      );
    }

    Widget controllerButton() {
      return Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
        child: ElevatedButton(
        onPressed: controller.isEnabled? controller.register: null, 
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
                controller.goToLoginPage();
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
              controller: controller.email,
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
                              controller: controller.name,

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
                              controller: controller.phone,
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
                              controller: controller.password,

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
                              controller: controller.lastname,

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
                controller: controller.passwordconfirm,
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
                controllerButton(),
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