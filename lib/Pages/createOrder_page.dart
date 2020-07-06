import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fluwx_pay_only/fluwx_pay_only.dart' as fluwx;
import 'package:xingwang_project/Model/addressModelList.dart';
import 'package:xingwang_project/Model/orderProductVo.dart';
import 'package:xingwang_project/Model/receiptModel.dart';
import 'package:xingwang_project/Model/shoppingCarModel.dart';
import 'package:xingwang_project/Model/weChatPay.dart';
import 'package:xingwang_project/Utils/application.dart';
import 'package:xingwang_project/api/api.dart';
import 'package:xingwang_project/components/huxingButton.dart';
import 'package:xingwang_project/components/myBanYuanButton.dart';
import 'package:xingwang_project/components/myCheckBox.dart';
import 'package:xingwang_project/components/myRadioListTile.dart';
import 'package:xingwang_project/routers/application.dart';
import 'package:xingwang_project/routers/routes.dart';

class CreateOrder extends StatefulWidget {

  final List<ShoppingCarModel> list;


  const CreateOrder({Key key, this.list}) : super(key: key);


  @override
  State<StatefulWidget> createState() {
    return CreateOrderState();
  }
}

class CreateOrderState extends State<CreateOrder> {

  List<ShoppingCarModel> list = [];
  AddressModel addressModel;

  @override
  void initState() {
    list = widget.list;
    print(list.length);
    getDefaultAddress();
    initFluwx();
    super.initState();
  }

  Future getDefaultAddress() async {
    API.getDefaultAddress().then((value) {
      setState(() {
        addressModel = value;
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('填写订单', style: TextStyle(fontSize: 25),),
        centerTitle: true,
        backgroundColor: ApplicationUtils.appBarColor,
      ),
      backgroundColor: Colors.grey[200],
      body: ListView(
        children: <Widget>[
          addressItem(),
          SizedBox(height: 10,),
          getListWidget(),
          SizedBox(height: 5,),
          remark(),
          SizedBox(height: 5,),
          createReceiptContainer(),
          SizedBox(height: 5,),
          submitOrder(),
          //typeWidget(),
        ],

      ),
    );
  }

  static String nickName = "";
  static String phone = "";
  static String address = "";
  String id = "";

  Widget addressItem() {
    TextStyle style = TextStyle(fontSize: 20, color: Colors.grey[600]);
    return InkWell(
      onTap: () async {
        String isCanPop = "true";
        String route = '${Routes.addressManager}?isCanPop=$isCanPop';
        Application.router.navigateTo(
            context, route, transition: TransitionType.fadeIn).then((value) {
//          setState(() {
//            if (value != null) {
          addressModel = value;
//            }
//          });
        });
//        final result = await Application.router.navigateTo(
//            context, route, transition: TransitionType.fadeIn);
//        addressModel=result;
      },
      child: addressModel != null ? Container(
        color: Colors.white,
        padding: EdgeInsets.all(10),
        child: Row(
          children: <Widget>[
            Expanded(child:
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(addressModel.nickName, style: style,),
                    SizedBox(width: 30,),
                    Text(addressModel.phone, style: style,),

                  ],
                ),
                Text("${addressModel.provinceName}${addressModel
                    .cityName}${addressModel.districtName ?? ""}${addressModel
                    .address}", style: style,),
              ],
            )),
            Icon(Icons.keyboard_arrow_right),
          ],
        ),
      ) : new Container(width: MediaQuery
          .of(context)
          .size
          .width,
          height: 50,
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('请选择收货地址', style: style,),
              Icon(Icons.keyboard_arrow_right),
            ],
          )),
    );
  }

  TextEditingController remarkController = new TextEditingController();

  //备注
  Widget remark() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(5),
      child: TextField(
        controller: remarkController,
        enableInteractiveSelection: false,
        decoration: InputDecoration(hintText: "备注"),
        maxLines: 3,
        maxLength: 60,),
    );
  }

  //提交订单
  Widget submitOrder() {
    return Container(
      padding: EdgeInsets.all(5),
      height: 50,
      color: Colors.white,
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text("合计￥${sumAmount()}",
            style: TextStyle(fontSize: 20, color: Colors.red),),
          MyBanYuanButton(
            fontSize: 18,
            string: "提交订单",
            width: 80,
            height: 30,
            function: () {
              createOrder();
            },)
        ],),
    );
  }


  //商品列表项
  Widget _listWidget(ShoppingCarModel shoppingCarModel) {
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
            _goodsImage(shoppingCarModel),
            SizedBox(
              width: 10,
            ),
            //右侧使用垂直布局
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _goodsName(shoppingCarModel),
                  _goodsFunction(shoppingCarModel),
                  _goodsNorms(shoppingCarModel),
                  _goodsPrice(shoppingCarModel),
                  _getThreeWidget(shoppingCarModel),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


  //商品图片
  Widget _goodsImage(ShoppingCarModel shoppingCarModel) {
    return Container(
      width: 100,
      height: 100,
      child: Image.network(shoppingCarModel.picId, fit: BoxFit.fitWidth,),
    );
  }

  //商品名称
  Widget _goodsName(ShoppingCarModel shoppingCarModel) {
    return Container(
      //width: 150,
      child: Text(
        shoppingCarModel.proName,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: ApplicationUtils.goodListNameTextStyle,
      ),
    );
  }

  //商品功效
  Widget _goodsFunction(ShoppingCarModel shoppingCarModel,) {
    return Container(
      //width: 150,
      child: Text(
        "品牌：${shoppingCarModel.brand ?? ""}",
        overflow: TextOverflow.ellipsis,
        style: ApplicationUtils.modelStyle,

      ),
    );
  }

  //商品属性
  Widget _goodsNorms(ShoppingCarModel shoppingCarModel,) {
    return Container(
      child: Text(
        "包装规格：${shoppingCarModel.norms ?? ""}/${shoppingCarModel.unit ?? ""}",


        style: ApplicationUtils.modelStyle,
      ),
    );
  }

  //商品价格
  Widget _goodsPrice(ShoppingCarModel shoppingCarModel,) {
    return Container(
      width: 150,
      child: Row(
        children: <Widget>[
          Text(
            '价格:￥${shoppingCarModel.price}',
            style: TextStyle(color: Colors.red),
          ),
        ],
      ),
    );
  }

  //加号按钮
  Widget _getAddButton(ShoppingCarModel shoppingCarModel) {
    return GestureDetector(
      child: Container(
          width: 25,
          height: 25,
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.grey),),
          child: Text("+", style: TextStyle(fontSize: 20),),
          alignment: Alignment.center
      ),
      onTap: () {
        setState(() {
          shoppingCarModel.proNumber++;
        });
      },
    );
  }

