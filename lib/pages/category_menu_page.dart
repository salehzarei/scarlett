import 'package:flutter/material.dart';

import '../scoped/mainmodel.dart';

class CategoryMenuPage extends StatelessWidget {
  final MainModel model;
  final String currentcategoryID;
  final ValueChanged<String> onCategoryTap;
  final ValueChanged<String> categoryName;

  const CategoryMenuPage(
      {this.model,
      this.onCategoryTap,
      this.currentcategoryID,
      this.categoryName});

  Widget _builCategory(BuildContext context, int index, String category) {
    return InkWell(
        borderRadius: BorderRadius.circular(15.0),
        splashColor: Colors.pink.shade100,
        highlightColor: Colors.pink.shade200,
        onTap: () {
          onCategoryTap(model.categoriData[index].categorie_id);
          categoryName(model.categoriData[index].categoie_name);
          model.fetchSelectedProducts(model.categoriData[index].categorie_id);
             },
        child: category == model.categoriData[index].categoie_name
            ? Column(
                children: <Widget>[
                  SizedBox(height: 16.0),
                  Container(
                    color: Colors.white54,
                    height: 30.0,
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: Text(
                      model.categoriData[index].categoie_name,
                      style: Theme.of(context).textTheme.title,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 14.0),
                  Container(
                    width: 70.0,
                    height: 2.0,
                  ),
                ],
              )
            : Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Container(
                  color: Colors.white,
                  child: Text(
                    model.categoriData[index].categoie_name,
                    style: Theme.of(context).textTheme.body2,
                    textAlign: TextAlign.center,
                  ),
                ),
              ));
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.only(top: 40.0),
        child: ListView.builder(
          itemCount: model.categoriData.length,
          itemBuilder: (context, index) {
            return _builCategory(
                context, index, model.categoriData[index].categoie_name);
          },
        ),
      ),
    );
  }
}
