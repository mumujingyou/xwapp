import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:xingwang_project/Model/shoppingCarModel.dart';
import 'package:xingwang_project/Utils/application.dart';
import 'package:xingwang_project/api/api.dart';
import 'package:xingwang_project/components/myCheckBox.dart';

//商品列表页面  购物车
class GoodListShoppingCart extends StatefulWidget {
  GoodListShoppingCartState createState() => GoodListShoppingCartState();

  GoodListShoppingCart(
      {Key key, this.parentCallBack, this.parentAllSelectStatus})
      : super(key: key);

  final Function(double) parentCallBack;
  final Function(bool) parentAllSelectStatus;
}

class GoodListShoppingCartState extends State<GoodListShoppingCart> {
  static GoodListShoppingCartState instance;

  //初始化数据模型
  List<ShoppingCarModel> list = [];

  //滚动控制
  var scrollController = ScrollController();

  List<RoundCheckBox> roundCheckBoxList = [];
  List<GlobalKey<RoundCheckBoxState>> keyList = [];

  bool isEmpty = false;

  @override
  void initState() {
    instance = this;

    Future.delayed(Duration(seconds: 5), () {
      if (list?.length == 0) {
        setState(() {
          isEmpty = true;
        });
      }
    });
    super.initState();
    getShoppingCarList();
  }

  void refresh() {
    getShoppingCarList();
  }

  //获取商品数据
  void getShoppingCarList() async {
    API.getShoppingCarList().then((value) {
      setState(() {
        list.clear();
        list = value;
        if (list?.length > 0) {} else {
          isEmpty = true;
        }
        //widget.parentCallBack(sumAmount());
      });
    });
  }

  //商品列表项
  Widget _listWidget(ShoppingCarModel shoppingCarModel, int index) {
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
            _goodStatus(shoppingCarModel, index),
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


  //商品状态
  Widget _goodStatus(ShoppingCarModel shoppingCarModel, int index) {
    final GlobalKey<RoundCheckBoxState> key = GlobalKey<RoundCheckBoxState>();

    RoundCheckBox roundCheckBox = RoundCheckBox(
        key: key,
        value: false,
        onChanged: (value) {
          shoppingCarModel.status = value;
          widget.parentCallBack(sumAmount());
          widget.parentAllSelectStatus(isAllSelect());
        });
    roundCheckBoxList.add(roundCheckBox);
    keyList.add(key);

    return roundCheckBox;
  }

  //商品图片
  Widget _goodsImage(ShoppingCarModel shoppingCarModel) {
    return Container(
      width: 100,
      height: 100,
      child: Image.network(
        shoppingCarModel.picId,
        fit: BoxFit.fitWidth,
      ),
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
          style: ApplicationUtils.modelStyle
      ),
    );
  }

