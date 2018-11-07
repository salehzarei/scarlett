import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import './model/mainmodel.dart';

import './pages/home.dart';

main() {
  MainModel model = MainModel();

  runApp(ScopedModel<MainModel>(
    model: model,
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Scarlett",
      theme: ThemeData(brightness: Brightness.dark,
      buttonColor: Colors.teal,
      fontFamily: 'BRoya'
      ),
      routes: {
        '/': (BuildContext context) => Home(
              model: model,
            ),
      },
    ),
  ));
}
