import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../models/product_model.dart';
import '../scoped/mainmodel.dart';

import '../pages/sell_basket.dart';
import '../menu/menu_screen.dart';
import '../pages/home.dart';
import '../menu/zoomsacaffold.dart';

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
            height: 10.0,
          ),
          Padding(
            padding: EdgeInsets.only(right: 35.0),
            child: Text(
              findedProduct.product_des,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 13.0,
                  fontWeight: FontWeight.w500),
            ),
          ),
          SizedBox(
            height: 12.0,
          ),
          Padding(
            padding: EdgeInsets.only(right: 35.0),
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.only(right: 5.0, left: 5.0),
              height: 80.0,
              width: 260.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color: Theme.of(context).cardColor,
              ),
              child: ListView(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  Column(
                    textDirection: TextDirection.rtl,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        textDirection: TextDirection.rtl,
                        children: <Widget>[
                          Text(
                            "قیمت فروش :",
                            textDirection: TextDirection.rtl,
                            style: TextStyle(
                                color: Colors.pink,
                                fontSize: 15.0,
                                fontWeight: FontWeight.w600),
                          ),
                          Text(
                            " ${findedProduct.product_price_sell} تومان",
                            textDirection: TextDirection.rtl,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.0,
                                fontWeight: FontWeight.w600),
                          )
                        ],
                      ),
                      Divider(),
                      Row(
                        textDirection: TextDirection.rtl,
                        children: <Widget>[
                          Text(
                            "تعداد موجود :",
                            textDirection: TextDirection.rtl,
                            style: TextStyle(
                                color: Colors.pink,
                                fontSize: 15.0,
                                fontWeight: FontWeight.w600),
                          ),
                          Text(
                            " ${findedProduct.product_count} عدد",
                            textDirection: TextDirection.rtl,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.0,
                                fontWeight: FontWeight.w600),
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          Text(
                            " سایز :",
                            textDirection: TextDirection.rtl,
                            style: TextStyle(
                                color: Colors.pink,
                                fontSize: 15.0,
                                fontWeight: FontWeight.w600),
                          ),
                          Text(
                            " ${findedProduct.product_size}",
                            textDirection: TextDirection.rtl,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.0,
                                fontWeight: FontWeight.w600),
                          )
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 15.0,
                  ),
                  ScopedModelDescendant<MainModel>(
                    builder: (context, child, model) {
                      return GestureDetector(
                        child: Center(
                          child: Container(
                              alignment: Alignment.center,
                              width: 35.0,
                              height: 45.0,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15.0),
                                  color: Colors.pink),
                              child: Icon(
                                Icons.add_shopping_cart,
                                color: Colors.white,
                              )),
                        ),
                        onTap: () {
                          model.selectedProductInBasket.add(findedProduct);
                        
                        },
                      );
                    },
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
