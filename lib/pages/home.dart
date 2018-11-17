import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:transparent_image/transparent_image.dart';

import '../scoped/mainmodel.dart';
import '../models/categories_model.dart';
import '../pages/addoreditCategories.dart';
import '../pages/barcode_scanner.dart';
import '../pages/zoomsacaffold.dart';
import '../pages/product_screen.dart';
import '../pages/categories_screen.dart';
import '../pages/menu_screen.dart';

class Home extends StatefulWidget {
  MainModel model;
  Home({this.model});
  // bool _switchValue = true;
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String selectMenuItem;
  CategoriesModel categorieData;
  final menu = new Menu(
    items: [
      MenuItem(id: 'categories', title: 'دسته بندی'),
      MenuItem(id: 'mystore', title: 'محصولات من'),
      MenuItem(id: 'sell', title: 'آمار فروش'),
      MenuItem(id: 'setting', title: 'تنظیمات')
    ],
  );

  @override
  void initState() {
    widget.model.fetchCategories();
    super.initState();
  }

  var selectedMenuId = 'categories';
  var activeScreen = categoriesScreen;

  @override
  Widget build(BuildContext context) {
    return ZoomScaffold(
        contentScreen: activeScreen,
        menuScreen: MenuScreen(
          selectedItemId: selectedMenuId,
          menu: menu,
          onMenuItemSelected: (String itemId) {
            selectedMenuId = itemId;
            if (itemId == 'categories') {
              setState(() => activeScreen = categoriesScreen);
            } else {
              setState(() => activeScreen = productScreen);
            }
          },
        ));
  }
}
