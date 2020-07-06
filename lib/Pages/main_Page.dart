import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:xingwang_project/Pages/good_list_shooping_cart.dart';

import 'package:xingwang_project/Pages/index.dart';
import 'package:xingwang_project/Pages/market.dart';
import 'package:xingwang_project/Pages/me.dart';

class MainPage extends StatefulWidget {
  //static BuildContext context;

  @override
  MainPageState createState() {
    return MainPageState();
  }
}

class MainPageState extends State<MainPage> {
  static MainPageState instance;

  DateTime lastPopTime;
  int currentIndex = 0;



  @override
  void initState() {
    instance = this;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //MainPage.context = context;
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        selectedFontSize: 14,
        unselectedFontSize: 14,
        type: BottomNavigationBarType.fixed,
        items: [
          createItem("index", "首页"),
          createItem("market", "购物车"),
          createItem("me", "我的"),
        ],
        onTap: (index) {
          setState(() {
            currentIndex = index;
            if (index == 1) {
              GoodListShoppingCartState.instance.refresh();
            }
          });
        },
      ),
      body: WillPopScope(//返回键
          child: IndexedStack(
            index: currentIndex,
            children: <Widget>[Index(), Market(), Me()],
          ),
          onWillPop: _onWillPop),
    );
  }

  void refresh(int index) {
    setState(() {
      currentIndex = index;
      if (index == 1) {
        GoodListShoppingCartState.instance.refresh();
      }
    });
  }

  Future<bool> _onWillPop() {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('退出程序?'),
            content: new Text('你确定要退出兴望吗？'),
            actions: <Widget>[
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('取消'),
              ),
              new FlatButton(
                onPressed: () async {
                  await SystemChannels.platform
                      .invokeMethod('SystemNavigator.pop');
                  return Navigator.of(context).pop(true);
                },
                child: new Text('确认'),
              ),
            ],
          ),
        ) ??
        false;
  }
}

BottomNavigationBarItem createItem(String iconName, String title) {
  return BottomNavigationBarItem(
      activeIcon: Image.asset(
        "assets/images/$iconName.png",
        width: 30,
      ),
      icon: Image.asset(
        "assets/images/${iconName}off.png",
        width: 30,
      ),
      title: Text(title));
}



