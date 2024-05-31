
import "package:flutter/material.dart";
import "package:flutter/scheduler.dart";
import "package:flutter_application_1/src/models/category.dart";
import "package:flutter_application_1/src/models/product.dart";
import "package:flutter_application_1/src/pages/client/products/list/client_products_list_controller.dart";
import "package:flutter_application_1/src/utils/my_colors.dart";
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
    return DefaultTabController(
      length: controller.categories.length,
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 235, 249, 248),       key: controller.key,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(170),
          child: AppBar(
          actions: [
            GestureDetector(
              onTap: controller.gotoCart,
              child: _shoppingBag()
            )
          ],
          flexibleSpace: Column(
            children: [
              SizedBox(height: 80),
               ListMenuDrawer(controller:controller),
               _search()
            ],
          ),
          bottom: TabBar(
            indicatorColor: MyColors.primaryColor,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey[400],
            isScrollable: true,
            tabs: List<Widget>.generate(controller.categories.length, (index) {
              return Tab(
                child: Text(controller.categories[index].name ?? '')
              );
            }),
          ),
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
         ),
        ),
        drawer: ListDrawer(controller: controller),
        body: TabBarView(

          children: controller.categories.map((Category cat){
            return  FutureBuilder(
              future: controller.getProducts(cat.id!), 
              builder: (context, AsyncSnapshot<List<Product>> snap){
               
               if(snap.hasData){
                if(snap.data!.length>0){
                  return  GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.7
                    ), 
                    itemCount:  snap.data?.length ?? 0,
                    itemBuilder: (_, index){
                      return _cardProduct(snap.data?[index] ?? Product());
                    });
                }
                
                }
               
              return Container(
                margin: EdgeInsets.only(bottom:60),
                child:Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/img/no_items.png'),
                    Text('No hay productos')
                  ],
                ) ,
              );

                
              });
          }).toList(),
        )
        )
    );
  }



  Widget _cardProduct(Product product) {
    return GestureDetector(
      onTap: (){controller.openBottonSheet(product);},
      child: Container(
        height: 250,
        padding: EdgeInsets.symmetric(vertical: 2.5, horizontal: 2.5),
        child: Card(
          elevation: 0.0,
          color: Colors.white,
          child: Stack(
            children: [
              Positioned(
                top: -1.0,
                right: -1.0,
                child: Container(
                  child: Icon(Icons.add, color: Colors.white),
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: MyColors.primaryColor,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(15),
                      topRight: Radius.circular(20)
                    )
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                Container(
                  height: 150,
                  margin: EdgeInsets.only(top:40),
                  width: MediaQuery.of(context).size.width * 0.45,
                  child: FadeInImage(
                    placeholder:AssetImage('assets/img/no-image.png'),
                    image: (product.image1==null ?AssetImage('assets/img/no-image.png'): NetworkImage(product.image1!)) as ImageProvider,
                    fit:BoxFit.contain,
                    fadeInDuration: Duration(milliseconds: 50),
                  ),
                ),
                Container(
                  height: 33,
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    product.name ?? '-',
                    style: TextStyle(
                      fontFamily: 'NimbusSans',
                      fontSize: 15,
                     ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Text(
                    '${product.price ?? '-'}\$',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'NimbusSans'
                    ),
                  ),
                )
              ],)
            ],
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15)
          )
        ),
      )
    );
  }



  void refresh() {
    setState(() {
      
    });
  }

  Widget _search(){

    dynamic outlineStyle = OutlineInputBorder(
            borderRadius: BorderRadius.circular(100),
            borderSide: BorderSide(
              color:Colors.grey[400] ?? Colors.grey
      ));

    return Container(
      padding: EdgeInsets.all(15),
      child: TextField(

        decoration: InputDecoration(
          hintText: 'Buscar',
          suffixIcon: Icon(Icons.search, color:Colors.grey[400]),
          hintStyle: TextStyle(fontSize: 17, color:Colors.grey[500]),
          enabledBorder: outlineStyle,
          focusedBorder: outlineStyle,
          contentPadding: EdgeInsets.all(15),          
          )
        )
    );
  }

  Widget _shoppingBag() {
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.only(right: 20),
          child: Icon(
            Icons.shopping_bag_outlined,
            color:Colors.black
          )
        ),
        Positioned(
          right: 19  ,
          child: 
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.all(Radius.circular(30))
          ), 
        ))
      ]
    );
  }
}