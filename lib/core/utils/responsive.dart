import 'package:flutter/material.dart';


class Responsive {


  static double height(BuildContext context){

    return MediaQuery.of(context).size.height;

  }



  static double width(BuildContext context){

    return MediaQuery.of(context).size.width;

  }



  static double padding(BuildContext context){

    return width(context)*0.05;

  }



}