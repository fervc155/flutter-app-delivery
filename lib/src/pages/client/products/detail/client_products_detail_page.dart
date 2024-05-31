import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_application_1/src/models/product.dart';
import 'package:flutter_application_1/src/pages/client/products/detail/client_products_detail_controller.dart';
import 'package:flutter_application_1/src/utils/my_colors.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';

class ClientProductsDetailPage extends StatefulWidget {
  final Product product;
  
  ClientProductsDetailPage({super.key, required this.product});

  @override
  State<ClientProductsDetailPage> createState() => _ClientProductsDetailPageState();
}

class _ClientProductsDetailPageState extends State<ClientProductsDetailPage> {
 
ClientProductDetailController controller = new ClientProductDetailController();


refresh(){
  setState(() {
    
  });
}
@override
  void initState() {
   
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      this.controller.init(context,refresh, widget.product);

    });
  }
 
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.90,
      child: Column(
        children: [
          _imageSlider(),
          _textName(),
          _textDescription(),
          Spacer(),
          _addOrRemoveItem(),
          _standartDelivery(),
          _buttonShoppingbag()
        ],
      )
    );
  }

  Widget _textName(){
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.only(left: 30, right: 30, top: 30),
      child: Text(
        controller.product?.name ?? '',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold
        )),
    );
  }


  Widget _addOrRemoveItem(){
    return Container(
      margin:EdgeInsets.symmetric(horizontal: 17),
      child: Row(
        children:[
          IconButton(onPressed: controller.removeCounter,
              icon: Icon(Icons.remove_circle_outline,
              color: Colors.grey,
              size: 30,
            )
          ),
          Text(
            '${controller.counter}', 
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Colors.grey
            )
          ),
          IconButton(onPressed: controller.addCounter,
              icon: Icon(Icons.add_circle_outline,
              color: Colors.grey,
              size: 30,
            )
          ),

          Spacer(),
          Container(
            margin:EdgeInsets.only(right: 10),
            child:Text(
              '${controller.price}\$',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold
              )
            )
          )
        ]
      )
    );
  }

  Widget _buttonShoppingbag(){
    return Container(
      margin: EdgeInsets.only(left: 30, right: 30, top:30,bottom: 40),
      child: ElevatedButton(
        
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
                margin: EdgeInsets.only(right:10),
                height: 30,
                child: Image.asset('assets/img/bag.png')
            ),
            Container(
                alignment: Alignment.center,
                height: 50,
                child: Text(
                  'Agregar al carrito',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white
                  ))
              ),
            
          ],
        ),
        onPressed: controller.addToBag,
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


  Widget _standartDelivery(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30),
      child:Row(
        children: [
          Image.asset('assets/img/delivery.png', height:17),
          SizedBox(width: 7),
          Text(
            'Envio estandar',
            style:TextStyle(
              fontSize: 12,
              color:Colors.green
            )
            
          )
          
        ],
      )
    );
  }
  Widget _textDescription(){
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.only(right:30, left:30, top:15),
      child: Text(
        controller.product?.description ?? '',
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.bold
        )),
    );
  }
  Widget _imageSlider(){
   return Stack(

     children: [
       ImageSlideshow(
          width: double.infinity,
          height: MediaQuery.of(context).size.height *0.4,
          initialPage: 0,
          indicatorColor: MyColors.primaryColor,
          onPageChanged: (value) {
            debugPrint('Page changed: $value');
          },
          autoPlayInterval: 3000,
          isLoop: true,
          children: [
            FadeInImage(
              placeholder:AssetImage('assets/img/no-image.png'),
              image: (controller.product?.image1==null ?AssetImage('assets/img/no-image.png'): NetworkImage(controller.product!.image1!)) as ImageProvider,
              fit:BoxFit.fill,
              fadeInDuration: Duration(milliseconds: 50),
            ),
            FadeInImage(
              placeholder:AssetImage('assets/img/no-image.png'),
              image: (controller.product?.image2==null ?AssetImage('assets/img/no-image.png'): NetworkImage(controller.product!.image2!)) as ImageProvider,
              fit:BoxFit.fill,
              fadeInDuration: Duration(milliseconds: 50),
            ),
            FadeInImage(
              placeholder:AssetImage('assets/img/no-image.png'),
              image: (controller.product?.image3==null ?AssetImage('assets/img/no-image.png'): NetworkImage(controller.product!.image3!)) as ImageProvider,
              fit:BoxFit.fill,
              fadeInDuration: Duration(milliseconds: 50),
            ),
          ],
        ),
        Positioned(
          left: 20,
          top: 20,
          child: IconButton(
            icon:Icon(Icons.arrow_back_ios, color:MyColors.primaryColor),
            onPressed: (){ Navigator.pop(context);},
          )
        )
     ]
   );

  }
    
}