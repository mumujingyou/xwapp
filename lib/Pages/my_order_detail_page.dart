import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fluwx_pay_only/fluwx_pay_only.dart' as fluwx;
import 'package:xingwang_project/Model/myOrder.dart';
import 'package:xingwang_project/Model/receiptModel.dart';
import 'package:xingwang_project/Model/weChatPay.dart';
import 'package:xingwang_project/Utils/application.dart';
import 'package:xingwang_project/api/api.dart';
import 'package:xingwang_project/components/myBanYuanButton.dart';
import 'package:xingwang_project/components/receiptDetailWidget.dart';

class MyOrderDetailPage extends StatefulWidget {
  final OrderModel myOrderModel;

  const MyOrderDetailPage({Key key, this.myOrderModel}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return MyOrderDetailState();
  }
}

class MyOrderDetailState extends State<MyOrderDetailPage> {
  OrderModel myOrderModel;
  TextStyle style = TextStyle(fontSize: 20, color: Colors.grey[600]);
  ReceiptModel receiptModel;



  @override
  void initState() {
    myOrderModel = widget.myOrderModel;
    _countdownTime=myOrderModel.order.timeRemain~/1000;
    startCountdownTimer();

    initFluwx();
    loadReceipt();
    print("orderstatus  ${myOrderModel.order.orderStatus}");
    super.initState();
  }

  loadReceipt() async {
    print(myOrderModel.order.orderNo);
    API.selectBillApplyByOrderNo(myOrderModel.order.orderNo).then((value) {
      if (value["data"]) {
        setState(() {
          receiptModel = value["msg"];
        });
      }
    });
  }

