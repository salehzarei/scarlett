import 'package:flutter/material.dart';

import '../widget/product_card.dart';
import '../scoped/mainmodel.dart';

class MakeProductGridView extends StatefulWidget {
  final MainModel model;
  final String currentcategoryID;

  MakeProductGridView({this.model, this.currentcategoryID});

  _MakeProductGridViewState createState() => _MakeProductGridViewState();
}

class _MakeProductGridViewState extends State<MakeProductGridView> {
  @override
  void initState() {
    print("init");
    super.initState();
  }

  // @override
  // void initState() {
  //   super.initState();
  //   print("Run MakeGrid");
  //   if (widget.currentcategoryID != "0") {
  //     widget.model.fetchSelectedProducts(widget.currentcategoryID.toString());
  //     print("دسته بندی : ${widget.currentcategoryID} انتخاب شد");
  //   } else {
  //     widget.model.fetchProducts();
  //     print("همه دسته بندی ها انتخاب شد");
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    if (widget.currentcategoryID == "0") {
      // return All Product List

      return GridView.builder(
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemCount: widget.model.productData.length,
        padding: EdgeInsets.all(16.0),
        itemBuilder: (BuildContext context, int index) {
          return ProductCard(
            model: widget.model,
            isAllProduct: true,
            index: index,
          );
        },
      );
    } else {
      print(
          "Run GridView Product lentgh : ${widget.model.selectedProductData.length} ");
      //  return selected Product List
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
}
