
import "package:flutter/material.dart";
import "package:flutter/scheduler.dart";
import "package:flutter_application_1/src/restaurant/orders/list/restaurant_orders_list_controller.dart";
import "package:flutter_application_1/src/widgets/list_drawer.dart";
import "package:flutter_application_1/src/widgets/list_menu_drawer.dart";


class RestaurantOrdersListPage extends StatefulWidget {
  const RestaurantOrdersListPage({super.key});

  @override
  State<RestaurantOrdersListPage> createState() => _RestaurantOrdersListPageState();
}

class _RestaurantOrdersListPageState extends State<RestaurantOrdersListPage> {
  RestaurantOrdersListController controller = new RestaurantOrdersListController();

 
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
      
      child: Text('restaurant')
    ));
  }

  refresh() {
    setState(() {
      
    });
  }


}