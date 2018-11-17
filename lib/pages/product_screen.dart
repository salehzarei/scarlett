import 'package:flutter/material.dart';
import '../pages/zoomsacaffold.dart';

final productScreen = Screen(
    title: "لیست محصولات ",
    background: DecorationImage(
        image: AssetImage('images/proback.jpg'), fit: BoxFit.cover),
    contentBuilder: (BuildContext context) {
      return Container();
    });




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
