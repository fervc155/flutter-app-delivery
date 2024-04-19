import 'package:flutter/material.dart';

class ListMenuDrawer extends StatelessWidget {

  final controller;

  const ListMenuDrawer({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
     return GestureDetector(
      onTap: controller.openDrawer,
      child: Container(
        margin: EdgeInsets.only(left: 20),
        alignment: Alignment.centerLeft,
        child:Image.asset('assets/img/menu.png', width: 20, height: 20)
      ),

    );
  }

  
}