import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_application_1/src/models/product.dart';
import 'package:flutter_application_1/src/pages/client/orders/create/client_orders_create_controller.dart';
import 'package:flutter_application_1/src/utils/my_colors.dart';

class ClientOrdersCreatePage extends StatefulWidget {
  const ClientOrdersCreatePage({super.key});

  @override
  State<ClientOrdersCreatePage> createState() => _ClientOrdersCreatePageState();
}

class _ClientOrdersCreatePageState extends State<ClientOrdersCreatePage> {


  ClientOrdersCreateController controller  = new ClientOrdersCreateController();
  
 @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) { 
      controller.init(context, refresh);
    });
  }


  refresh(){
    setState(() {
      
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        height: MediaQuery.of(context).size.height * 0.23,
        child: Column(
          children: [
            Divider(color: Colors.grey, indent: 30, endIndent: 30),
            _totalPrice(),
            Spacer(),
            _buttonShoppingbag()
          ],
        ),
      ),
      appBar: AppBar(title:Text('Mi orden')),
      body: controller.selectedProducts.length>0 ? 
      ListView(
        children: controller.selectedProducts.map((Product product){
          return cardProduct(product);
        }).toList()
        ): Container(
                margin: EdgeInsets.only(bottom:60),
                child:Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/img/no_items.png'),
                    Text('No hay productos')
                  ],
                ) ,
              )
    );
  }

  Widget cardProduct(Product product){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
      child:Row(
        children: [
          _imageProduct(product),
          SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(product.name??'',
                style:TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
              ),
              SizedBox(height: 10),
              _addOrRemoveItem(product)
            ]
          ),
          Spacer(),
          Column(
            children: [
              _textPrice(product),
              _remove(product)
            ],
          )

        ],
      )
    );

  }

  Widget _totalPrice(){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      child: Row(
        children: [
          Text(
            'Total: \$',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22
            )
          ),
          Spacer(),
           Text(
            '\$ ${controller.total}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22
            )
          ),
        ],
      )
    );
  }

  Widget _remove(Product product){
    return IconButton(
      onPressed: ()=>controller.remove(product),
      icon:Icon(Icons.delete, color: MyColors.primaryColor)
    );
  }

  Widget _textPrice(Product product){

    return Text('${product.subtotal()}\$', style: TextStyle(
      color:Colors.grey,
      fontWeight: FontWeight.bold
    ));

  }
  Widget _imageProduct(Product product){
    return Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          color:Colors.grey[200]
        ),
        width: 90,
        height: 90,
        child:FadeInImage(
            placeholder:AssetImage('assets/img/no-image.png'),
            image: (product.image1==null ?AssetImage('assets/img/no-image.png'): NetworkImage(product.image1!)) as ImageProvider,
            fit:BoxFit.contain,
            fadeInDuration: Duration(milliseconds: 50),
        )
      );
  
  }

  Widget _addOrRemoveItem(Product product){
    return Row(
      children: [
        GestureDetector(
          onTap: ()=>controller.reduceItem(product),         
          child: Container(
            margin:EdgeInsets.only(right: 2),
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: Text('-'),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              color: Colors.grey[200]
            ),
          )
        ),
        Container(
          margin:EdgeInsets.only(right: 2),
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: Text('${product.quantity ?? 1}'),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            color: Colors.grey[200]
          ),
        ),
        GestureDetector(
          onTap: ()=>controller.increaseItem(product),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: Text('+'),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              color: Colors.grey[200]
            ),
          )
        ),
      ],
    );
  }



  Widget _buttonShoppingbag(){
    return Container(
      margin: EdgeInsets.only(left: 30, right: 30, bottom: 30),
      child: ElevatedButton(
        
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
                margin: EdgeInsets.only(right:10),
                height: 30,
                child: Icon(Icons.check_circle, color: Colors.white, size: 30)
            ),
            Container(
                alignment: Alignment.center,
                height: 50,
                child: Text(
                  'Continuar',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white
                  ))
              ),
            
          ],
        ),
        onPressed: controller.order,
        style:ElevatedButton.styleFrom(
          backgroundColor: MyColors.primaryColor,
          padding: EdgeInsets.symmetric(vertical: 5),
          shape:  RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12)
          )
        )
      ),
    );
  }


}