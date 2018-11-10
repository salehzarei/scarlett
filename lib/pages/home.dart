import 'dart:async';

import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:transparent_image/transparent_image.dart';

import '../model/mainmodel.dart';
import '../models/categories_model.dart';
import '../pages/addoreditCategories.dart';

class Home extends StatefulWidget {
  MainModel model;
  Home({this.model});
  // bool _switchValue = true;
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String selectMenuItem;
  CategoriesModel categorieData;

  /// اجرای یک تابع در اسکوپ
  @override
  void initState() {
    widget.model.fetchCategories();
    super.initState();
  }



  @override
  Widget build(BuildContext context) {

    // TextStyle textStyle = Theme.of(context).textTheme.title;
    return ScopedModelDescendant<MainModel>(builder: (context, child, model) {
      return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          centerTitle: true,
          title: Text("لیست دسته بندی ها"),
          // actions: <Widget>[
          //   DropdownButton(
          //     value: selectMenuItem,
          //     hint: Text("یک دسته را انتخاب کنید"),
          //     style: textStyle,
          //     items: model.loadListItem(),
          //     onChanged: (value) {
          //       selectMenuItem = value;
          //       //  باعث بروز شدن وضعیت منو می شود
          //       setState(() {
          //         model.giveSelectedMenuItem(selectMenuItem);
          //         // اجرای یک تابع در اسکوپ
          //         // model.fetchCategories();
          //       });
          //     },
          //   )
          // ],
        ),
        body: model.isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ShowCatgoreiList(context, model),
        // : Center(
        //     child: Text("هیچ دسته بندی وجود ندارد !",textDirection: TextDirection.rtl,),
        //   ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => AddCategorie()));
          },
        ),
      );
    });
  }
}

Widget ShowCatgoreiList(BuildContext context, MainModel model) {
  int _count = 0;
  if (model.categoriData.length != 0) {
    _count = model.categoriData.length;
  }

  return Directionality(
    textDirection: TextDirection.rtl,
    child: Padding(
      padding: EdgeInsets.all(15.0),
      child: ListView.builder(
        itemCount: _count,
        itemBuilder: (context, index) {
          return Dismissible(
            background: Container(
              height: 2.0,
              width: 2.0,
              color: Colors.red,
              child: Text("حذف این دسته بندی"),
            ),
            key: Key(model.categoriData[index].categorie_id),
            onDismissed: (direction) {
              showDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (BuildContext context) =>
                      deleteItemsDialog(context, model, index));
              //   model.categoriData.removeAt(index);
            },
            child: Card(
              color: Colors.transparent,
              child: ListTile(
                title: Text(
                  model.categoriData[index].categoie_name,
                  style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
                ),
                leading: model.categoriData[index].categorie_icon != ""
                    ? FadeInImage.assetNetwork(
                        image:
                            'https://mashhadsafari.com/tmp/cat_image/${model.categoriData[index].categorie_icon}',
                        // placeholder: kTransparentImage,
                        placeholder: 'images/Bars-1s-200px.gif',
                        height: 45.0,
                        width: 45.0,
                        fit: BoxFit.cover,
                      )
                    : Image(
                        image: AssetImage('images/noimage.png'),
                        height: 45.0,
                        width: 45.0,
                        fit: BoxFit.cover,
                      ),
                subtitle: Text(model.categoriData[index].categorie_des),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    showDialog(
                        context: context,
                        barrierDismissible: true,
                        builder: (BuildContext context) =>
                            deleteItemsDialog(context, model, index));
                    // AlertDialog alartfordelete = AlertDialog(
                    //   title: Icon(Icons.warning),
                    //   content: Text(" آیا مطمعن هستید برای حذف ؟"),
                    //   actions: <Widget>[
                    //     OutlineButton(
                    //       child: Text("بله"),
                    //       onPressed: () {
                    //         model.deleteCategories(
                    //             model.categoriData[index].categorie_id,
                    //             model.categoriData[index].categorie_icon);
                    //         Navigator.push(
                    //             context,
                    //             MaterialPageRoute(
                    //                 builder: (BuildContext context) =>
                    //                     Home(model: model)));
                    //       },
                    //     ),
                    //     OutlineButton(
                    //       child: Text("نه ببخشید !"),
                    //       onPressed: () {
                    //         Navigator.pop(context);
                    //       },
                    //     ),
                    //   ],
                    // );
                    // showDialog(
                    //     context: context,
                    //     barrierDismissible: true,
                    //     builder: (BuildContext context) => alartfordelete);
                  },
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => AddCategorie(
                                catindex: index,
                                categorilist: model.categoriData,
                              )));
                },
              ),
            ),
          );
        },
      ),
    ),
  );
}

deleteItemsDialog(BuildContext context, MainModel model, int index) {
  AlertDialog alartfordelete = AlertDialog(
    title: Icon(Icons.warning),
    content: Text(" آیا مطمعن هستید برای حذف ؟"),
    actions: <Widget>[
      OutlineButton(
        child: Text("بله"),
        onPressed: () {
          model.deleteCategories(model.categoriData[index].categorie_id,
              model.categoriData[index].categorie_icon);
          model.categoriData.removeAt(index);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => Home(model: model)));
        },
      ),
      OutlineButton(
        child: Text("نه ببخشید !"),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    ],
  );
  return alartfordelete;
}
