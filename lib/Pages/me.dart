import 'package:connectivity/connectivity.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xingwang_project/Pages/createOrder_page.dart';
import 'package:xingwang_project/Utils/application.dart';
import 'package:xingwang_project/api/api.dart';
import 'package:xingwang_project/components/myCircleAvator.dart';
import 'package:xingwang_project/routers/application.dart';
import 'package:xingwang_project/routers/routes.dart';

class Me extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MeState();
  }
}

class MeState extends State<Me> {
  TextStyle style = TextStyle(fontSize: 20, color: Colors.grey);

  String headImg = "";
  String name = '';


  @override
  void initState() {

    headImg = API.userModel.headImg;
    name = API.userModel.corporateName;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,

        backgroundColor: ApplicationUtils.appBarColor,
        title: Text("个人信息", style: TextStyle(fontSize: 25)),
        centerTitle: true,
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
            },
          )
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(10),
        children: <Widget>[
          CircleHeadImg(
            imagePath: headImg,
            tittle: name ,
            function: () {
              Application.router
                  .navigateTo(
                context,
                "${Routes.statusChange}",
                transition: TransitionType.fadeIn,
              ).then((_) {
                setState(() {
                  headImg = API.userModel.headImg;
                });
              });
            },
          ),
          MyListTile(
            imagePath: "assets/images/stock.png",
            tittle: "我的库存",
            function: () {
              Application.router.navigateTo(
                context,
                "${Routes.myStockList}",
                transition: TransitionType.fadeIn,
              );
            },
          ),
          MyListTile(
            imagePath: "assets/images/mydingdan.png",
            tittle: "我的订单",
            function: () {
              Application.router.navigateTo(
                context,
                "${Routes.myOrder}",
                transition: TransitionType.fadeIn,
              );
            },
          ),
          MyListTile(
            imagePath: "assets/images/maijiadingdan.png",
            tittle: "买家订单",
            function: () {
              Application.router.navigateTo(
                context,
                "${Routes.buyerOrder}",
                transition: TransitionType.fadeIn,
              );
            },
          ),
          MyListTile(
            imagePath: "assets/images/adress.png",
            tittle: "地址管理",
            function: () {
              String isCanPop = "false";
              String route = '${Routes.addressManager}?isCanPop=$isCanPop';
              Application.router.navigateTo(
                context,
                route,
                transition: TransitionType.fadeIn,
              );
            },
          ),
          MyListTile(
            imagePath: "assets/images/receipt.png",
            tittle: "发票抬头",
            function: () {
              String route = '${Routes.receiptManagerPage}';
              Application.router.navigateTo(
                context,
                route,
                transition: TransitionType.fadeIn,
              );
            },
          ),

          MyListTile(
            imagePath: "assets/images/zhuxiao.png",
            tittle: "注销登录",
            function: () async {
              SharedPreferences prefs =
              await SharedPreferences.getInstance();
              prefs.setBool('isLogin', false);
              Application.router.navigateTo(
                  context, "${Routes.loginPage}",
                  transition: TransitionType.fadeIn,clearStack: true);

            },
          ),
        ],
      ),
    );
  }
}
