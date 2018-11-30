import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';


import './scoped/mainmodel.dart';

import './pages/home.dart';

main() {
  MainModel model = MainModel();

  runApp(ScopedModel<MainModel>(
  model: model,
  child: MaterialApp(
  debugShowCheckedModeBanner: false,
  title: "Scarlett",
  theme: ThemeData(brightness: Brightness.light,
  backgroundColor: Colors.pink.shade700,
  primaryColor: Colors.pink.shade800,
  bottomAppBarColor: Colors.pinkAccent.shade700,
  buttonColor: Colors.pink.shade900,
  cardColor: Colors.purple.shade100,
  // inputDecorationTheme: InputDecorationTheme(
  //   border: OutlineInputBorder(),
  // ),
  fontFamily: 'BYekan',
  textTheme: TextTheme(title: TextStyle(color: Colors.pink.shade800)),
  
  ),
  routes: {
    '/': (BuildContext context) => Home(
          model: model,
        ),
  },
    ),
    ));
}


