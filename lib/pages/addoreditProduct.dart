import 'dart:io';
import 'dart:math' as Math;

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:scarlett/pages/home.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:image/image.dart' as Img;

import '../models/product_model.dart';
import '../models/categories_model.dart';
import '../scoped/mainmodel.dart';

final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

class AddorEditProduct extends StatefulWidget {
  _AddorEditProductState createState() => _AddorEditProductState();
}

class _AddorEditProductState extends State<AddorEditProduct> {
  var selectMenuItem;
  String selectedCategoriID;
  File newProductImage;
  bool _isEditing = false;
  bool _autoValidate = false;
  TextEditingController _productBarcodeController = TextEditingController();
  TextEditingController _productNameController = TextEditingController();
  TextEditingController _productDescriptionController = TextEditingController();
  TextEditingController _productCountController = TextEditingController();
  TextEditingController _productSizeController = TextEditingController();
  TextEditingController _productColorController = TextEditingController();
  TextEditingController _productBuyPriceController = TextEditingController();
  TextEditingController _productSellPriceController = TextEditingController();

  Future getImageGallery() async {
    var imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    int rand = Math.Random().nextInt(10000);
    if (imageFile != null) {
      Img.Image image = Img.decodeImage(imageFile.readAsBytesSync());
      Img.Image smallerImg = Img.copyResize(image, 500);

      var compressImg = File("$path/product_image_$rand.jpg")
        ..writeAsBytesSync(Img.encodeJpg(smallerImg, quality: 85));

      setState(() {
        newProductImage = compressImg;
      });
    }
  }

  Future getImageCamera() async {
    var imageFile = await ImagePicker.pickImage(source: ImageSource.camera);
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    int rand = Math.Random().nextInt(10000);
    if (imageFile != null) {
      Img.Image image = Img.decodeImage(imageFile.readAsBytesSync());
      Img.Image smallerImg = Img.copyResize(image, 500);

      var compressImg = File("$path/product_image_$rand.jpg")
        ..writeAsBytesSync(Img.encodeJpg(smallerImg, quality: 85));

      setState(() {
        newProductImage = compressImg;
      });
    }
  }

  @override
  void dispose() {
    _productBarcodeController.dispose();
    _productBuyPriceController.dispose();
    _productCountController.dispose();
    _productDescriptionController.dispose();
    _productNameController.dispose();
    _productSellPriceController.dispose();
    _productSizeController.dispose();
    _productColorController.dispose();

    super.dispose();
  }

  chekImage() {
    // no new file and empty icon show defult icon
    if (newProductImage == null && (!_isEditing)) {
      return AssetImage('images/noimage.png');
    }
    // no file and has icon show icon
    //  else if (newProductImage == null && _catimage != null) {
    //    return NetworkImage('https://mashhadsafari.com/tmp/product_image/$_catimage');
    // }
    //  // has file and no icon show file
    //   else if (newProductImage != null && (_catimage == null || _catimage == "")) {
    //     return FileImage(newProductImage);
    //   }
    else {
      return FileImage(newProductImage);
    }
  }

