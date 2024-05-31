import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_application_1/src/pages/client/address/list/client_address_list_controller.dart';
import 'package:flutter_application_1/src/utils/my_colors.dart';


class ClientAddressListPage extends StatefulWidget {
  const ClientAddressListPage({super.key});

  @override
  State<ClientAddressListPage> createState() => _ClientAddressListPageState();
}

class _ClientAddressListPageState extends State<ClientAddressListPage> {

  ClientAddressListController controller = new ClientAddressListController();

    
 @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp)async  { 
     await controller.init(context, refresh);
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
        title:Text('Direcciones'),
        actions: [_iconAdd()],
      ),
      body: Container(
        width: double.infinity,
        child: ListView(
          children: [
            _textSelectAddress(),
            _list()
          ],
        )
      ),
      bottomNavigationBar: _buttonAccept(),

    );
  }



 Widget _list(){

  if(controller.addresses.length<1) {

    return Container(
        margin: EdgeInsets.only(bottom:60),
        child:Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/img/no_items.png'),
            Text('No hay direcciones')
          ],
        ) ,
      );
  }


  int i=-1;

  return Column(
    children: controller.addresses.map((e){
    i++;
    return _radioSelectAddress(e ,i);
  }).toList());

 }

  Widget _radioSelectAddress(address, int index){
    return Container(
      margin:EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Radio(
            value: index,
            groupValue: controller.radioValue,
          onChanged: controller.handleRadio
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              
              Text(
                address.address ?? '',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold
                ),
                
              ),
               Text(
                address.neighborhood ?? '',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.normal
                ),
                
              )

            ],
          ),
          Divider(
            color:Colors.grey
          )
        ],
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
        onPressed: controller.createOrder,
        child:Text('Aceptar', style: TextStyle(color:Colors.white)),
      )
    );
  }
  
  Widget _textSelectAddress() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 40,vertical: 30),
      child: Text(
        'Elige donde recibir tus compras',
        style:TextStyle(
          fontSize: 19,
          fontWeight: FontWeight.bold
        )
      ),
    );
  }
  Widget _iconAdd(){
    return IconButton(onPressed: controller.addAddress, icon: Icon(Icons.add));
  }

}