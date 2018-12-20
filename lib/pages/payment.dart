import 'package:flutter/material.dart';

import 'package:scarlett/menu/zoomsacaffold.dart';
import 'package:scarlett/pages/home.dart';

import 'package:scoped_model/scoped_model.dart';

import '../scoped/mainmodel.dart';
import '../models/payment_model.dart';

final menuScreenKey = GlobalKey(debugLabel: 'MenuScreen');

class Payment extends StatefulWidget {
  final MainModel model;
  Payment({this.model});
  _PaymentState createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  PaymentModel sellpayment;
  TextEditingController _buyerName = TextEditingController();
  TextEditingController _buyerNumber = TextEditingController();
  TextEditingController _cashValue = TextEditingController();
  TextEditingController _cardValue = TextEditingController();
  int remainMony = 0;
  int cardPayed, cashpayed;
  @override
  initState() {
    if (widget.model.totalPrice != null) remainMony = widget.model.totalPrice;
    super.initState();
  }

  savedata() {
    String buyerName, buyerNumber;

    if (_buyerName != null) {
      buyerName = _buyerName.text;
    } else
      buyerName = 'بدون نام';

    if (_buyerNumber != null) {
      buyerNumber = _buyerNumber.text;
    } else
      buyerNumber = 'بدون شماره تماس ';

    sellpayment = PaymentModel(
        buyerName: buyerName,
        byerNumber: buyerNumber,
        totalPrice: widget.model.totalPrice,
        cardPay: cardPayed,
        cashPay: cashpayed,
        payDate: DateTime.now(),
        productList: widget.model.sellProductsList);

    if (remainMony != 0) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return Directionality(
              textDirection: TextDirection.rtl,
              child: AlertDialog(
                contentPadding:
                    EdgeInsets.only(left: 10, right: 10, bottom: 20, top: 20),
                title: Icon(
                  Icons.warning,
                  size: 30,
                  color: Colors.red,
                ),
                content: Container(
                  height: 50,
                  child: Column(
                    textDirection: TextDirection.rtl,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text("تو رو خدا توجه کن، هنوز "),
                          Text(
                            " $remainMony تومن",
                            style: TextStyle(color: Colors.red),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text("از حساب مشتری مونده فکر کنم ! "),
                    ],
                  ),
                ),
                actions: <Widget>[
                  CloseButton(),
                  FlatButton(
                    child: Text("به توچه ! ثبتش کن "),
                    textColor: Colors.green,
                    onPressed: () {
                      widget.model.addSelledProduct(sellpayment);
                      Navigator.of(context).pop();
                    },
                  )
                ],
              ),
            );
          });
    } else {
//widget.model.addSelledProduct(sellpayment);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Home(
                    model: widget.model,
                    key: menuScreenKey,
                  )));
    }
  }

  calcData() {
    if (_cardValue.text.length != 0) {
      cardPayed = int.parse(_cardValue.text);
    } else
      cardPayed = 0;
    if (_cashValue.text.length != 0) {
      cashpayed = int.parse(_cashValue.text);
    } else
      cashpayed = 0;
    remainMony = widget.model.totalPrice - (cardPayed + cashpayed);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(10),
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: Colors.white70, borderRadius: BorderRadius.circular(15.0)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              TextField(
                autofocus: true,
                keyboardType: TextInputType.text,
                enableInteractiveSelection: true,
                controller: _buyerName,
                maxLength: 40,
                style: TextStyle(color: Colors.pink, fontSize: 20),
                decoration: InputDecoration(
                  labelText: 'نام خریدار',
                  icon: Icon(Icons.people),
                  labelStyle: TextStyle(fontSize: 20),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              TextField(
                keyboardType: TextInputType.phone,
                controller: _buyerNumber,
                maxLength: 11,
                style: TextStyle(color: Colors.pink, fontSize: 20),
                decoration: InputDecoration(
                  labelText: 'شماره تماس',
                  icon: Icon(Icons.phone),
                  labelStyle: TextStyle(fontSize: 20),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              TextField(
                keyboardType: TextInputType.number,
                enableInteractiveSelection: true,
                controller: _cashValue,
                maxLength: 7,
                onChanged: (_) {
                  setState(() {
                    calcData();
                  });
                },
                style: TextStyle(color: Colors.pink, fontSize: 20),
                decoration: InputDecoration(
                  labelText: 'جمع دریافت نقدی',
                  hintText: 'به تومان',
                  suffixText: 'تومان',
                  icon: Icon(Icons.attach_money),
                  labelStyle: TextStyle(fontSize: 20),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              TextField(
                keyboardType: TextInputType.number,
                controller: _cardValue,
                onChanged: (_) {
                  setState(() {
                    calcData();
                  });
                },
                maxLength: 7,
                style: TextStyle(color: Colors.pink, fontSize: 20),
                decoration: InputDecoration(
                  suffixText: ' تومان',
                  labelText: 'جمع دریافت کارت',
                  hintText: 'به تومان',
                  icon: Icon(Icons.credit_card),
                  labelStyle: TextStyle(fontSize: 20),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding:
                    EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "مانده حساب : ${remainMony.toString()}  تومان ",
                      style: remainMony != 0
                          ? TextStyle(fontSize: 20.0, color: Colors.red)
                          : TextStyle(fontSize: 20.0, color: Colors.green),
                    ),
                  ),
                  color: Colors.white54,
                  elevation: 0.0,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      RawMaterialButton(
                        onPressed: () {
                          savedata();
                        },
                        child: Row(
                          children: <Widget>[
                            Icon(
                              Icons.monetization_on,
                              color: Colors.teal,
                              size: 30.0,
                            ),
                            Text(
                              "ثبت این خرید",
                              style:
                                  TextStyle(color: Colors.teal, fontSize: 15.0),
                            )
                          ],
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        elevation: 2.0,
                        fillColor: Colors.white,
                        padding: const EdgeInsets.all(15.0),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      RawMaterialButton(
                        onPressed: () {},
                        child: Row(
                          children: <Widget>[
                            Icon(
                              Icons.cancel,
                              color: Colors.pink,
                              size: 30.0,
                            ),
                            Text(
                              " بی خیال همه !",
                              style:
                                  TextStyle(color: Colors.pink, fontSize: 15.0),
                            )
                          ],
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        elevation: 2.0,
                        fillColor: Colors.white,
                        padding: const EdgeInsets.all(15.0),
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