  void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            title: Text(
              "اطلاعات با موفقیت ذخیره شد",
              style: TextStyle(color: Colors.green),
            ),
            content: Text("آیا دوست دارید اطلاعات جدید ذخیره کنید ؟"),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              FlatButton.icon(
                icon: Icon(Icons.cancel),
                label: Text("بیخیال !"),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => Home()));
                },
              ),
              FlatButton.icon(
                icon: Icon(
                  Icons.add,
                  color: Colors.pink.shade700,
                ),
                onPressed: (){},
                label: Text('محصول جدید',
                    style: TextStyle(
                      color: Colors.pink.shade700,
                    )),
              )
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Directionality(
      textDirection: TextDirection.rtl,
      child: Stack(
        textDirection: TextDirection.rtl,
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('images/proback.jpg'),
                    fit: BoxFit.cover,
                    colorFilter:
                        ColorFilter.mode(Colors.white54, BlendMode.hardLight))),
          ),
          SingleChildScrollView(
            child: Column(children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: 60.0),
                alignment: Alignment.center,
                child: Text(
                  "مشخصات محصول",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.none,
                      fontSize: 25.0,
                      fontFamily: Theme.of(context).textTheme.title.fontFamily,
                      color: Theme.of(context).primaryColor),
                ),
              ),
              ScopedModelDescendant<MainModel>(
                builder: (context, child, model) {
                  return productForm(context, model);
                },
              ),
              ButtonBar(
                alignment: MainAxisAlignment.center,
                children: <Widget>[
                  ScopedModelDescendant<MainModel>(
                    builder: (context, child, model) {
                      return RaisedButton(
                        color: Colors.pink,
                        child: Text("ثبت محصول"),
                        onPressed: () {
                          ProductModel newProduct = ProductModel(
                              product_name: _productNameController.text,
                              product_category: selectedCategoriID,
                              product_des: _productDescriptionController.text,
                              product_size: _productSizeController.text,
                              product_color: _productColorController.text,
                              product_barcode: _productBarcodeController.text,
                              product_count: _productCountController.text,
                              product_price_buy:
                                  _productBuyPriceController.text,
                              product_price_sell:
                                  _productSellPriceController.text);
                          if (_formKey.currentState.validate()) {
                            _formKey.currentState.save();
                            //  _showDialog();
                            model.addProduct(newProduct, newProductImage);
                            setState(() {
                              _autoValidate = true;
                              if (model.dataAdded) {
                                Navigator.pop(context);
                              }
                            });
                          }
                        },
                      );
                    },
                  ),
                  RaisedButton(
                    color: Colors.redAccent,
                    child: Text("حذف همه "),
                    onPressed: () {},
                  )
                ],
              )
            ]),
          )
        ],
      ),
    ));
  }

  Widget productForm(context, MainModel model) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Form(
        key: _formKey,
        autovalidate: _autoValidate,
        child: Material(
          color: Colors.transparent,
          child: Theme(
              data: Theme.of(context),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Stack(
                        children: <Widget>[
                          SizedBox(
                            height: 150.0,
                            width: 120.0,
                            child: DecoratedBox(
                              decoration: ShapeDecoration(
                                  image: DecorationImage(
                                    image: chekImage(),
                                    fit: BoxFit.cover,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  )),
                            ),
                          ),
                          Container(
                            alignment: Alignment.bottomCenter,
                            height: 170.0,
                            width: 120.0,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white54,
                                  ),
                                  child: IconButton(
                                    iconSize: 30,
                                    padding: EdgeInsets.all(0.0),
                                    icon: Icon(Icons.camera_alt),
                                    onPressed: () => getImageCamera(),
                                    color: Colors.grey,
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white54,
                                  ),
                                  child: IconButton(
                                    iconSize: 30,
                                    padding: EdgeInsets.all(0.0),
                                    icon: Icon(Icons.photo_album),
                                    onPressed: () => getImageGallery(),
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text("نام محصول",
                                  style: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context)
                                          .textTheme
                                          .title
                                          .color)),
                              TextFormField(
                                controller: _productNameController,
                                autovalidate: _autoValidate,
                                decoration: InputDecoration(
                                    hintText: 'نام محصول را وارد کنید'),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'نام محصول را وارد کنید';
                                  }
                                },
                              ),
                              TextFormField(
                                controller: _productDescriptionController,
                                autovalidate: _autoValidate,
                                keyboardType: TextInputType.multiline,
                                maxLines: 2,
                                decoration: InputDecoration(
                                    hintText: 'توضیحات محصول را وارد کنید'),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'توضیحات محصول را وارد کنید';
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Text('دسته بندی :',
                            style: TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold,
                                color:
                                    Theme.of(context).textTheme.title.color)),
                      ),
                      Expanded(
                          flex: 2,
                          child: DropdownButtonFormField(
                            value: selectMenuItem,
                            hint: Text("یک دسته را انتخاب کنید"),
                            validator: (value) {
                              if (value == null) {
                                return 'دسته بندی را انتخاب کنید';
                              }
                            },
                            items: model.loadListItem(),
                            onChanged: (value) {
                              selectMenuItem = value;
                              //  Find Category ID for send to Add new Product
                              setState(() {
                                selectedCategoriID = model
                                    .findSelectedCategoryID(selectMenuItem);
                              });
                            },
                          ))
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Text('تعداد :',
                            style: TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold,
                                color:
                                    Theme.of(context).textTheme.title.color)),
                      ),
                      Expanded(
                        flex: 2,
                        child: TextFormField(
                          controller: _productCountController,
                          autovalidate: _autoValidate,
                          keyboardType: TextInputType.number,
                          maxLines: 1,
                          decoration:
                              InputDecoration(hintText: 'تعداد محصول   '),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'تعداد محصول را وارد کنید';
                            }
                          },
                        ),
                      ),
                      SizedBox(width: 8.0),
                      Expanded(
                        flex: 1,
                        child: Text('رنگ :',
                            style: TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold,
                                color:
                                    Theme.of(context).textTheme.title.color)),
                      ),
                      Expanded(
                        flex: 2,
                        child: TextFormField(
                          controller: _productColorController,
                          autovalidate: _autoValidate,
                          keyboardType: TextInputType.text,
                          maxLines: 1,
                          decoration: InputDecoration(hintText: 'رنگ محصول'),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'رنگ محصول را وارد کنید';
                            }
                          },
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Text('سایز :',
                            style: TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold,
                                color:
                                    Theme.of(context).textTheme.title.color)),
                      ),
                      Expanded(
                        flex: 2,
                        child: TextFormField(
                          controller: _productSizeController,
                          autovalidate: _autoValidate,
                          maxLines: 1,
                          decoration:
                              InputDecoration(hintText: 'سایز محصول   '),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'سایز محصول را وارد کنید';
                            }
                          },
                        ),
                      ),
                      SizedBox(width: 8.0),
                      Expanded(flex: 1, child: Container()),
                      Expanded(flex: 2, child: Container())
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Text('قیمت خرید :',
                            style: TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold,
                                color:
                                    Theme.of(context).textTheme.title.color)),
                      ),
                      Expanded(
                        flex: 2,
                        child: TextFormField(
                          controller: _productBuyPriceController,
                          autovalidate: _autoValidate,
                          keyboardType: TextInputType.number,
                          maxLines: 1,
                          decoration: InputDecoration(
                              suffixText: 'تومان', hintText: ' به تومان'),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'قیمت خرید محصول را وارد کنید';
                            }
                          },
                        ),
                      ),
                      SizedBox(width: 8.0),
                      Expanded(
                        flex: 1,
                        child: Text('قیمت فروش :',
                            style: TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold,
                                color:
                                    Theme.of(context).textTheme.title.color)),
                      ),
                      Expanded(
                        flex: 2,
                        child: TextFormField(
                          controller: _productSellPriceController,
                          autovalidate: _autoValidate,
                          keyboardType: TextInputType.number,
                          maxLines: 1,
                          decoration: InputDecoration(
                              suffixText: 'تومان', hintText: ' به تومان'),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'قیمت فروش محصول را وارد کنید';
                            }
                          },
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          flex: 2,
                          child: Material(
                            color: Theme.of(context).buttonColor,
                            borderRadius: BorderRadius.circular(15.0),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(15.0),
                              splashColor: Colors.pink,
                              onTap: () {
                                String result;
                                result = model.scanResult;
                                print("SCAN RESULT: $result");
                                if (result != null)
                                  setState(() {
                                    _productBarcodeController.text = result;
                                  });
                              },
                              child: Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.camera,
                                    color: Colors.white,
                                  ),
                                  Text(
                                    'اسکن بارکد با دوربین',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 8.0,
                        ),
                        Expanded(
                          flex: 2,
                          child: TextFormField(
                            controller: _productBarcodeController,
                            autovalidate: _autoValidate,
                            keyboardType: TextInputType.number,
                            maxLines: 1,
                            decoration: InputDecoration(hintText: ' بارکد '),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'بارکد محصول را وارد کنید';
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              )),
        ),
      ),
    );
  }
}
