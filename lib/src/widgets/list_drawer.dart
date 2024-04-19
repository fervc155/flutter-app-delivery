import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/utils/my_colors.dart';

class ListDrawer extends StatelessWidget {

  final controller;

  const ListDrawer({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
     return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children:[
          DrawerHeader(
          decoration: BoxDecoration(color: MyColors.primaryColor),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children:[
              Text('${controller.user?.name ?? ''}',
                style:TextStyle(fontSize: 20, color:Colors.white, fontWeight: FontWeight.bold),
                maxLines: 1, 
              ),
              Text(controller.user?.email ?? '',
                style:TextStyle(fontSize: 13, color:Colors.grey[200], fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
                maxLines: 1, 
              ),
              Container(
                height: 60,
                margin: EdgeInsets.only(top:10),
                child: FadeInImage(
                image: (controller.user?.image != null) 
                      ? NetworkImage(controller.user?.image ?? '') 
                      : AssetImage('assets/img/no-image.png') as ImageProvider<Object>,                  fit: BoxFit.contain,
                  fadeInDuration: Duration(milliseconds: 50),
                  placeholder:AssetImage('assets/img/no-image.png',


                  )),
              )
            ]
          )
          ),
          
          ListTile(
            title: Text("Editar perfil"),
            trailing:  Icon(Icons.edit_outlined),
          ),
          ListTile(
            title: Text("Mis pedidos "),
            trailing:  Icon(Icons.shopping_cart_outlined),
          ),
          controller.hasRoles()
          ? ListTile(
            onTap: controller.gotoRoles,
            title: Text("Seleccionar rol "),
            trailing:  Icon(Icons.person_outline),
          ) : Container(),
          ListTile(
            onTap: controller.logout,
            title: Text("Cerrar sesion"),
            trailing:  Icon(Icons.power_settings_new),
          ),
        ],
          
      )
    );
  }

  
}