
import "package:flutter/material.dart";
import "package:flutter/scheduler.dart";
import "package:flutter_application_1/src/Delivery/orders/list/Delivery_orders_list_controller.dart";
import "package:flutter_application_1/src/widgets/list_drawer.dart";
import "package:flutter_application_1/src/widgets/list_menu_drawer.dart";


class DeliveryOrdersListPage extends StatefulWidget {
  const DeliveryOrdersListPage({super.key});

  @override
  State<DeliveryOrdersListPage> createState() => _DeliveryOrdersListPageState();
}

class _DeliveryOrdersListPageState extends State<DeliveryOrdersListPage> {
  DeliveryOrdersListController controller = new DeliveryOrdersListController();

 
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
      drawer: ListDrawer(controller:controller),
      body: Center(
      
      child: Text('delivery')
    ));
  }

  refresh() {
    setState(() {
      
    });
  }

}