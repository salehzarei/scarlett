import 'dart:io';
import 'dart:math' as Math;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as Img;

import '../scoped/mainmodel.dart';
import '../models/categories_model.dart';
import '../pages/home.dart';

class AddCategorie extends StatefulWidget {
  bool categoriState = true;
  int catindex;
  CategoriesModel newCategorie;
  List<CategoriesModel> categorilist;

  AddCategorie({this.catindex, this.categorilist});
  _AddCategorieState createState() => _AddCategorieState();
}

class _AddCategorieState extends State<AddCategorie> {
  @override
  initState() {
    if (widget.categorilist != null) {
      _categoienameController.text =
          widget.categorilist[widget.catindex].categoie_name;
      _categoriedesController.text =
          widget.categorilist[widget.catindex].categorie_des;
      widget.categoriState =
          widget.categorilist[widget.catindex].categorie_state == "true";
      _catimage = widget.categorilist[widget.catindex].categorie_icon;

      _saveButtonText = "تغییر مشخصات";
      _isUpdatePage = true;
    }
    super.initState();
  }

  bool _isUpdatePage = false;
  File _cateImageFile;
  String _catimage, _saveButtonText = "ثبت اطلاعات";
  TextEditingController _categoienameController = TextEditingController();
  TextEditingController _categoriedesController = TextEditingController();
  

  Future getImageGallery() async {
    var imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    int rand = Math.Random().nextInt(10000);
    if (imageFile != null) {
      Img.Image image = Img.decodeImage(imageFile.readAsBytesSync());
      Img.Image smallerImg = Img.copyResize(image, 500);

      var compressImg = File("$path/categorie_image_$rand.jpg")
        ..writeAsBytesSync(Img.encodeJpg(smallerImg, quality: 85));

      setState(() {
        _cateImageFile = compressImg;
      });
    }
  }

  chekImage() {
    // no new file and empty icon show defult icon
    if (_cateImageFile == null && (_catimage == null || _catimage == "")) {
      return AssetImage('images/noimage.png');
    }
    // has file and have icon show File
    // else if (_cateImageFile != null && _catimage != null) {
    //   return FileImage(_cateImageFile);
    // }
    // no file and has icon show icon
    else if (_cateImageFile == null && _catimage != null) {
      return NetworkImage('https://mashhadsafari.com/tmp/cat_image/$_catimage');
    }
// has file and no icon show file
    else if (_cateImageFile != null && (_catimage == null || _catimage == "")) {
      return FileImage(_cateImageFile);
    } else {
      return FileImage(_cateImageFile);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(builder: (context, child, model) {
      return Scaffold(
          appBar: AppBar(
            title: widget.catindex == null
                ? Text(
                    "دسته بندی جدید",
                  )
                : Text(
                    "ویرایش دسته بندی ${widget.categorilist[widget.catindex].categoie_name}",
                    textDirection: TextDirection.rtl,
                  ),
                  backgroundColor: Theme.of(context).backgroundColor,
            centerTitle: true,
          ),
          body: SingleChildScrollView(
              child: Directionality(
            textDirection: TextDirection.rtl,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: SizedBox(
                      height: 120.0,
                      width: 185.0,
                      child: GestureDetector(
                        onTap: () {
                          getImageGallery();
                        },
                        child: DecoratedBox(
                          decoration: ShapeDecoration(
                              shadows: [
                                BoxShadow(
                                    color: Colors.indigoAccent,
                                    blurRadius: 15.0)
                              ],
                              color: Colors.amber,
                              image: DecorationImage(
                                  fit: BoxFit.cover, image: chekImage()),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0))),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 15.0, right: 15.0),
                    child: Form(
                      autovalidate: true,
                        child: ListBody(
                      mainAxis: Axis.vertical,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 8.0, right: 8.0, top: 10.0),
                          child: TextField(
                            
                            controller: _categoienameController,
                            style: Theme.of(context)
                                .inputDecorationTheme
                                .hintStyle,
                            decoration: InputDecoration(
                              labelText: "نام دسته بندی",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0)),
                              labelStyle: TextStyle(fontSize: 18.0),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 8.0, right: 8.0, top: 10.0),
                          child: TextField(
                            controller: _categoriedesController,
                            style: Theme.of(context)
                                .inputDecorationTheme
                                .hintStyle,
                            decoration: InputDecoration(
                              labelText: "توضیحات دسته بندی",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0)),
                              labelStyle: TextStyle(fontSize: 18.0),
                            ),
                          ),
                        )
                      ],
                    )),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 15.0, right: 15.0, top: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: Container(),
                        ),
                        Expanded(
                          child: SwitchListTile(
                            title: Text("وضعیت"),
                            value: widget.categoriState,
                            onChanged: (bool value) {
                              setState(() {
                                /// نکته اگر از اسکوپت استفاده کردیم بهتر است ویجت کنیم مقدار دکمه را
                                widget.categoriState = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  OutlineButton.icon(
                    icon: Icon(Icons.add),
                    label: Text(_saveButtonText),
                    borderSide:
                        BorderSide(color: Colors.tealAccent, width: 2.0),
                    splashColor: Colors.tealAccent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0)),
                    onPressed: () {
                     // make Model with id for add new
                      if (_isUpdatePage) {
                        CategoriesModel newcatd = new CategoriesModel(
                            categorie_id: widget
                                .categorilist[widget.catindex].categorie_id,
                            categorie_icon: widget
                                .categorilist[widget.catindex].categorie_icon,
                            categoie_name: _categoienameController.text,
                            categorie_des: _categoriedesController.text,
                            categorie_state: widget.categoriState.toString());
                        model.updateCategories(newcatd, _cateImageFile);
                      }
                      //make model without id for edit category with own id
                      else {
                        CategoriesModel newcatd = new CategoriesModel(
                            categoie_name: _categoienameController.text,
                            categorie_des: _categoriedesController.text,
                            categorie_state: widget.categoriState.toString());
                        model.addCategories(newcatd, _cateImageFile);
                      }

                      if (model.dataAdded) {
                      
                       Navigator.pop(context);
                      }
                    },
                  ),
                ]),
          )));
    });
  }
}
