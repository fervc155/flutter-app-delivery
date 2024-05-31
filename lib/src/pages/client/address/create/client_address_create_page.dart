import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_application_1/src/pages/client/address/create/client_address_create_controller.dart';
import 'package:flutter_application_1/src/utils/my_colors.dart';


class ClientAddressCreatePage extends StatefulWidget {
  const ClientAddressCreatePage({super.key});

  @override
  State<ClientAddressCreatePage> createState() => _ClientAddressCreatePageState();
}

class _ClientAddressCreatePageState extends State<ClientAddressCreatePage> {

  ClientAddressCreateController controller = new ClientAddressCreateController();

    
 @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) { 
      controller.init(context, refresh);
    });
  }


  refresh(){
    setState(() {
      
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text('Nueva direccion'),
        
      ),
      body: Container(
        width: double.infinity,
        child: Column(
          children: [
            _textFieldAddress(),
            _textFieldCity(),
            _textRefPoint(),
           
          
          ],
        )
      ),
      bottomNavigationBar: _buttonAccept(),

    );
  }

 Widget _textFieldAddress(){
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 30,vertical: 10),
    child: TextField(
      controller: controller.addressController,
      decoration: InputDecoration(
        labelText: 'Direccion',
        suffixIcon: Icon(
          Icons.location_on,
          color: MyColors.primaryColor
        )
      ),
    )
  );
 }

 Widget _textFieldCity(){
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 30,vertical: 10),
    child: TextField(
      controller: controller.cityController,
      decoration: InputDecoration(
        labelText: 'Ciudad',
        suffixIcon: Icon(
          Icons.location_city,
          color: MyColors.primaryColor
        )
      ),
    )
  );
 }

 Widget _textRefPoint(){
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 30,vertical: 10),
    child: TextField(
      controller: controller.refPointController,
      onTap: controller.openMap,
      autofocus: false,
      focusNode: AlwaysDisabledFocusNode(),
      decoration: InputDecoration(
        labelText: 'Punto de referencia',
        suffixIcon: Icon(
          Icons.map,
          color: MyColors.primaryColor
        )
      ),
    )
  );
 }


  Widget _buttonAccept(){
    return Container(
      height: 50,
      margin: EdgeInsets.symmetric(vertical: 30, horizontal: 50),
     
      width: double.infinity,
      child:  
      ElevatedButton(
         style: ElevatedButton.styleFrom(
          backgroundColor: MyColors.primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30)
          )
        ),
        onPressed: controller.createAddress,
        child:Text('Crear direccion', style: TextStyle(color:Colors.white)),
      )
    );
  }
  

}


class AlwaysDisabledFocusNode extends FocusNode
{
  @override
  bool get hasFocus => false;
}