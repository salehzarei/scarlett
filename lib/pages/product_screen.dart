import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../menu/zoomsacaffold.dart';
import '../pages/addoreditProduct.dart';
import '../scoped/mainmodel.dart';
import '../widget/make_product_gridview.dart';
import '../widget/backdrop.dart';
import './category_menu_page.dart';

String _productCategoriTitle = "همه دسته ها";
String _selectedCategoriId = "0";

final productScreen = Screen(
    title: "لیست محصولات ",
    background: DecorationImage(
        colorFilter: ColorFilter.mode(Colors.white30, BlendMode.color),
        image: AssetImage('images/proback.jpg'),
        fit: BoxFit.cover),
    contentBuilder: (BuildContext context) {
      return BackDropScreen(
        categoryId: _selectedCategoriId,
      );
    });

class BackDropScreen extends StatefulWidget {
  final String categoryId;
  BackDropScreen({this.categoryId});

  _BackDropScreenState createState() => _BackDropScreenState();
}

class _BackDropScreenState extends State<BackDropScreen> {
  _selectedItem(String selecteditem) {
    setState(() {
      _selectedCategoriId = selecteditem;
      print("Run Backdrop for load new data CatId :${_selectedCategoriId}");
      runNewBackScreen(_selectedCategoriId);
    });
  }

  _categoryName(String categoryName) {
    setState(() {
      _productCategoriTitle = categoryName;
      //   print(_productCategori);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (context, child, model) {
        //  if (widget.categoryId != "0") {
        //   _selectedCategoriId = widget.categoryId;
        //   model.fetchSelectedProducts(_selectedCategoriId);
        // }
        return BackDrop(
          forntLayer: FrontLy(
            model: model,
            currentID: _selectedCategoriId,
          ),
          backLayer: CategoryMenuPage(
            model: model,
            currentcategoryID: _selectedCategoriId,
            onCategoryTap: _selectedItem,
            categoryName: _categoryName,
          ),
          currentCategory: _productCategoriTitle,
          forntTitle: Text('اسکارلت'),
          backTitle: Text('منو'),
        );
      },
    );
  }
}

class FrontLy extends StatelessWidget {
  final MainModel model;
  final String currentID;
  FrontLy({this.model, this.currentID});

  @override
  Widget build(BuildContext context) {
   
 print("Run FrontLy curretId : ${currentID}");
    if (currentID != "0") {
      model.fetchSelectedProducts(currentID);
    } 
    
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: MakeProductGridView(
        currentcategoryID: currentID,
        model: model,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).buttonColor,
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => AddorEditProduct()));
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}

runNewBackScreen(categoryId) {
  BackDropScreen(
    categoryId: categoryId,
  );
}
