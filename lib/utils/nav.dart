import 'package:flutter/material.dart';
import 'dart:async';

Future push(BuildContext context, Widget page, {bool replace = false}) {

  if(replace){
    return Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) {
    return page;
    }));
  }
  
  return Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
    return page;

  }));
}