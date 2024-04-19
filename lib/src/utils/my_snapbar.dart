import "package:flutter/material.dart";

class MySnapbar {
  static void  show(BuildContext context, String text) {
    if(context==false) {
      return;
    }

    FocusScope.of(context).requestFocus(new FocusNode());
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      new SnackBar(
        content: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white, fontSize: 14)),
        backgroundColor: Colors.black,
        duration: Duration(seconds: 3)
    )
    );
  }
}