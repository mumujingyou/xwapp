import 'dart:ui';

import 'package:connectivity/connectivity.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:xingwang_project/Model/productType.dart';
import 'package:xingwang_project/Pages/good_list_page.dart';
import 'package:xingwang_project/Utils/application.dart';
import 'package:xingwang_project/api/api.dart';
import 'package:xingwang_project/routers/application.dart';
import 'package:xingwang_project/routers/routes.dart';

import 'main_Page.dart';

class Index extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return IndexState();
  }
}

class IndexState extends State<Index> {
  List<ProductType> lists = [];

  //添加热销
  void addReXiao() {
    ProductType productType = new ProductType(id: "", typeName: "热销");
    lists.insert(0, productType);
  }

  @override
  void initState() {
    super.initState();

    addReXiao();
    getProductType();
  }



  void getProductType() async {
    API.getProductType().then((value) {
      setState(() {
        lists.addAll(value);
      });
    });
  }

  double width = 0;
  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;

    return new DefaultTabController(
      length: lists.length,
      child: new Scaffold(
        appBar: new AppBar(
            automaticallyImplyLeading: false,

            backgroundColor: ApplicationUtils.appBarColor,
            title: const Text(
              '商场',
              style: TextStyle(fontSize: 25),
            ),
            centerTitle: true,
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(50),
              child: Material(
                  color: Colors.white,
                  child: TabBar(
                      labelStyle: TextStyle(fontSize: 18),
                      labelPadding:
                      EdgeInsets.symmetric(horizontal: getResultWidth()),
                      indicatorSize: TabBarIndicatorSize.label,
                      indicatorColor: Color(0xff73CE3C),
                      unselectedLabelColor: Colors.grey,
                      labelColor: Color(0xff73CE3C),
                      isScrollable: true,
                      tabs: getTabBars())),
            ),
            actions: <Widget>[
              IconButton(
                  icon: Image.asset(
                    "assets/images/notice.png",
                    width: 25,
                  ),
                  onPressed: () {
                    Application.router.navigateTo(
                      context,
                      "${Routes.noticeListPage}",
                      transition: TransitionType.fadeIn,
                    );
                  })
            ]),
        body: new TabBarView(
          children: lists.map((ProductType productType) {
            return new Padding(
              padding: const EdgeInsets.all(1.0),
              child: new ChoiceCard(productType: productType),
            );
          }).toList(),
        ),
      ),
    );
  }

  double getWidth() {
    int count = 0;
    for (int i = 0; i < lists.length; i++) {
      count += (lists[i].typeName).length;
    }
    //18  是字体大小
    return (width - 18 * count) / (lists.length * 2);
  }

  double getResultWidth() {
    if (lists.length == 1) {
      return (width - 18 * 2) / 2;
    } else if (lists.length < 4) {
      return getWidth();
    } else {
      return 15;
    }
  }

  List<Widget> getTabBars() {
    List<Tab> listTab = [];
    for (int i = 0; i < lists.length; i++) {
      Tab tab = new Tab(text: lists[i].typeName);
      listTab.add(tab);
    }
    return listTab;
  }
}

class ChoiceCard extends StatelessWidget {
  const ChoiceCard({Key key, this.productType}) : super(key: key);

  final ProductType productType;

  @override
  Widget build(BuildContext context) {
    return new Card(
      color: Colors.white,
      child: new Center(
        child: GoodListPage(type: productType.id),
      ),
    );
  }
}
