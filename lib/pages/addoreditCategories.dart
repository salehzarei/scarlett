import 'dart:io';
import 'dart:math' as Math;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as Img;

import '../model/mainmodel.dart';
import '../models/categories_model.dart';

class AddCategorie extends StatefulWidget {
  bool categoriState = true;
  int catindex;
  CategoriesModel newCategorie;
  List<CategoriesModel> categorilist;
  File newCategoriImage;
  AddCategorie({this.catindex, this.categorilist});
  _AddCategorieState createState() => _AddCategorieState();
}

class _AddCategorieState extends State<AddCategorie> {
  TextEditingController _categoienameController = TextEditingController();
  TextEditingController _categoriedesController = TextEditingController();

  Future getImageGallery() async {
    var imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    int rand = Math.Random().nextInt(10000);
    Img.Image image = Img.decodeImage(imageFile.readAsBytesSync());
    Img.Image smallerImg = Img.copyResize(image, 500);

    var compressImg = File("$path/categorie_image_$rand.jpg")
      ..writeAsBytesSync(Img.encodeJpg(smallerImg, quality: 85));

    setState(() {
      widget.newCategoriImage = compressImg;
    });
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
                        onTap: getImageGallery,
                        child: DecoratedBox(
                          decoration: ShapeDecoration(
                              shadows: [
                                BoxShadow(
                                    color: Colors.indigoAccent,
                                    blurRadius: 15.0)
                              ],
                              color: Colors.amber,
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: widget.newCategoriImage == null
                                      ? AssetImage('images/noimage.png')
                                      : FileImage(widget.newCategoriImage)),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0))),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 15.0, right: 15.0),
                    child: Form(
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
                    label: Text("ثبت اطلاعات"),
                    borderSide:
                        BorderSide(color: Colors.tealAccent, width: 2.0),
                    splashColor: Colors.tealAccent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0)),
                    onPressed: () {
                      _categoriedesController.text;

                      CategoriesModel newcatd = new CategoriesModel(
                          categoie_name: _categoienameController.text,
                          categorie_des: _categoriedesController.text,
                          categorie_state: widget.categoriState.toString());

                      model.addCategories(newcatd, widget.newCategoriImage);
                      print(model.dataAdded);
                      if(model.dataAdded) {
                        Navigator.pop(context);
                      }
                    },
                  ),
                ]),
          )));
    });
  }
}
