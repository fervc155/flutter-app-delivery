import "package:flutter/material.dart";
import "package:flutter/scheduler.dart";
import "package:flutter_application_1/src/models/rol.dart";
import "package:flutter_application_1/src/roles/roles_controller.dart";


class RolesPage extends StatefulWidget {
  const RolesPage({super.key});

  @override
  State<RolesPage> createState() => _RolesPageState();
}

class _RolesPageState extends State<RolesPage> {
 
  RolesController controller = new RolesController();
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) { 
      controller.init(context, refresh);
    });
  }

 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text('Selecciona un rol'),
      ),
      body: ListView(
        children: 
          controller.user!=null ? controller.user!.roles!.map((Rol rol){
            return _cardRol(rol);
          }).toList():  []
        ,
      )
    );
  }


   Widget _cardRol(Rol rol) {
    return Column(
      children:[
       GestureDetector(
          onTap: (){controller.gotoPage(rol.route ?? '');},
         child: Container(
           margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.04),
           height: 100,
           child: FadeInImage(
             fit:BoxFit.contain,
             fadeInDuration: Duration(milliseconds: 50),
             image: NetworkImage(rol.image ?? ''),
             placeholder: AssetImage('assets/img/no-image.png'),
           ),
         ),
       ),
        SizedBox(height: 15),
        Text(rol.name ?? '', 
        style: TextStyle(
          fontSize: 16,
          color: Colors.black
        )
        ),
        SizedBox(height: 25),

      ]
    );
  }


  refresh() {
    setState(() {
      
    });
  }
}