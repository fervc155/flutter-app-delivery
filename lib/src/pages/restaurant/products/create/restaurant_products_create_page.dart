import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_application_1/src/models/category.dart';
import 'package:flutter_application_1/src/pages/restaurant/products/create/restaurant_products_create_controller.dart';
import 'package:flutter_application_1/src/utils/my_colors.dart';

class RestaurantProductCreate extends StatefulWidget {
  const RestaurantProductCreate({super.key});

  @override
  State<RestaurantProductCreate> createState() => _RestaurantProductCreateState();
}

class _RestaurantProductCreateState extends State<RestaurantProductCreate> {


    RestaurantProductCreateController controller = new RestaurantProductCreateController();

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



  Widget _inputName() {
      return Container(
            margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            decoration: BoxDecoration(
              color: MyColors.primaryColorLight,
              borderRadius: BorderRadius.circular(100),
            ),
            child: TextField( 
              controller: controller.name,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                hintText: 'Nombre del producto',
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(15),
                hintStyle:  TextStyle(color: MyColors.primaryHintText),
                suffixIcon: Icon(
                  Icons.list_alt,
                  color: MyColors.primaryColor),
                ),
              )
          );
    }

    Widget _inputDescription() {
      return Container(
            margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: MyColors.primaryColorLight,
              borderRadius: BorderRadius.circular(30)
            ),
            child: TextField( 
              controller: controller.description,
              maxLines: 3,
              maxLength: 255,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                hintText: 'Descripcion',
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(15),
                hintStyle:  TextStyle(color: MyColors.primaryHintText),
                suffixIcon: Icon(
                  Icons.description,
                  color: MyColors.primaryColor),
                ),
              )
          );
    }


    Widget _inputPrice() {
      return Container(
            margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: MyColors.primaryColorLight,
              borderRadius: BorderRadius.circular(30)
            ),
            child: TextField( 
              controller: controller.price,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: '0.00',
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(15),
                hintStyle:  TextStyle(color: MyColors.primaryHintText),
                suffixIcon: Icon(
                  Icons.description,
                  color: MyColors.primaryColor),
                ),
              )
          );
    }


    Widget _dropdownCategory(List<Category> categories){
        return  Container(
          margin: EdgeInsets.symmetric(horizontal: 30),
          child: Material(
            elevation: 2.0,
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(5)),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10 ),
              child: Column(
                children:[
                  Row(
                    children:[
                      Icon(
                        Icons.search,
                        color: MyColors.primaryColor,
                      ),
                      SizedBox(width: 15),
                      Text(
                        'Categorias',
                        style: TextStyle(
                          color:Colors.grey,
                          fontSize: 16
                        )
                      )
                     ]
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: DropdownButton(
                      underline: Container(
                        alignment: Alignment.centerRight,
                        child: Icon(
                          Icons.arrow_drop_down_circle,
                          color: MyColors.primaryColor
                        )
                      ),
                      elevation: 3,
                      isExpanded: true,
                      hint:Text(
                        'Selecciona',
                        style: TextStyle(
                          color:Colors.grey,
                          fontSize: 16
                        )
                      ),
                      items:_dropdownItems(categories),
                      value: controller.idCategory,
                      onChanged: (obj){
                        setState(() {
                          controller.idCategory=obj ?? '';
                        });
                      },
                    ),
                  )
                ],
              ),
            )
           )
        
        );
    }
    Widget _loginButton() {
      return Container(
        height: 50,
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        child: ElevatedButton(
        onPressed:controller.createProduct, 
        child: Text('Crear producto'), 
        style: ElevatedButton.styleFrom(
          backgroundColor: MyColors.primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30)
          ),
          padding: EdgeInsets.symmetric(vertical: 15)
        )
      )
      );
    }


  Widget _cardImage(File? imageFile, int numberFile) {
    return GestureDetector(
      onTap: (){controller.showAlertDialog(numberFile);},
      child: imageFile != null ?  Card(
        elevation: 3.0,
        child: Container(
          height: 140,
          width: MediaQuery.of(context).size.width * 0.26,
          child: Image.file(
            imageFile,
            fit:BoxFit.cover
            ),
        )
        ) : Card(
        elevation: 3.0,
        child: Container(
          height: 140,
          width: MediaQuery.of(context).size.width * 0.26,
          child: Image(
            image: AssetImage('assets/img/add_image.png')
          ),
        )
        )
    );
  }


  List<DropdownMenuItem<String>> _dropdownItems(List<Category> categories){
    
    List<DropdownMenuItem<String>>  list =[];
    categories.forEach((Category cat) {

      list.add(DropdownMenuItem(
        child: Text(cat.name??''),
        value:cat.id
       ));

    });

    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(       
        title:Text('Nuevo producto')
        ),
        body: ListView(children: [

          _inputName(),
          _inputDescription(),
          _inputPrice(),
          Container(
            height: 100,
            margin: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children:[
                _cardImage(controller.file1, 1),
                _cardImage(controller.file2, 2),
                _cardImage(controller.file3, 3),
              ]
            )
          ),
          _dropdownCategory(controller.categories)
        ]
        ),
        bottomNavigationBar: _loginButton(),
    );
  }
}