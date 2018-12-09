import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';


import '../menu/zoomsacaffold.dart';
import '../scoped/mainmodel.dart';

final sellReports = Screen(
    title: "گزارش فروش",
    background: DecorationImage(
        colorFilter: ColorFilter.mode(Colors.white30, BlendMode.color),
        image: AssetImage('images/proback.jpg'),
        fit: BoxFit.cover),
    contentBuilder: (BuildContext context) {
      return ScopedModelDescendant<MainModel>(
        builder: (context,child,model){
          return Scaffold(
            body: Text("گزارش فروش"),
          );
        },
               
      );
    });