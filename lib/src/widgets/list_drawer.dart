import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/utils/my_colors.dart';

class ListDrawer extends StatelessWidget {
  final controller;
  final List<Widget>? ListTiles; // Lista de ListTile adicionales

  const ListDrawer({Key? key, required this.controller, this.ListTiles}) : super(key: key);

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
                  height: 80,
                  margin: EdgeInsets.only(top:5),
                  child: FadeInImage(
                    image: (controller.user?.image != null)
                        ? NetworkImage(controller.user?.image ?? '')
                        : AssetImage('assets/img/no-image.png') as ImageProvider<Object>,
                    fit: BoxFit.contain,
                    fadeInDuration: Duration(milliseconds: 50),
                    placeholder: AssetImage('assets/img/no-image.png'),
                  ),
                )
              ]
            ),
          ),
          
          ListTile(
            onTap: controller.gotoUpdatePage,
            title: Text("Editar perfil"),
            trailing:  Icon(Icons.edit_outlined),
          ),
          ListTile(
            onTap: controller.goToOrdersList,
            title: Text("Mis pedidos"),
            trailing:  Icon(Icons.shopping_cart_outlined),
          ),
          if (controller.hasRoles())
            ListTile(
              onTap: controller.gotoRoles,
              title: Text("Seleccionar rol "),
              trailing:  Icon(Icons.person_outline),
            ),

          // Agregar los ListTile adicionales si existen
          if (ListTiles != null)
            ...ListTiles!,

            
          ListTile(
            onTap: controller.logout,
            title: Text("Cerrar sesión"),
            trailing:  Icon(Icons.power_settings_new),
          ),

        ],
      ),
    );
  }
}