//减号按钮
  Widget _getDecreaseButton(ShoppingCarModel shoppingCarModel) {
    return GestureDetector(
      child: Container(
          width: 25,
          height: 25,
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.grey),),
          child: Text("-", style: TextStyle(fontSize: 20),),
          alignment: Alignment.center
      ),
      onTap: () {
        setState(() {
          if (shoppingCarModel.proNumber >= 2) {
            shoppingCarModel.proNumber--;
          }
        });
      },
    );
  }

  //商品个数
  Widget _getGoodCount(ShoppingCarModel shoppingCarModel) {
    return GestureDetector(
      child: Container(
          width: 50,
          height: 25,
          decoration: BoxDecoration(
            border: Border(top: BorderSide(color: Colors.grey),
                bottom: BorderSide(color: Colors.grey)),),
          child: Text("${shoppingCarModel.proNumber}", style: TextStyle(
              fontSize: 20, color: ApplicationUtils.appBarColor),),
          alignment: Alignment.center
      ),
      onTap: () {
        showAlertDialog(context, shoppingCarModel);
      },
    );
  }

  //底部三个小控件
  Widget _getThreeWidget(ShoppingCarModel shoppingCarModel) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        _getDecreaseButton(shoppingCarModel),
        _getGoodCount(shoppingCarModel),
        _getAddButton(shoppingCarModel),
        SizedBox(width: 5,),
      ],
    );
  }

  void showAlertDialog(BuildContext context,
      ShoppingCarModel shoppingCarModel) {
    var countController = TextEditingController();
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            content: TextField(
              decoration: InputDecoration(hintText: "请输入个数",),
              enableInteractiveSelection: false,
              controller: countController,
              keyboardType: TextInputType.numberWithOptions(),
              inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],),
            title: Center(
                child: Text(
                  '填写个数',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold),
                )),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    setState(() {
                      shoppingCarModel.proNumber =
                          int.parse(countController.text);
                      if (shoppingCarModel.proNumber <= 1) {
                        shoppingCarModel.proNumber = 1;
                      }
                    });
                    Navigator.of(context).pop();
                  },
                  child: Text('确定')),
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('取消')),
            ],
          );
        });
  }

  double sumAmount() {
    double amount = 0;
    for (int i = 0; i < list.length; i++) {
      ShoppingCarModel shoppingCarModel = list[i];
      amount += shoppingCarModel.price * shoppingCarModel.proNumber;
    }
    return double.parse(amount.toStringAsFixed(2));
  }

  Widget getListWidget() {
    List<Widget> listWidget = [];
    for (int i = 0; i < list.length; i++) {
      ShoppingCarModel shoppingCarModel = list[i];
      //列表项 传入列表数据及索引
      listWidget.add(_listWidget(shoppingCarModel));
    }
    return Column(
      children: listWidget,
    );
  }

  void createOrder() {
    List<OrderProductVo> orderProductVoList = [];
    for (int i = 0; i < list.length; i++) {
      OrderProductVo orderProductVo = new OrderProductVo(
          list[i].productId, list[i].proNumber);
      orderProductVoList.add(orderProductVo);
    }
    ApplicationUtils.showLoading(context, time: 3);

    API.createOrder(
        remarkController.text, addressModel.id, orderProductVoList,
        receiptModel?.id ?? "").then((value) {
      if (value["data"]) {
        WeChatPay weChatPay = value["msg"];
        weChatPayFunction(weChatPay, context);
      } else {
        Fluttertoast.showToast(msg: value["msg"]);
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
        Future.delayed(Duration(seconds: 1), () {});
      }
    });
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
      print(result);
      if (result == 0) {
        deleteShoppingCarByPay();
        Navigator.pop(context);
        Application.router.navigateTo(context, "${Routes.myOrder}",
            transition: TransitionType.fadeIn);
        Fluttertoast.showToast(msg: "支付成功");
      } else if (result == -1) {
        Navigator.pop(context);
        Application.router.navigateTo(context, "${Routes.myOrder}",
            transition: TransitionType.fadeIn);
        Fluttertoast.showToast(msg: "支付失败");
      } else if (result == -2) {
        Navigator.pop(context);
        Application.router.navigateTo(context, "${Routes.myOrder}",
            transition: TransitionType.fadeIn);
        Fluttertoast.showToast(msg: "用户取消");
      }
    });
  }


  void deleteShoppingCarByPay() {
    for (int i = 0; i < list.length; i++) {
      print("调用删除方法");
      API.deleteShoppingCar(list[i].id);
    }
  }

  Widget createReceiptContainer() {
    return InkWell(
        onTap: () {
          _modalBottomSheetMenu();
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
                    Text(receiptModel?.name ?? "",
                        style: TextStyle(fontSize: 20, color: Colors.grey)),
                    new Icon(Icons.keyboard_arrow_right),
                  ],
                ),
              )
            ],),
        )
    );
  }


  bool isFirst = true;

  void _modalBottomSheetMenu() {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          BuildContext buildContext = builder;
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter state) {
              if (isFirst) {
                getReceiptList(state);
                isFirst = false;
              }

              return new Container(

                height: 300.0,
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
                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text("发票", style: TextStyle(fontSize: 20),),
                            ],),
                          typeWidget(state),
                          listViewWidget(state),

                        ],
                      ),

                    )),

              );
            },);
        }

    );
  }


  ReceiptModel receiptModel = new ReceiptModel();

  void getReceiptName(ReceiptModel receiptModel) {
    setState(() {
      this.receiptModel = receiptModel;
    });
  }


  TextStyle style = TextStyle(fontSize: 18, color: Colors.grey);
  bool isPerson = true;
  Color personColor = Colors.red;
  Color companyColor = Colors.grey;

  Widget typeWidget(StateSetter state) {
    return Container(

      height: 50,
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text("发票抬头", style: style,),
          Container(

              child: Row(children: <Widget>[
                RefundStatusWidget(
                  string: "个人",
                  color: personColor,
                  width: 80,
                  height: 30,
                  fontSize: 15,
                  function: () {
                    state(() {
                      getReceiptList(state, billType: "1");

                      isPerson = true;
                      personColor = Colors.red;
                      companyColor = Colors.grey;
                    });
                  },),
                SizedBox(width: 10,),
                RefundStatusWidget(
                  string: "单位",
                  color: companyColor,
                  width: 80,
                  height: 30,
                  fontSize: 15,
                  function: () {
                    state(() {
                      getReceiptList(state, billType: "2");
                      isPerson = false;
                      companyColor = Colors.red;
                      personColor = Colors.grey;
                    });
                  },),

              ],)
          ),
        ],
      ),
    );
  }


  Widget listViewWidget(StateSetter state) {
    if (lists.length == 0) return Container();
    List<Widget> list = [];
    for (int i = 0; i < lists.length; i++) {
      list.add(createItem(lists[i], state));
    }
    return Container(
      height: 200,
      child: ListView(
          children: list
      ),
    );
  }

  String _newValue;

  Widget createItem(ReceiptModel receiptModel, StateSetter state) {



    MyRadioListTile myRadioListTile=  MyRadioListTile<String>(
      value: receiptModel.name,

      title: Text(receiptModel.name, style: style,),
      groupValue: _newValue,
      onChanged: (value) {
        state(() {
          _newValue = value;

        });
        setState(() {
          this.receiptModel = receiptModel;
        });
      },
      onClick: (){
      _newValue="";
      this.receiptModel=null;
      },
    );
    return myRadioListTile;

  }





  List<ReceiptModel> lists = [];

  Future getReceiptList(StateSetter state, {String billType = "1"}) async {
    API.getBillSetList(billType: billType).then((value) {
      if (value["data"]) {
        state(() {
          lists.clear();
          lists.addAll(value["msg"]);
        });
      }
    });
  }

}
