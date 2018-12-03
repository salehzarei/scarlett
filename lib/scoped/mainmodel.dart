import 'dart:convert';
import 'dart:io';
import 'package:async/async.dart';
import 'package:path/path.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';

import 'package:scoped_model/scoped_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/categories_model.dart';
import '../models/product_model.dart';

class MainModel extends Model {
  List<DropdownMenuItem<String>> dropDownItem = [];
  String scanshow = "نتیجه اسکن";
  List<String> dropDownItmes = [];
  List<CategoriesModel> categoriData = [];
  List<ProductModel> productData = [];
  List<ProductModel> selectedProductData = [];
  bool dataAdded = true;
  bool isLoading = false;
  bool isLoadingProductData = false;
  bool isLoadingAllProduct = false;



  Future fetchCategories() async {
    categoriData.clear();
    isLoading = true;
    notifyListeners();
    final response =
        await http.get('https://mashhadsafari.com/tmp/getcategories.php');
    List<dynamic> data = json.decode(response.body);
    CategoriesModel categories = CategoriesModel();
    data.forEach((dynamic catdata) {
      categories = CategoriesModel(
          categorie_id: catdata['categorie_id'].toString(),
          categoie_name: catdata['categoie_name'].toString(),
          categorie_des: catdata['categorie_des'].toString(),
          categorie_icon: catdata['categorie_icon'].toString(),
          categorie_state: catdata['categorie_state'].toString());

      // اصافه کردن لیست دسته بندی برای دراپ داون
      dropDownItmes.add(catdata['categoie_name'].toString());
      categoriData.add(categories);
      notifyListeners();
    });

    isLoading = false;
    notifyListeners();
    return categoriData;
  }

  Future fetchProducts() async {
    print("fetchAllPro");
    productData.clear();
    isLoadingAllProduct = true;
    notifyListeners();
    final response =
        await http.get('https://mashhadsafari.com/tmp/getproducts.php');
    List<dynamic> data = json.decode(response.body);
    ProductModel products = ProductModel();
    data.forEach((dynamic protdata) {
      products = ProductModel(
          product_id: protdata['product_id'],
          product_name: protdata['product_name'],
          product_category: protdata['product_category'],
          product_des: protdata['product_des'],
          product_color: protdata['product_color'],
          product_size: protdata['product_size'],
          product_barcode: protdata['product_barcode'],
          product_image: protdata['product_image'],
          product_count: protdata['product_count'],
          product_price_buy: protdata['product_price_buy'],
          product_price_sell: protdata['product_price_sell']);
      productData.add(products);
      notifyListeners();
    });

    isLoadingAllProduct = false;
    notifyListeners();
    return productData;
  }

  Future fetchSelectedProducts(String categoryid) async {
   // print("Run Fetch for $categoryid");
    selectedProductData.clear();
    isLoadingProductData = true;
    notifyListeners();
    final response =
        await http.get('https://mashhadsafari.com/tmp/getproducts.php');
    List<dynamic> data = json.decode(response.body);
    ProductModel products = ProductModel();
    data.forEach((dynamic protdata) {
      products = ProductModel(
          product_id: protdata['product_id'],
          product_name: protdata['product_name'],
          product_category: protdata['product_category'],
          product_des: protdata['product_des'],
          product_color: protdata['product_color'],
          product_size: protdata['product_size'],
          product_barcode: protdata['product_barcode'],
          product_image: protdata['product_image'],
          product_count: protdata['product_count'],
          product_price_buy: protdata['product_price_buy'],
          product_price_sell: protdata['product_price_sell']);

      if (products.product_category == categoryid) {
        selectedProductData.add(products);
      }
      notifyListeners();
    });

    isLoadingProductData = false;
    notifyListeners();
    return productData;
  }

