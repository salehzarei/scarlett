import 'package:flutter/material.dart';

import '../scoped/mainmodel.dart';
import '../widget/product_card.dart';

class SelectedProductList extends StatefulWidget {
 final MainModel model;
 final String categoryid;

  SelectedProductList({this.model, this.categoryid});
  _SelectedProductListState createState() => _SelectedProductListState();
}

class _SelectedProductListState extends State<SelectedProductList> {
  @override
  Widget build(BuildContext context) {
       return GridView.builder(
      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      itemCount: widget.model.selectedProductData.length,
      padding: EdgeInsets.all(16.0),
      itemBuilder: (BuildContext context, int index) {
        return ProductCard(
          model: widget.model,
          isAllProduct: false,
          index: index,
        );
      },
    );
  }
}