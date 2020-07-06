import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:xingwang_project/Pages/createOrder_page.dart';
import 'package:xingwang_project/Pages/good_list_shooping_cart.dart';
import 'package:xingwang_project/Pages/main_Page.dart';
import 'package:xingwang_project/Utils/application.dart';
import 'package:xingwang_project/api/api.dart';
import 'package:xingwang_project/components/myBanYuanButton.dart';
import 'package:xingwang_project/components/myCheckBox.dart';

class Market extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MarketState();
  }
}

class MarketState extends State<Market> {
  String actions = "管理";
  bool isDelete = false;
  String finish = "结算";
  final GlobalKey<GoodListShoppingCartState> key =
      GlobalKey<GoodListShoppingCartState>();

  @override
  void initState() {
    super.initState();
  }

  final GlobalKey<RoundCheckBoxState> roundCheckBoxStateKey =
      GlobalKey<RoundCheckBoxState>();

  @override
  Widget build(BuildContext context) {

    //单例模式
    if (goodListShoppingCart == null) {
      goodListShoppingCart = GoodListShoppingCart(
        key: this.key,
        parentCallBack: changeSumAmount,
        parentAllSelectStatus: changeAllSelectValue,
      );
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,

        backgroundColor: ApplicationUtils.appBarColor,
        title: Text(
          "购物车",
          style: TextStyle(fontSize: 25),
        ),
        centerTitle: true,
        actions: <Widget>[
          FlatButton(
              child: Text(
                actions,
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
              onPressed: () {
                isDelete = !isDelete;
                if (isDelete) {
                  setState(() {
                    actions = "完成";
                  });
                } else {
                  setState(() {
                    actions = "管理";
                  });
                }
              }),
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(child: goodListShoppingCart),
          Container(
            color: Colors.grey[200],
            height: 40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    RoundCheckBox(
                        key: roundCheckBoxStateKey,
                        value: false,
                        onChanged: (allSelectValue) {
                          key.currentState.changeAllStatus(allSelectValue);
                          changeSumAmount(key.currentState.sumAmount());
                        }),
                    Text(
                      "全选",
                      style: TextStyle(fontSize: 15),
                    ),
                  ],
                ),
                Text(
                  isDelete ? "" : "合计：￥$sumAmount",
                  style: TextStyle(color: Colors.red, fontSize: 15),
                ),
                MyBanYuanButton(
                  string: isDelete ? "删除" : "结算",
                  width: 60,
                  height: 30,
                  fontSize: 15,
                  function: () {
                    if (isDelete) {
                      key.currentState.deleteShoppingCar();
                    } else {
                      if (key.currentState.selectPayShoppingCar().length >
                          0) {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                              return CreateOrder(
                                  list: key.currentState.selectPayShoppingCar(),);
                            })).then((value) {
                          sumAmount = 0;
                        });
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  GoodListShoppingCart goodListShoppingCart;
  //全选结果改变
  void changeAllSelectValue(bool value) {
    roundCheckBoxStateKey.currentState.changeStatus(value);
  }

  //计算总额
  double sumAmount = 0;
  void changeSumAmount(double sumAmount) {
    this.setState(() {
      this.sumAmount = sumAmount;
    });
  }
}
