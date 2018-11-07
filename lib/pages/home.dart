import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:transparent_image/transparent_image.dart';

import '../model/mainmodel.dart';
import '../models/categories_model.dart';
import '../pages/addoreditCategories.dart';

class Home extends StatefulWidget {
  MainModel model;
  Home({this.model});
  bool _switchValue = true;
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
    TextStyle textStyle = Theme.of(context).textTheme.title;
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
        body: widget.model.categoriData.length != 0
            ? ShowCatgoreiList(context, model)
            : Center(
                child: Text("هیچ دسته بندی وجود ندارد !",textDirection: TextDirection.rtl,),
              ),
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
  if (model.dropDownItem.length != 0) {
    _count = model.dropDownItem.length;
  }

  return Directionality(
    textDirection: TextDirection.rtl,
    child: Padding(
      padding: EdgeInsets.all(15.0),
      child: ListView.builder(
        itemCount: _count,
        itemBuilder: (context, index) {
          return Card(
            color: Colors.transparent,
            child: ListTile(
              title: Text(
                model.categoriData[index].categoie_name,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
              ),
              leading: CircleAvatar(
                child: FadeInImage.memoryNetwork(
                  image:
                      'https://mashhadsafari.com/tmp/cat_image/${model.categoriData[index].categorie_icon}',
                  placeholder: kTransparentImage,
                ),
                radius: 27.0,
                //   backgroundImage: NetworkImage(
                //       'https://mashhadsafari.com/tmp/cat_image/${model.categoriData[index].categorie_icon}'),
              ),
              subtitle: Text(model.categoriData[index].categorie_des),
              trailing: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  AlertDialog alartfordelete = AlertDialog(
                    title: Icon(Icons.warning),
                    content: Text(" آیا مطمعن هستید برای حذف ؟"),
                    actions: <Widget>[
                      OutlineButton(
                        child: Text("بله"),
                        onPressed: () {
                          model.deleteCategories(
                              model.categoriData[index].categorie_id,
                              model.categoriData[index].categorie_icon);
                          Navigator.pop(context);
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
                  showDialog(
                      context: context,
                      barrierDismissible: true,
                      builder: (BuildContext context) => alartfordelete);
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
          );
        },
      ),
    ),
  );
}
