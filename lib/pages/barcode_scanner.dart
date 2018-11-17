import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';

class BarcodeScan extends StatefulWidget {
  _BarcodeScanState createState() => _BarcodeScanState();
}

class _BarcodeScanState extends State<BarcodeScan> {
  String scanshow = "نتیجه اسکن";
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
        scanshow = 'برگردید به عقب';
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
        title: Text("اسکن بارکد"),
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
      body: Center(
        child: ProductCard(context, scanshow),
      ),
    );
  }
}

Widget ProductCard(context, scanshow) {
  return Card(
    color: Theme.of(context).cardColor,
    margin: EdgeInsets.only(bottom: 75.0, top: 20.0, left: 15.0, right: 15.0),
    child: ListView(
      padding: EdgeInsets.all(15.0),
      children: <Widget>[
        Text(scanshow,
            style: TextStyle(color: Colors.pink, fontSize: 25.0),
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.center),
        Divider(),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            
          ],
        ),
      ],
    ),
  );
}
