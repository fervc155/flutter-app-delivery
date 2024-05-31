import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/controllers/list_controller.dart';
import 'package:flutter_application_1/src/models/order.dart';
import 'package:flutter_application_1/src/pages/delivery/orders/detail/delivery_orders_detail_page.dart';import 'package:flutter_application_1/src/providers/order_provider.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class DeliveryOrdersListController extends ListController {

  late BuildContext context;
  GlobalKey<ScaffoldState> key = new GlobalKey<ScaffoldState>();
  late Function refresh;

  List<String> status = ['DESPACHADO', 'EN CAMINO', 'ENTREGADO'];
  OrderProvider _ordersProvider = new OrderProvider();

  bool isUpdated=false;
  List<Order> despachado= [];
  List<Order> enCamino= [];
  List<Order> entregado= [];

  @override
  void init(BuildContext context, Function refresh) async {
    await super.init(context, refresh); // Llamar al método init() de la clase padre
    this.context = context;
    this.refresh = refresh;
     _ordersProvider.init(context, this.user);

    despachado = await _ordersProvider.getByDeliveryAndStatus(user!.id!, status[0]);
    enCamino = await _ordersProvider.getByDeliveryAndStatus(user!.id!, status[1]);
    entregado = await _ordersProvider.getByDeliveryAndStatus(user!.id!, status[2]);
    refresh();
  }

  Future<List<Order>> getOrders(String status) async {
    if(status ==this.status[0]){
      return despachado;
    }
    if(status ==this.status[1]){
      return enCamino;
    }  
    return entregado;

  }

  void openBottomSheet(Order order) async {
    isUpdated = await showMaterialModalBottomSheet(
        context: context,
        builder: (context) => DeliveryOrdersDetailPage(order: order)
    )?? false;

    if (isUpdated) {
      refresh();
    }
  }

}