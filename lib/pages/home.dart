import 'package:flutter/material.dart';

import '../scoped/mainmodel.dart';
import '../menu/zoomsacaffold.dart';
import '../pages/product_screen.dart';
import '../pages/categories_screen.dart';
import '../pages/sell_basket.dart';
import '../pages/sell_reports.dart';
import '../menu/menu_screen.dart';

class Home extends StatefulWidget {
  final MainModel model;
  Home({this.model});
  // bool _switchValue = true;
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String selectMenuItem;

  final menu = new Menu(
    items: [
      MenuItem(id: 'categories', title: 'دسته بندی'),
      MenuItem(id: 'mystore', title: 'محصولات من'),
      MenuItem(id: 'sellBasketScreen', title: 'سبد فروش'),
      MenuItem(id: 'sellReport', title: 'گزارش فروش')
    ],
  );

  @override
  void initState() {
    widget.model.fetchCategories();
    widget.model.fetchProducts();
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
            } else if (itemId == 'mystore') {
              setState(() => activeScreen = productScreen);
            } else if (itemId == 'sellBasketScreen') {
              setState(() => activeScreen = sellBasketScreen);
            } else if (itemId == 'sellReport') {
              setState(() => activeScreen = sellReports);
            }
          },
        ));
  }
}