  loadListItem() {
    dropDownItem = [];
    dropDownItem = dropDownItmes
        .map((val) => DropdownMenuItem<String>(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[Text(val)],
              ),
              value: val,
            ))
        .toList();
    return dropDownItem;
  }

  giveSelectedMenuItem(selectedItem) {
    print(selectedItem);
  }

  Future addCategories(
      CategoriesModel newCategorie, File newCategoriImage) async {
    // if Categori has Icon File
    if (newCategoriImage != null) {
      var stream =
          http.ByteStream(DelegatingStream.typed(newCategoriImage.openRead()));
      var length = await newCategoriImage.length();
      var url = Uri.parse("https://mashhadsafari.com/tmp/addcategory.php");
      var request = http.MultipartRequest("POST", url);
      var multipartFile = http.MultipartFile("categorie_icon", stream, length,
          filename: basename(newCategoriImage.path));
      request.files.add(multipartFile);
      request.fields['categoie_name'] = newCategorie.categoie_name;
      request.fields['categorie_des'] = newCategorie.categorie_des;
      request.fields['categorie_state'] = newCategorie.categorie_state;
      request.send().then((resopnse) {
        if (resopnse.statusCode == 200) {
          print("Upload Data Ok");
          dataAdded = true;
          notifyListeners();
        } else {
          print("Error to Upload Data:${resopnse.statusCode} ");
        }
      });
    }
    // if categori has not Icon file . send empty image to data base
    else {
      var url = Uri.parse("https://mashhadsafari.com/tmp/addcategory.php");
      var request = http.MultipartRequest("POST", url);
      request.fields['categoie_name'] = newCategorie.categoie_name;
      request.fields['categorie_des'] = newCategorie.categorie_des;
      request.fields['categorie_icon'] = "";
      request.fields['categorie_state'] = newCategorie.categorie_state;
      request.send().then((resopnse) {
        if (resopnse.statusCode == 200) {
          print("Upload Data Ok");
          dataAdded = true;
          notifyListeners();
        } else {
          print("Error to Upload Data:${resopnse.statusCode} ");
        }
      });
    }
  }

  //// add Products
  Future addProduct(ProductModel newProduct, File newProductImage) async {
    // if Product has Icon File
    if (newProductImage != null) {
      var stream =
          http.ByteStream(DelegatingStream.typed(newProductImage.openRead()));
      var length = await newProductImage.length();
      var url = Uri.parse("https://mashhadsafari.com/tmp/addproducts.php");
      var request = http.MultipartRequest("POST", url);
      var multipartFile = http.MultipartFile("product_image", stream, length,
          filename: basename(newProductImage.path));
      request.files.add(multipartFile);
      print(newProductImage);
      request.fields['product_name'] = newProduct.product_name;
      print(newProduct.product_name);
      request.fields['product_category'] = newProduct.product_category;
      print(newProduct.product_category);
      request.fields['product_des'] = newProduct.product_des;
      print(newProduct.product_des);
      request.fields['product_color'] = newProduct.product_color;
      print(newProduct.product_color);
      request.fields['product_size'] = newProduct.product_size;
      print(newProduct.product_size);
      request.fields['product_barcode'] = newProduct.product_barcode;
      print(newProduct.product_barcode);
      request.fields['product_count'] = newProduct.product_count;
      print(newProduct.product_count);
      request.fields['product_price_buy'] = newProduct.product_price_buy;
      print(newProduct.product_price_buy);
      request.fields['product_price_sell'] = newProduct.product_price_sell;
      print(newProduct.product_price_sell);

      request.send().then((resopnse) {
        if (resopnse.statusCode == 200) {
          print("Upload Data Ok");
          dataAdded = true;
          notifyListeners();
        } else {
          print("Error to Upload Data:${resopnse.statusCode} ");
        }
      });
    }
    // if categori has not Icon file . send empty image to data base
    else {
      var url = Uri.parse("https://mashhadsafari.com/tmp/addproduct.php");
      var request = http.MultipartRequest("POST", url);
      request.fields['product_name'] = newProduct.product_name;
      request.fields['product_category'] = newProduct.product_category;
      request.fields['product_des'] = newProduct.product_des;
      request.fields['product_color'] = newProduct.product_color;
      request.fields['product_size'] = newProduct.product_size;
      request.fields['product_barcode'] = newProduct.product_barcode;
      request.fields['product_count'] = newProduct.product_count;
      request.fields['product_price_buy'] = newProduct.product_price_buy;
      request.fields['product_price_sell'] = newProduct.product_price_sell;
      request.fields['product_image'] = "";

      request.send().then((resopnse) {
        if (resopnse.statusCode == 200) {
          print("Upload Data Ok");
          dataAdded = true;
          notifyListeners();
        } else {
          print("Error to Upload Data:${resopnse.statusCode} ");
        }
      });
    }
  }

  Future updateCategories(
      CategoriesModel newCategorie, File newCategoriImage) async {
    if (newCategoriImage != null) {
      var stream =
          http.ByteStream(DelegatingStream.typed(newCategoriImage.openRead()));
      var length = await newCategoriImage.length();
      var url = Uri.parse("https://mashhadsafari.com/tmp/editcategory.php");
      var request = http.MultipartRequest("POST", url);
      var multipartFile = http.MultipartFile("categorie_icon", stream, length,
          filename: basename(newCategoriImage.path));
      request.files.add(multipartFile);
      request.fields['categorie_id'] = newCategorie.categorie_id;
      request.fields['categoie_name'] = newCategorie.categoie_name;
      request.fields['categorie_des'] = newCategorie.categorie_des;
      request.fields['categorie_state'] = newCategorie.categorie_state;
      request.send().then((resopnse) {
        if (resopnse.statusCode == 200) {
          print("Edit Data Ok");
          dataAdded = true;
          notifyListeners();
        } else {
          print("Error to Edit Data:${resopnse.statusCode} ");
        }
      });
    } else {
      ///

      var url = Uri.parse("https://mashhadsafari.com/tmp/editcategory.php");
      var request = http.MultipartRequest("POST", url);
      request.fields['categorie_id'] = newCategorie.categorie_id;
      request.fields['categoie_name'] = newCategorie.categoie_name;
      request.fields['categorie_des'] = newCategorie.categorie_des;
      request.fields['categorie_icon'] = newCategorie.categorie_icon;
      request.fields['categorie_state'] = newCategorie.categorie_state;
      request.send().then((resopnse) {
        if (resopnse.statusCode == 200) {
          print("Edit Data Ok");
          dataAdded = true;
          notifyListeners();
        } else {
          print("Error to Edit Data:${resopnse.statusCode} ");
        }
      });

      ///

    }
  }

// delete Categori with Picture file
  Future deleteCategories(String id, String icon) async {
    await http.post("https://mashhadsafari.com/tmp/deletecategory.php",
        body: {'categorie_id': id, 'categorie_icon': icon});
    print("id:$id");
    print("icon:$icon");
  }

  /// Barcode Scanner

  Future barcodeScan() async {
    try {
      String scanresult = await BarcodeScanner.scan();
      scanshow = int.parse(scanresult).toString();
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        scanshow = 'خطای دسترسی به دوربین';
      } else {
        scanshow = 'خطای نامشخص';
      }
    } on FormatException {
      scanshow = 'برگردید به عقب';
    } catch (e) {
      scanshow = 'خطای نامشخص : $e';
    }
    return scanshow;
  }
}
