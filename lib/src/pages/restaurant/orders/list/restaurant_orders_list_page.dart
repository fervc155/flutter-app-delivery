
import "package:flutter/material.dart";
import "package:flutter/scheduler.dart";
import "package:flutter_application_1/src/models/order.dart";
import "package:flutter_application_1/src/pages/restaurant/orders/list/restaurant_orders_list_controller.dart";
import "package:flutter_application_1/src/utils/my_colors.dart";
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
    return DefaultTabController(
    
      length: controller.status.length,
      child: Scaffold(
          key: controller.key,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(100),
          child: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white,
            flexibleSpace: Column(
              children: [
                SizedBox(height: 60),
                ListMenuDrawer(controller: controller),
              ],
            ),
            bottom: TabBar(
              indicatorColor: MyColors.primaryColor,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey[400],
              isScrollable: true,
              tabs: List<Widget>.generate(controller.status.length, (index) {
                return Tab(
                  child: Text(controller.status[index] ),
                );
              }),
            ),
          ),
        ),
        drawer: ListDrawer(controller:controller, ListTiles: [
          ListTile(
            onTap: controller.gotoCategoryCreate,
            title: Text('Nueva categoria'),
            trailing: Icon(Icons.list_alt),
          ),
          ListTile(
            onTap: controller.gotoCreateProduct,
            title: Text('Nuevo producto'),
            trailing: Icon(Icons.add_box),
          )

        ],),
        body:TabBarView(
          children: controller.status.map((String status) {
            return FutureBuilder(
                future: controller.getOrders(status),
                builder: (context, AsyncSnapshot<List<Order>> snapshot) {

                  if (snapshot.hasData) {
                    int length = snapshot.data?.length??0;

                    if (length > 0) {
                      return ListView.builder(
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                          itemCount: snapshot.data?.length ?? 0,
                          itemBuilder: (_, index) {
                            return   _cardOrder(snapshot.data![index]);
                          }
                      );
                    }
                    else {
                      return Text( 'No hay ordenes');
                    }
                  }
                  else {
                    return Text( 'No hay ordenes');
                  }
                }
            );
          }).toList(),
        ),
      )
    );
  }

    Widget _cardOrder(Order order) {
    return GestureDetector(
      onTap: () {
        controller.openBottomSheet(order);
      },
      child: Container(
        height: 155,
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        child: Card(
          elevation: 3.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15)
          ),
          child: Stack(
            children: [
              Positioned(
                  child: Container(
                    height: 30,
                    width: MediaQuery.of(context).size.width * 1,
                    decoration: BoxDecoration(
                      color: MyColors.primaryColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                      )
                    ),
                    child: Container(
                      width: double.infinity,
                      alignment: Alignment.center,
                      child: Text(
                        'Orden #${order.id}',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                          fontFamily: 'NimbusSans'
                        ),
                      ),
                    ),
                  )
              ),
              Container(
                margin: EdgeInsets.only(top: 40, left: 20, right: 20),
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.symmetric(vertical: 5),
                      width: double.infinity,
                      child: Text(
                        'Pedido: 2015-05-23',
                        style: TextStyle(
                            fontSize: 13
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      width: double.infinity,
                      margin: EdgeInsets.symmetric(vertical: 5),
                      child: Text(
                        'Cliente: ${order.client?.name ?? ''} ${order.client?.lastname ?? ''}',
                        style: TextStyle(
                            fontSize: 13
                        ),
                        maxLines: 1,
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      width: double.infinity,
                      margin: EdgeInsets.symmetric(vertical: 5),
                      child: Text(
                        'Entregar en: ${order.address?.address ?? ''}',
                        style: TextStyle(
                            fontSize: 13
                        ),
                        maxLines: 2,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }


  refresh() {
    setState(() {
      
    });
  }


}