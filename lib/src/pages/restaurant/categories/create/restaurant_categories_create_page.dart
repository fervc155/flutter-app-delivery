import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_application_1/src/pages/restaurant/categories/create/restaurant_categories_create_controller.dart';
import 'package:flutter_application_1/src/utils/my_colors.dart';

class RestaurantCategoryCreate extends StatefulWidget {
  const RestaurantCategoryCreate({super.key});

  @override
  State<RestaurantCategoryCreate> createState() => _RestaurantCategoryCreateState();
}

class _RestaurantCategoryCreateState extends State<RestaurantCategoryCreate> {


    RestaurantCategoryCreateController controller = new RestaurantCategoryCreateController();

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
            margin: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
            decoration: BoxDecoration(
              color: MyColors.primaryColorLight,
              borderRadius: BorderRadius.circular(100),
            ),
            child: TextField( 
              controller: controller.name,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                hintText: 'Nombre de la categoria',
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
            margin: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
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


    Widget _loginButton() {
      return Container(
        height: 50,
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
        child: ElevatedButton(
        onPressed:controller.createCategory, 
        child: Text('Crear categoria'), 
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



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(       
        title:Text('Nueva categoria')
        ),
        body: Column(children: [

          _inputName(),
          _inputDescription(),
        ],),
        bottomNavigationBar: _loginButton(),
    );
  }
}