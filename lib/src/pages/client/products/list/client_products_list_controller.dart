
import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/controllers/list_controller.dart';
import 'package:flutter_application_1/src/models/category.dart';
import 'package:flutter_application_1/src/models/product.dart';
import 'package:flutter_application_1/src/pages/client/products/detail/client_products_detail_page.dart';
import 'package:flutter_application_1/src/providers/category_provider.dart';
import 'package:flutter_application_1/src/providers/product_provider.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';


class ClientProductsListController extends ListController{


  List<Category> categories =[];
  CategoryProvider provider = new CategoryProvider();
  ProductProvider productProvider = new ProductProvider();
  // SharePref share = new SharePref();
  // GlobalKey<ScaffoldState> key = new GlobalKey();

  @override
  void init(BuildContext c, Function refresh) async {
    await super.init(c, refresh); // Llamar al método init() de la clase padre
    this.provider.init(c, this.user);
    print(this.user);
    this.productProvider.init(c, this.user);
    getCategories();
  }

  void getCategories() async {
    this.provider.init(context,this.user );
    categories = await provider.getAll();
    refresh();
  }


  Future<List<Product>> getProducts(String idCategory) async {
    return await this.productProvider.getByCategory(idCategory);
  }

  openBottonSheet(Product product){
    showMaterialModalBottomSheet(
      context: context,
      builder: ((context) => ClientProductsDetailPage(product:product))
    );
  }

  gotoCart(){
    Navigator.pushNamed(context, 'client/orders/create');
  }
}