  //商品属性
  Widget _goodsNorms(ShoppingCarModel shoppingCarModel,) {
    return Container(
      //width: 150,
      child: Text(
          "包装规格：${shoppingCarModel.norms ?? ""}/${shoppingCarModel.unit ?? ""}",

          style: ApplicationUtils.modelStyle
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
            border: Border.all(width: 1, color: Colors.grey),
          ),
          child: Text(
            "+",
            style: TextStyle(fontSize: 20),
          ),
          alignment: Alignment.center),
      onTap: () {
        API.addShoppingCarOneCount(shoppingCarModel.productId).then((value) {
          if (value["data"]) {
            setState(() {
              shoppingCarModel.proNumber++;
              widget.parentCallBack(sumAmount());
            });
          }
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
            border: Border.all(width: 1, color: Colors.grey),
          ),
          child: Text(
            "-",
            style: TextStyle(fontSize: 20),
          ),
          alignment: Alignment.center),
      onTap: () {
        API
            .decreaseShoppingCarOneCount(shoppingCarModel.productId)
            .then((value) {
          if (value["data"]) {
            setState(() {
              shoppingCarModel.proNumber--;
              if (shoppingCarModel.proNumber <= 1) {
                shoppingCarModel.proNumber = 1;
              }
              //widget.parentCallBack(sumAmount());
            });
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
            border: Border(
                top: BorderSide(color: Colors.grey),
                bottom: BorderSide(color: Colors.grey)),
          ),
          child: Text(
            "${shoppingCarModel.proNumber}",
            style: TextStyle(fontSize: 20, color: ApplicationUtils.appBarColor),
          ),
          alignment: Alignment.center),
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
        SizedBox(
          width: 5,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    print(111);
    //重新初始化
    roundCheckBoxList.clear();
    keyList.clear();
    //通过商品列表数组长度判断是否有数据
    if (list?.length > 0) {
      return ListView.builder(
        //滚动控制器
        controller: scrollController,
        //列表长度
        itemCount: list?.length,
        //列表项构造器
        itemBuilder: (context, index) {
          ShoppingCarModel shoppingCarModel = list[index];
          //列表项 传入列表数据及索引
          return _listWidget(shoppingCarModel, index);
        },
      );
    }
    //商品列表没有数据时返回空容器
    return new Center(
      child: isEmpty ? new Text("购物车空空如也") : new CircularProgressIndicator(),
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
              enableInteractiveSelection: false,
              decoration: InputDecoration(
                hintText: "请输入个数",
              ),
              controller: countController,
              keyboardType: TextInputType.numberWithOptions(),
              inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
            ),
            title: Center(
                child: Text(
                  '填写个数',
                  style: TextStyle(
                    //color: Colors.black,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold),
                )),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    API
                        .editShoppingCarCount(shoppingCarModel.productId,
                        int.parse(countController.text))
                        .then((value) {
                      if (value["data"]) {
                        setState(() {
                          int count = int.parse(countController.text);
                          shoppingCarModel.proNumber = count;
                          //widget.parentCallBack(sumAmount());
                        });
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

  //全选
  void changeAllStatus(bool value) {
    for (int i = 0; i < roundCheckBoxList?.length; i++) {
      keyList[i].currentState.changeStatus(value);
      list[i].status = value;
    }
  }

  //判断是否全选
  bool isAllSelect() {
    _selectChangeStatus();
    for (int i = 0; i < list?.length; i++) {
      if (list[i].status == false) {
        return false;
      }
    }
    return true;
  }

  //选择选中的状态
  void _selectChangeStatus() {
    for (int i = 0; i < keyList.length; i++) {
      GlobalKey<RoundCheckBoxState> key = keyList[i];
      if (key.currentState.value) {
        list[i].status = true;
      } else {
        list[i].status = false;
      }
    }
  }

  //选择结算的商品
  List<ShoppingCarModel> selectPayShoppingCar() {
    _selectChangeStatus();
    List<ShoppingCarModel> resultList = [];
    for (int i = 0; i < list.length; i++) {
      ShoppingCarModel shoppingCarModel = list[i];
      if (shoppingCarModel.status) {
        resultList.add(shoppingCarModel);
      }
    }
    return resultList;
  }


  void deleteShoppingCar() {
    if (list.length <= 0) return;
    ApplicationUtils.showLoading(context, time: 1);
    _selectChangeStatus();
    for (int i = 0; i < list.length; i++) {
      ShoppingCarModel shoppingCarModel = list[i];
      if (shoppingCarModel.status) {
        _deleteOneShoppingCar(shoppingCarModel.id);
      }
    }
    Fluttertoast.showToast(msg: "删除成功");
  }


  void _deleteOneShoppingCar(String id) {
    API.deleteShoppingCar(id).then((value) {
      if (value["data"] == true) {
        //刷新界面
        getShoppingCarList();
      }
    });
  }

  double sumAmount() {
    double amount = 0;
    for (int i = 0; i < list.length; i++) {
      ShoppingCarModel shoppingCarModel = list[i];
      if (shoppingCarModel.status) {
        amount += shoppingCarModel.price * shoppingCarModel.proNumber;
      }
    }
    return double.parse(amount.toStringAsFixed(2));
  }
}
