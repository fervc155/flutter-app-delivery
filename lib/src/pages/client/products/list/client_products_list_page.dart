
import "package:flutter/material.dart";
import "package:flutter/scheduler.dart";
import "package:flutter_application_1/src/pages/client/products/list/client_products_list_controller.dart";
import "package:flutter_application_1/src/widgets/list_drawer.dart";
import "package:flutter_application_1/src/widgets/list_menu_drawer.dart";


class ClientProductsListPage extends StatefulWidget {
  const ClientProductsListPage({super.key});

  @override
  State<ClientProductsListPage> createState() => _ClientProductsListPageState();
}

class _ClientProductsListPageState extends State<ClientProductsListPage> {
  ClientProductsListController controller = new ClientProductsListController();

 
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
      key: controller.key,
      appBar: AppBar(
        leading: ListMenuDrawer(controller:controller),
      ),
      drawer: ListDrawer(controller: controller),
      body: Center(
      
      child: Text('client')
    ));
  }




  void refresh() {
    setState(() {
      
    });
  }
}