  Timer _timer;
  int _countdownTime = 0;
  //计时器
  void startCountdownTimer() {
    const oneSec = const Duration(seconds: 1);

    var callback = (timer) => {
    setState(() {
      if (_countdownTime < 1) {
        _timer.cancel();
      } else {
        _countdownTime = _countdownTime - 1;
      }
    })
  };
    _timer = Timer.periodic(oneSec, callback);
  }

















  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '我的订单详情',
          style: TextStyle(fontSize: 25),
        ),
        centerTitle: true,
        backgroundColor: ApplicationUtils.appBarColor,
      ),
      backgroundColor: Colors.grey[200],
      body: ListView(
        children: <Widget>[
          timeWidget(myOrderModel.order),
          addressItem(myOrderModel.order),
          SizedBox(
            height: 5,
          ),
          getListWidget(myOrderModel.orderProductList),
          SizedBox(
            height: 5,
          ),
          myRemarkContainer(myOrderModel.order),
          SizedBox(height: 5,),
          createReceiptContainer(),
          SizedBox(height: 5,),

          bottom(myOrderModel.order),
        ],
      ),
    );
  }

  Widget timeWidget(Order order) {
    if (order.orderStatus == 0) {
      return Container(color: ApplicationUtils.appBarColor, height: 100,
        padding: EdgeInsets.all(8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
            Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("等待买家付款",style: TextStyle(color: Colors.white,fontSize: 25),),
                Text(timeString(_countdownTime),style: TextStyle(color: Colors.white,fontSize: 20),),

              ],
            ),
            Image.asset("assets/images/money.png",scale: 3,),
        ],),
      );
    } else {
      return Container();
    }
  }

  String timeString(int time){
    int hours=time~/3600;
    int seconds=time%3600;
    int minute=seconds~/60;
    return "剩$hours小时$minute分自动关闭";
  }


  Widget addressItem(Order order) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(10),
      child: Row(
        children: <Widget>[
          Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text(
                        order.nickName,
                        style: style,
                      ),
                      SizedBox(
                        width: 30,
                      ),
                      Text(
                        order.phone,
                        style: style,
                      ),
                    ],
                  ),
                  Text(
                    "${order.address}",
                    style: style,
                  ),
                ],
              )),
        ],
      ),
    );
  }

  Widget bottom(Order order) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(5),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          orderStatus(order),
          orderNo(order),
          createTime(order),
          payTime(order),

          bottomWidget(order),
        ],
      ),
    );
  }


  Widget myRemarkContainer(Order order) {
    if (order.remark == null) {
      return Container();
    } else {
      return Container(
        padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
        color: Colors.white,

        child: RichText(
          text: TextSpan(style: TextStyle(fontSize: 18), children: [
            TextSpan(
                text: "备注说明：",
                style: TextStyle(color: Colors.blue, fontSize: 17)),
            TextSpan(
                text: "${order.remark}",
                style: TextStyle(fontSize: 17, color: Colors.grey[600])),
          ]),
          textDirection: TextDirection.ltr,
        ),);
    }
  }


  Widget orderNo(Order order) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          "订单编号",
          style: style,
        ),
        Text(
          order.orderNo,
          style: style,
        ),
      ],
    );
  }

  Widget createTime(Order order) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          "创建时间",
          style: style,
        ),
        Text(
          order.createTime ?? "",
          style: style,
        ),
      ],
    );
  }

  Widget payTime(Order order) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          "支付时间",
          style: style,
        ),
        Text(
          order.payTime ?? "",
          style: style,
        ),
      ],
    );
  }

  String orderStatusStr = "";

  Widget orderStatus(Order order) {
    if (order.orderStatus == 0) {
      orderStatusStr = "待付款";
    } else if (order.orderStatus == 1) {
      orderStatusStr = "待发货";
    } else if (order.orderStatus == 2) {
      orderStatusStr = "待收货";
    } else if (order.orderStatus == 3) {
      orderStatusStr = "交易完成";
    } else if (order.orderStatus == 4) {
      orderStatusStr = "交易关闭";
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          "订单状态",
          style: style,
        ),
        Text(
          orderStatusStr,
          style: TextStyle(fontSize: 20,
              color: (order.orderStatus == 4 || order.orderStatus == 3) ? Colors
                  .blue : Colors.red),
        ),
      ],
    );
  }

  Widget bottomWidget(Order order) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          "总计：￥${order.totalFee}",
          style: TextStyle(fontSize: 20, color: Colors.red),
        ),
        enterButton(order),
      ],
    );
  }

  Widget enterButton(Order order) {
    if (order.orderStatus == 0) {
      return Row(
        children: <Widget>[
          MyBanYuanButton(
              width: 60,
              height: 25,
              string: "取消订单",
              fontSize: 13,
              function: () {
                cancelOrder(order);
              }),
          MyBanYuanButton(
              width: 60,
              height: 25,
              string: "去付款",
              fontSize: 13,
              function: () {
                supplierPayAgain(order);
              }),
        ],
      );
    } else if (order.orderStatus == 1) {
      return Container();
    } else if (order.orderStatus == 2) {
      return Row(
        children: <Widget>[
          MyBanYuanButton(
              width: 60,
              height: 25,
              string: "确认收货",
              fontSize: 13,
              function: () {
                enterReceiveGoods(order);
              }),
          SizedBox(
            width: 5,
          ),
        ],
      );
    } else if (order.orderStatus == 5 || order.orderStatus == 6) {
      return Text("");
    } else {
      return Text("");
    }
  }


  void enterReceiveGoods(Order order) {
    showDialog(
      context: context,
      builder: (context) =>
      new AlertDialog(
        title: new Text('确认收货?'),
        content: new Text('你确定已经收到货物？'),
        actions: <Widget>[
          new FlatButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: new Text('取消'),
          ),
          new FlatButton(
            onPressed: () async {
              Map result = await API.orderReceive(order.id);
              if (result["data"] == true) {
                Fluttertoast.showToast(msg: "收货成功");
                Navigator.pop(context);
                Navigator.of(this.context).pop(false);
                return true;
              } else {
                Fluttertoast.showToast(msg: "收货失败");
                return false;
              }
            },
            child: new Text('确认'),
          ),
        ],
      ),
    );
  }


  void supplierPayAgain(Order order) {
    ApplicationUtils.showLoading(context, time: 1);

    API.supplierPayAgain(order.id).then((value) {
      WeChatPay weChatPay = value;
      //ApplicationUtils.weChatPayFunction(weChatPay, context, isCanPop: false);
      weChatPayFunction(weChatPay, context);
    });
  }

  void cancelOrder(Order order) {
    ApplicationUtils.showLoadingBool(context, () async {
      Map restult = await API.cancelOrder(order.id);
      if (restult["data"] == true) {
        Navigator.pop(context);
        Fluttertoast.showToast(msg: restult["msg"]);
        return true;
      } else {
        Fluttertoast.showToast(msg: restult["msg"]);

        return false;
      }
    });
  }

  //商品列表项
  Widget _listWidget(OrderProduct orderProduct) {
    return InkWell(
      onTap: () {
        //Application.router.navigateTo(MainPage.context, "${Routes.goodDetailPage}",transition:TransitionType.fadeIn,);
      },
      child: Container(
        padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              bottom: BorderSide(width: 1.0, color: Colors.black12),
            )),
        //水平方向布局
        child: Row(
          children: <Widget>[
            //返回商品图片
            _goodsImage(orderProduct),
            SizedBox(
              width: 10,
            ),
            //右侧使用垂直布局
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _goodsName(orderProduct),
                _goodsFunction(orderProduct),
                _goodsNorms(orderProduct),
                _sumAmount(orderProduct),
              ],
            )
          ],
        ),
      ),
    );
  }

  //商品图片
  Widget _goodsImage(OrderProduct orderProduct) {
    return Container(
      width: 100,
      height: 100,
      child: Image.network(
        orderProduct.picId,
        fit: BoxFit.fitWidth,
      ),
    );
  }

  //商品名称
  Widget _goodsName(OrderProduct orderProduct) {
    return Container(
      //width: 150,
      child: Text(
        orderProduct.proName,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: ApplicationUtils.goodListNameTextStyle,
      ),
    );
  }

  //商品功效
  Widget _goodsFunction(OrderProduct orderProduct,) {
    return Container(
      //width: 150,
      child: Text(
        "品牌：${orderProduct.brand ?? ""}",
        overflow: TextOverflow.ellipsis,
        style: ApplicationUtils.modelStyle,
      ),
    );
  }

  //商品属性
  Widget _goodsNorms(OrderProduct orderProduct,) {
    return Container(
      //width: 150,
      child: Text(
        "包装规格：${orderProduct.norms ?? ""}/${orderProduct.unit ?? ""}",

        style: ApplicationUtils.modelStyle,
      ),
    );
  }

  //商品价格
  Widget _sumAmount(OrderProduct orderProduct,) {
    return Container(
      width: 150,
      child: Row(
        children: <Widget>[
          Text(
            '￥${orderProduct.price}x${orderProduct.proNumber}',
            style: TextStyle(color: Colors.red),
          ),
        ],
      ),
    );
  }

  Widget getListWidget(List<OrderProduct> list) {
    List<Widget> listWidget = [];
    for (int i = 0; i < list.length; i++) {
      OrderProduct orderProduct = list[i];
      //列表项 传入列表数据及索引
      listWidget.add(_listWidget(orderProduct));
    }
    return Column(
      children: listWidget,
    );
  }


  //初始化微信支付
  void initFluwx() async {
    await fluwx.registerWxApi(
      appId: "wx3bd501bac71972f0",
      doOnAndroid: true,
      doOnIOS: true,
    );
    var result = await fluwx.isWeChatInstalled();
    listenWeChat();
    print("is installed $result");
  }


  int result = 10;

  void listenWeChat() {
    // 监听支付结果
    fluwx.responseFromPayment.listen((data) {
      result = data.errCode;
      print("$result  ===============");
      if (result == 0) {
        Navigator.pop(context);
        Fluttertoast.showToast(msg: "支付成功");
      } else if (result == -1) {
        Navigator.pop(context);
        Fluttertoast.showToast(msg: "支付失败");
      } else if (result == -2) {
        Navigator.pop(context);
        Fluttertoast.showToast(msg: "用户取消");
      }
    });
  }

  //微信支付
  void weChatPayFunction(WeChatPay weChatPay, BuildContext context,
      {bool isCanPop = true}) {
    //isCanPop  是否需要跳转
    fluwx.pay(
      appId: weChatPay.appid,
      partnerId: weChatPay.partnerid,
      prepayId: weChatPay.prepayid,
      packageValue: weChatPay.packages,
      nonceStr: weChatPay.noncestr,
      timeStamp: int.parse(weChatPay.timestamp),
      sign: weChatPay.sign,
    ).then((data) {
      print("---》$data");
      if (data["result"] == true) {

      }
    });
  }

  Widget createReceiptContainer() {
    return InkWell(
        onTap: () {
          if (receiptModel?.name != null) {
            _modalBottomSheetMenu();
          }
        },
        child: Container(
          padding: EdgeInsets.all(10),
          color: Colors.white,
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text("发票", style: TextStyle(fontSize: 20, color: Colors.grey),),
              Container(
                child: Row(
                  children: <Widget>[
                    Text(receiptModel?.name == null ? "" : receiptModel.name,
                        style: TextStyle(fontSize: 20, color: Colors.grey)),
                    new Icon(Icons.keyboard_arrow_right),
                  ],
                ),
              )
            ],),
        )
    );
  }


  void _modalBottomSheetMenu() {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return new Container(
            height: 350.0,
            color: Colors.black54,

            child: new Container(

                decoration: new BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(20.0),
                        topRight: const Radius.circular(20.0))),
                child: new Container(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: <Widget>[
                      receiptModel == null ? Container() : ReceiptDetailWidget(
                        receiptModel: receiptModel,),
                    ],
                  ),
                )),
          );
        }

    );
  }


}
