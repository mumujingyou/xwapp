import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:xingwang_project/Model/myOrder.dart';
import 'package:xingwang_project/Model/receiptModel.dart';
import 'package:xingwang_project/Utils/application.dart';
import 'package:xingwang_project/api/api.dart';
import 'package:xingwang_project/components/myBanYuanButton.dart';
import 'package:xingwang_project/components/receiptDetailWidget.dart';

class BuyerOrderDetailPage extends StatefulWidget {
  final OrderModel orderModel;

  const BuyerOrderDetailPage({Key key, this.orderModel}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return MyOrderDetailState();
  }
}

class MyOrderDetailState extends State<BuyerOrderDetailPage> {
  OrderModel orderModel;
  TextStyle style = TextStyle(fontSize: 20, color: Colors.grey[600]);
  ReceiptModel receiptModel;

  @override
  void initState() {
    orderModel = widget.orderModel;
    loadReceipt();
    super.initState();
  }

  loadReceipt() async {
    print(orderModel.order.orderNo);
    API.selectBillApplyByOrderNo(orderModel.order.orderNo).then((value) {
      if (value["data"]) {
        setState(() {
          receiptModel = value["msg"];
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '买家订单详情',
          style: TextStyle(fontSize: 25),
        ),
        centerTitle: true,
        backgroundColor: ApplicationUtils.appBarColor,
      ),
      backgroundColor: Colors.grey[200],
      body: ListView(
        children: <Widget>[
          addressItem(orderModel.order),
          SizedBox(
            height: 5,
          ),
          getListWidget(orderModel.orderProductList),
          SizedBox(
            height: 5,
          ),
          buyerRemarkContainer(orderModel.order),
          SizedBox(
            height: 5,
          ),
          createReceiptContainer(),

          SizedBox(
            height: 5,
          ),
          bottom(orderModel.order),
        ],
      ),
    );
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
      child: Column(
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


  Widget buyerRemarkContainer(Order order) {
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
    if (order.orderStatus == 1) {
      if (orderModel.order.refundStatus == 0) {//买家发起退款
        print(111111);
//        return Container();
        return Row(
          children: <Widget>[
            MyBanYuanButton(
                width: 60,
                height: 25,
                string: "确认发货",
                fontSize: 13,
                function: () {
                  Fluttertoast.showToast(msg: "该单在退款中，不能发货");

                }),
          ],
        );
      } else if (orderModel.order.refundStatus == 2) {//买家发起退款，但是我拒绝退款
        print(222);

//        return Container();
        return Row(
          children: <Widget>[
            MyBanYuanButton(
                width: 60,
                height: 25,
                string: "确认发货",
                fontSize: 13,
                function: () {
                  Fluttertoast.showToast(msg: "该单在退款中，不能发货");

                }),
          ],
        );
      } else if (orderModel.order.refundStatus == 3) {//买家发起退款，我同意退款，这段时间
        print(333);
        return Row(
          children: <Widget>[
            MyBanYuanButton(
                width: 60,
                height: 25,
                string: "确认发货",
                fontSize: 13,
                function: () {
                  Fluttertoast.showToast(msg: "该单在退款中，不能发货");

                }),
          ],
        );
      } else {//买家刚下单
        print(444);
        return Row(
          children: <Widget>[
            MyBanYuanButton(
                width: 60,
                height: 25,
                string: "确认发货",
                fontSize: 13,
                function: () {
                  ApplicationUtils.showLoadingBool(context, () async {
                    Map reslut = await API.orderSendOut(order.id);
                    if (reslut["data"] == true) {
                      Fluttertoast.showToast(msg: reslut["msg"]);

                      Navigator.pop(context);
                      return true;
                    } else {
                      Fluttertoast.showToast(msg: reslut["msg"]);

                      return false;
                    }
                  });
                }),
          ],
        );
      }
    } else {
      return Container();
    }
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
    print("${orderProduct.picId}  ================");
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
          style: ApplicationUtils.modelStyle
      ),
    );
  }

  //商品属性
  Widget _goodsNorms(OrderProduct orderProduct,) {
    return Container(
      //width: 150,
      child: Text(
          "包装规格：${orderProduct.norms ?? ""}/${orderProduct.unit ?? ""}",

          style: ApplicationUtils.modelStyle
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


  Widget createReceiptContainer() {
    return InkWell(
        onTap: () {
          if(receiptModel?.name != null){
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
