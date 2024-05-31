import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/controllers/list_controller.dart';
import 'package:flutter_application_1/src/models/order.dart';
import 'package:flutter_application_1/src/pages/client/orders/detail/client_orders_detail_page.dart';
import 'package:flutter_application_1/src/providers/order_provider.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class ClientOrdersListController extends ListController {

  GlobalKey<ScaffoldState> key = new GlobalKey<ScaffoldState>();
  late Function refresh;
  
  List<String> status = ['PAGADO', 'DESPACHADO', 'EN CAMINO', 'ENTREGADO'];
  OrderProvider _ordersProvider = new OrderProvider();

  bool isUpdated=false;

  @override
  init(BuildContext context, Function refresh) async {
    await super.init(context, refresh); // Llamar al método init() de la clase padre
    _ordersProvider.init(context, user);
    refresh();
  }

  Future<List<Order>> getOrders(String status) async {
    return await _ordersProvider.getByClientAndStatus(user?.id??'', status);
  }

  void openBottomSheet(Order order) async {
    isUpdated = await showMaterialModalBottomSheet(
        context: context,
        builder: (context) => ClientOrdersDetailPage(order: order)
    );

    if (isUpdated) {
      refresh();
    }
  }



}