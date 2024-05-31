import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_application_1/src/pages/client/update/client_update_controller.dart';
import 'package:flutter_application_1/src/utils/my_colors.dart';


class ClientUpdatePage extends StatefulWidget {
  const ClientUpdatePage({super.key});

  @override
  State<ClientUpdatePage> createState() => controllerPageState();
}

class controllerPageState extends State<ClientUpdatePage> {

  ClientUpdateController controller = new ClientUpdateController();

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) { 
      controller.init(context,refresh);
    });
  }

  refresh() { 
    
    print('refrescando');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {



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
            backgroundImage: controller.getImage(),
            )
        )
      );
    }

    Widget registeriButton() {
      return Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
        child: ElevatedButton(
        onPressed: controller.isEnabled? controller.updateData: null, 
        child: Text('Actualizar perfil'), 
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


    return Scaffold(
      bottomNavigationBar:registeriButton() ,
      appBar: AppBar(title: Text('Editar perfil')),
      body: Container(
        width: double.infinity,
        child:SingleChildScrollView(
              child: Column(
              children: [
                SizedBox(height: 30),
                _imageBanner(),
                _inputTextName(),
                _inputTextLastname(),
                _inputTextPhone(),
                 SizedBox(height: 20),
                
               
               
              ],
                ),
            )
      )
    );
  }
}