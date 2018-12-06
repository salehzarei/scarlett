import 'package:flutter/material.dart';

import '../scoped/mainmodel.dart';
import '../models/product_model.dart';

class ProductDetiels extends StatelessWidget {
  final ProductModel findedProduct;

  ProductDetiels({this.findedProduct});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 300.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        textDirection: TextDirection.rtl,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 25.0),
            child: Container(
              padding: EdgeInsets.only(right: 5.0),
              decoration: BoxDecoration(
                  border: Border(
                      right: BorderSide(
                          color: Colors.pink,
                          style: BorderStyle.solid,
                          width: 3.0))),
              child: Text(
                findedProduct.product_name,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SizedBox(
            height: 15.0,
          ),
          Padding(
            padding: EdgeInsets.only(right: 25.0),
            child: Container(
              padding: EdgeInsets.only(right: 5.0),
              height: 90.0,
              width: 285.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color: Colors.white30,
              ),
                child: ListView(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  Text("data"),
                 
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
