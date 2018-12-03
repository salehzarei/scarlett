import 'package:flutter/material.dart';

import '../scoped/mainmodel.dart';

class ProductCard extends StatefulWidget {
  final MainModel model;
  final int index;
  final bool isAllProduct;
  const ProductCard({this.model, this.index, this.isAllProduct});

  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Card(
        elevation: 0.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            AspectRatio(
                aspectRatio: 20.0 / 11.0,
                child: FadeInImage.assetNetwork(
                  image: widget.isAllProduct
                      ? 'https://mashhadsafari.com/tmp/product_image/${widget.model.productData[widget.index].product_image}'
                      : 'https://mashhadsafari.com/tmp/product_image/${widget.model.selectedProductData[widget.index].product_image}',
                  fit: BoxFit.fitWidth,
                  placeholder: 'images/Bars-1s-200px.gif',
                )),
            Expanded(
              child: Padding(
                padding: EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      widget.isAllProduct
                          ? widget.model.productData[widget.index].product_name
                          : widget.model.selectedProductData[widget.index]
                              .product_name,
                      maxLines: 1,
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    widget.isAllProduct
                        ? Text(
                            "بارکد : ${widget.model.productData[widget.index].product_barcode}")
                        : Text(
                            "بارکد : ${widget.model.selectedProductData[widget.index].product_barcode}")
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
