import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
import 'package:scoped_model/scoped_model.dart';

import '../scoped/mainmodel.dart';
import '../models/product_model.dart';
import '../widget/product_detiles.dart';

class BarcodeScan extends StatefulWidget {
  _BarcodeScanState createState() => _BarcodeScanState();
}

class _BarcodeScanState extends State<BarcodeScan> {
  String scanshow;
  Future _barcodeScan() async {
    try {
      String scanresult = await BarcodeScanner.scan();
      setState(() {
        scanshow = int.parse(scanresult).toString();
      });
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          scanshow = 'خطای دسترسی به دوربین';
        });
      } else {
        setState(() {
          scanshow = 'خطای نامشخص';
        });
      }
    } on FormatException {
      setState(() {
        scanshow = 'بدون اسکن برگشتید';
      });
    } catch (e) {
      setState(() {
        scanshow = 'خطای نامشخص : $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Text("اسکن بارکد محصول"),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Theme.of(context).buttonColor,
        icon: Icon(Icons.camera_alt),
        label: Text("اسکن کردن با دوربین"),
        onPressed: () {
          _barcodeScan();
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: ScopedModelDescendant<MainModel>(
        builder: (context, child, model) {
          return Center(
            child: productCard(context, scanshow, model),
          );
        },
      ),
    );
  }
}

Widget productCard(BuildContext context, String scanshow, MainModel model) {
  ProductModel _findedProduct;

  if (model.productData.length != 0 && scanshow != null) {
    for (int i = 0; i < model.productData.length; i++) {
      if (model.productData[i].product_barcode == scanshow) {
        _findedProduct = model.productData[i];
      }
    }
    return Card(
        color: Theme.of(context).cardColor,
        margin:
            EdgeInsets.only(bottom: 75.0, top: 20.0, left: 15.0, right: 15.0),
        child: _findedProduct != null
            ? Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  Container(
                      width: double.infinity,
                      height: double.infinity,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              fit: BoxFit.fitHeight,
                              image: NetworkImage(
                                  'https://mashhadsafari.com/tmp/product_image/${_findedProduct.product_image}'))),
                      child: Text("")),
                  ProductDetiels(
                    findedProduct: _findedProduct,
                  )
                ],
              )
            : Padding(
                padding: EdgeInsets.all(15.0),
                child: Text(
                  "متاسفانه محصولی با این بارکد پیدا نشد ",
                  style: TextStyle(
                      color: Colors.pink, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ));
  } else {
    return Center(
      child: Text(
        "لطفا جهت اسکن محصول از دکمه پایین استفاده کنید ",
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }
}
