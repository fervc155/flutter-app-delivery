import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/controllers/list_controller.dart';
import 'package:flutter_application_1/src/models/order.dart';
import 'package:flutter_application_1/src/pages/restaurant/orders/detail/restaurant_order_detail_page.dart';
import 'package:flutter_application_1/src/providers/order_provider.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';


class RestaurantOrdersListController extends ListController{

  late BuildContext context;
  GlobalKey<ScaffoldState> key = new GlobalKey<ScaffoldState>();
  late Function refresh;

  List<String> status = ['PAGADO', 'DESPACHADO', 'EN CAMINO', 'ENTREGADO'];
  OrderProvider _ordersProvider = new OrderProvider();

  bool isUpdated=false;

  @override
  void init(BuildContext context, Function refresh) async {
    await super.init(context, refresh); 
    this.context = context;
    this.refresh = refresh;
    _ordersProvider.init(context, this.user);
    refresh();
  }

  Future<List<Order>> getOrders(String status) async {
    return await _ordersProvider.getByStatus(status);
  }

  void openBottomSheet(Order order) async {
    isUpdated = await showMaterialModalBottomSheet(
        context: context,
        builder: (context) => RestaurantOrdersDetailPage(order: order)
    ) ?? false;

    if (isUpdated) {
      refresh();
    }
  }


  void gotoCreateProduct() {
    Navigator.pushNamed(context, 'restaurant/products/create');
  }
}