import 'package:flutter/material.dart';


showLoding(context){

  return showDialog(context: context, builder:(context){
    return AlertDialog(title: Text("pleas loding ..."),
      content: Container(
          height: 50,
          child: Center(child: CircularProgressIndicator(),)),);
  });
}


