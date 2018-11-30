import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../scoped/mainmodel.dart';
import '../pages/addoreditCategories.dart';
import '../pages/home.dart';
import '../menu/zoomsacaffold.dart';

final Screen categoriesScreen = Screen(
    title: "لیست دسته بندی ها",
    background: DecorationImage(
        image: AssetImage('images/samuel.jpg'),
        fit: BoxFit.cover,
      //  colorFilter: ColorFilter.mode(Colors.white, BlendMode.overlay)
      ),
    contentBuilder: (BuildContext context) {
      return Scaffold(
        backgroundColor: Colors.transparent,
        floatingActionButton: FloatingActionButton(
        onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>AddCategorie())), 
          backgroundColor: Theme.of(context).buttonColor,
          child: Icon(Icons.add , color: Colors.white,),
        ),

        body: _showList(),
      );

    });

Widget _showList() {
  return ScopedModelDescendant<MainModel>(
    builder: (context, child, model) {
      Widget content = Center(
        child: Text("هیچ چیزی ثبت نشده"),
      );
      if (model.categoriData.length > 0 && !model.isLoading) {
        content = ShowCatgoreiList(context, model);
      } else if (model.isLoading) {
        content = Center(
          child: CircularProgressIndicator(),
        );
      }
      return RefreshIndicator(
        child: content,
        onRefresh: model.fetchCategories,
      );
    },
  );
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
              color: Colors.red.shade900,
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
              color: Theme.of(context).cardColor,
              child: ListTile(
                title: Text(
                  model.categoriData[index].categoie_name,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
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
