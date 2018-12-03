import 'package:flutter/material.dart';

import '../widget/product_card.dart';
import '../scoped/mainmodel.dart';
import '../widget/selected_product_list.dart';

class MakeProductGridView extends StatefulWidget {
  final MainModel model;
  final String currentcategoryID;

  MakeProductGridView({this.model, this.currentcategoryID});

  _MakeProductGridViewState createState() => _MakeProductGridViewState();
}

class _MakeProductGridViewState extends State<MakeProductGridView> {
  bool isAllProduct = false;
  @override
  Widget build(BuildContext context) {
    if (widget.currentcategoryID == "0") {
      
     isAllProduct = true;
      // return All Product List
      if (widget.model.productData.length != 0) {
        return GridView.builder(
          gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
          itemCount: widget.model.productData.length,
          padding: EdgeInsets.all(16.0),
          itemBuilder: (BuildContext context, int index) {
            return ProductCard(
              model: widget.model,
              isAllProduct: isAllProduct,
              index: index,
            );
          },
        );
      } else {
        return Center(
          child: CircularProgressIndicator(),
        );
      }
    } else {
      return widget.model.isLoadingProductData
          ? Center(child: CircularProgressIndicator())
          : SelectedProductList(
              categoryid: widget.currentcategoryID,
              model: widget.model,
            );
    }
  }
}
