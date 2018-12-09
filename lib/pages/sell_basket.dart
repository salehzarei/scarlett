import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../menu/zoomsacaffold.dart';
import '../scoped/mainmodel.dart';
import '../models/product_model.dart';

final sellBasketScreen = Screen(
    title: "سبد فروش",
    background: DecorationImage(
        colorFilter: ColorFilter.mode(Colors.white30, BlendMode.color),
        image: AssetImage('images/proback.jpg'),
        fit: BoxFit.cover),
    contentBuilder: (BuildContext context) {
      return ScopedModelDescendant<MainModel>(
        builder: (context, child, model) {
          return SellBasket(model: model);
        },
      );
    });

class SellBasket extends StatefulWidget {
  final MainModel model;
  SellBasket({this.model});
  @override
  _SellBasketState createState() => _SellBasketState();
}

class _SellBasketState extends State<SellBasket> {
  sum() {
    int sumOfPrice = 0;
    for (int len = 0;
        len < widget.model.selectedProductInBasket.length;
        len++) {
      sumOfPrice = sumOfPrice +
          int.parse(
              widget.model.selectedProductInBasket[len].product_price_sell);
    }
    return sumOfPrice;
  }

  @override
  Widget build(BuildContext context) {
    int selectedCount = widget.model.selectedProductInBasket.length;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Container(
              alignment: Alignment.topCenter,
              padding: EdgeInsets.all(12.0),
              child: selectedCount != 0
                  ? Column(
                      children: <Widget>[
                        Expanded(
                            child: ListView.builder(
                          itemCount: selectedCount,
                          itemBuilder: (BuildContext context, int index) {
                            return ProductBasket(
                              product: widget.model.selectedProductInBasket,
                              index: index,
                            );
                          },
                        )),
                        Container(
                          padding: EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.pink.shade100,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text("جمع کل خرید ها :"),
                              Text(
                                "${sum()}  تومان ",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w600),
                              )
                            ],
                          ),
                        )
                      ],
                    )
                  : Center(
                      child: Text(
                        "عزیزم هیچ محصولی در سبد نیست",
                        style: TextStyle(
                            color: Colors.pink,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ))),
    );
  }
}

class ProductBasket extends StatelessWidget {
  final List<ProductModel> product;
  final int index;
  ProductBasket({this.product, this.index});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 5, bottom: 5),
      margin: EdgeInsets.only(top: 5, bottom: 5, left: 8, right: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.pink.shade50,
      ),
      child: ListTile(
        dense: true,
        contentPadding: EdgeInsets.only(top: 2, bottom: 2, left: 10, right: 10),
        title: Text(
          product[index].product_name,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          product[index].product_des,
          maxLines: 1,
        ),
        leading: CircleAvatar(
          backgroundImage: NetworkImage(
            'https://mashhadsafari.com/tmp/product_image/${product[index].product_image}',
          ),
          radius: 34.0,
        ),
        trailing: Text("${product[index].product_price_sell} تومان"),
      ),
    );
  }
}
