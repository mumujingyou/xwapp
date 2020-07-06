import 'package:flutter/material.dart';
import 'package:xingwang_project/Model/myOrder.dart';
import 'package:xingwang_project/Pages/buyer_order_detail_page.dart';
import 'package:xingwang_project/Pages/check_buyer_fefund_page.dart';
import 'package:xingwang_project/Utils/application.dart';
import 'package:xingwang_project/api/api.dart';
import 'package:xingwang_project/components/huxingButton.dart';

class BuyerOrderPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return BuyerOrderPageState();
  }
}

class BuyerOrderPageState extends State<BuyerOrderPage> {
  List<OrderModel> lists = [];
  TextStyle textStyle = new TextStyle(fontSize: 15, color: Colors.grey[500]);

  int currentPage = -1; //第一页
  int pageSize = 10; //页容量
  int totalSize = 0; //总条数
  String loadMoreText = "没有更多数据";
  TextStyle loadMoreTextStyle =
  new TextStyle(color: const Color(0xFF999999), fontSize: 14.0);
  TextStyle titleStyle =
  new TextStyle(color: const Color(0xFF757575), fontSize: 14.0);

  //初始化滚动监听器，加载更多使用
  ScrollController _controller = new ScrollController();

  BuyerOrderPageState() {
    //固定写法，初始化滚动监听器，加载更多使用
    _controller.addListener(() {
      var maxScroll = _controller.position.maxScrollExtent;
      var pixel = _controller.position.pixels;
      if (maxScroll == pixel && lists.length < totalSize) {
        setState(() {
          loadMoreText = "正在加载中...";
          loadMoreTextStyle =
          new TextStyle(color: const Color(0xFF4483f6), fontSize: 14.0);
        });
        loadMoreData();
      } else {
        setState(() {
          loadMoreText = "没有更多数据";
          loadMoreTextStyle =
          new TextStyle(color: const Color(0xFF999999), fontSize: 14.0);
        });
      }
    });
  }

  bool isEmpty = false;

  //加载列表数据
  loadMoreData() async {
    this.currentPage++;
    int start = currentPage * 10;
    API.getBuyerOrderList(start).then((value) {
      setState(() {
        lists.addAll(value.myOrderModelLists);
        totalSize = value.total;
        if (lists.length == 0) {
          isEmpty = true;
        }
      });
    });
  }

  @override
  void initState() {
    loadMoreData();
    super.initState();
  }

  /**
   * 下拉刷新,必须异步async不然会报错
   */
  Future _pullToRefresh() async {
    currentPage = -1;
    lists.clear();
    loadMoreData();
    return null;
  }

  @override
  void deactivate() {
    var bool = ModalRoute
        .of(context)
        .isCurrent;

    if (bool) {
      _pullToRefresh();
    }
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            '买家订单',
            style: TextStyle(fontSize: 25),
          ),
          centerTitle: true,
          backgroundColor: ApplicationUtils.appBarColor,
        ),
        backgroundColor: Colors.grey[200],
//      body:ListView.builder(itemCount: lists.length,itemBuilder: (context,index){
//          return createItem(lists, index);
//      })

        body: lists.length == 0
            ? new Center(
            child: isEmpty
                ? new Text("亲，还没有人下单呢")
                : new CircularProgressIndicator())
            : new RefreshIndicator(
          color: const Color(0xFF4483f6),
          //下拉刷新
          child: ListView.builder(
            itemCount: lists.length + 1,
            itemBuilder: (context, index) {
              if (index == lists.length) {
                return _buildProgressMoreIndicator();
              } else {
                return createItem(lists, index);
              }
            },
            controller: _controller, //指明控制器加载更多使用
          ),
          onRefresh: _pullToRefresh,
        ));
  }

  /**
   * 加载更多进度条
   */
  Widget _buildProgressMoreIndicator() {
    return new Padding(
      padding: const EdgeInsets.all(15.0),
      child: new Center(
        child: new Text(loadMoreText, style: loadMoreTextStyle),
      ),
    );
  }

  Widget createItem(List<OrderModel> list, int index) {
    OrderModel orderModel = list[index];
    return Column(
      children: <Widget>[
        InkWell(
          onTap: () {
            Navigator.push(context, new MaterialPageRoute(builder: (context) {
              return BuyerOrderDetailPage(
                orderModel: orderModel,
              );
            }));
          },
          child: Container(
            color: Colors.white,
            padding: EdgeInsets.all(5),
            child: Column(
              children: <Widget>[
                createFirstItem(orderModel.order),
                getListWidget(orderModel.orderProductList,orderModel),
                createBottom(orderModel,orderModel.orderProductList.length),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 30,
        )
      ],
    );
  }

  Widget createFirstItem(Order order) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          "订单号：${order.orderNo}",
          style: textStyle,
        ),
        orderStatus(order),
      ],
    );
  }

  Widget createBottom(OrderModel orderModel, int length) {
    return Container(height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          RichText(
            text: TextSpan(style: TextStyle(fontSize: 18), children: [
              TextSpan(
                  text: "共计", style: ApplicationUtils.modelStyle),
              TextSpan(
                  text: "$length", style: TextStyle(color: Colors.red)),
              TextSpan(
                  text: "件商品", style: ApplicationUtils.modelStyle),
            ]),
            textDirection: TextDirection.ltr,
          ),

          Row(
            children: <Widget>[
              RichText(
                text: TextSpan(style: TextStyle(fontSize: 18), children: [
                  TextSpan(text: "合计:", style: ApplicationUtils.modelStyle),
                  TextSpan(text: "￥${orderModel.order.totalFee}",
                      style: TextStyle(color: Colors.red)),

                ]),
                textDirection: TextDirection.ltr,
              ),
              SizedBox(width: 10,),
              checkMore(orderModel, length),
            ],
          ),
        ],
      ),
    );
  }


  //查看更多

  Widget checkMore(OrderModel orderModel, int length) {
    if (length == 1) {
      return Container();
    } else {
      return RefundStatusWidget(string: "查看更多",color:Colors.green ,function: (){
        Navigator.push(context,
            new MaterialPageRoute(builder: (context) {
              return BuyerOrderDetailPage(
                orderModel: orderModel,
              );
            }));
      },);
    }
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
    return Text(
      orderStatusStr,
      style: TextStyle(color: (order.orderStatus == 4||order.orderStatus == 3)?Colors.blue:Colors.red),
    );
  }

  //商品列表项
  Widget _listWidget(OrderProduct orderProduct,OrderModel orderModel) {
    return Container(
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
              _goodsName(orderProduct,),
              _goodsModel(orderProduct),
              _goodsNorms(orderProduct),
            ],
          ),
          Expanded(flex: 1, child: Container(),),
          Container(

            child: Column(children: <Widget>[
              _sumAmount(orderProduct),
              refundWidget(orderModel),

            ],),
          )
        ],
      ),
    );
  }



  Widget refundWidget(OrderModel orderModel) {
    if (orderModel.order.orderStatus == 1) {//代发货
      if (orderModel.order.refundStatus == 0) {//发起退款
        return RefundStatusWidget(string: "退款中",color:ApplicationUtils.orangeColor ,function: (){
          Navigator.push(context,
              new MaterialPageRoute(builder: (context) {
                return CheckBuyerRefundPage(
                  orderModel: orderModel,
                );
              }));
        },);
      } else if (orderModel.order.refundStatus == 2) {//拒绝退款
        return RefundStatusWidget(string: "退款中",color:ApplicationUtils.orangeColor ,function: (){
          Navigator.push(context,
              new MaterialPageRoute(builder: (context) {
                return CheckBuyerRefundPage(orderModel: orderModel,);
              }));
        },);
      } else if (orderModel.order.refundStatus == 3) {//退款中（同意退款，但是有延迟时间）
        return RefundStatusWidget(string: "退款中",color:ApplicationUtils.orangeColor ,function: (){
          Navigator.push(context,
              new MaterialPageRoute(builder: (context) {
                return CheckBuyerRefundPage(
                  orderModel: orderModel,
                );
              }));
        },);
      } else {
        return Container();
      }
    } else if (orderModel.order.orderStatus == 2) {//待收货
      if (orderModel.order.refundStatus == 0) {//发起退款
        return RefundStatusWidget(string: "退款中",color:ApplicationUtils.orangeColor,function: (){
          Navigator.push(context,
              new MaterialPageRoute(builder: (context) {
                return CheckBuyerRefundPage(
                  orderModel: orderModel,
                );
              }));
        },);
      } else if (orderModel.order.refundStatus == 2) {//拒绝退款
        return RefundStatusWidget(string: "退款中",color:ApplicationUtils.orangeColor ,function: (){
          Navigator.push(context,
              new MaterialPageRoute(builder: (context) {
                return CheckBuyerRefundPage(orderModel: orderModel,);
              }));
        },);
      } else if (orderModel.order.refundStatus == 3) {//退款中
        return RefundStatusWidget(string: "退款中",color:ApplicationUtils.orangeColor,function: (){
          Navigator.push(context,
              new MaterialPageRoute(builder: (context) {
                return CheckBuyerRefundPage(
                  orderModel: orderModel,
                );
              }));
        },);
      } else {
        return Container();
      }
    } else if (orderModel.order.orderStatus == 3) {//交易完成
      return Container();
    } else if (orderModel.order.orderStatus == 4) {//交易关闭
      if (orderModel.order.refundStatus == 1) {
        return RefundStatusWidget(string: "已退款",color:ApplicationUtils.orangeColor,function: (){
          Navigator.push(context,
              new MaterialPageRoute(builder: (context) {
                return CheckBuyerRefundPage(
                  orderModel: orderModel,
                );
              }));
        },);
      } else {
        return Container();
      }
    } else {
      return Container();
    }
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
  Widget _goodsModel(OrderProduct orderProduct,) {
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
        "包装规格：${orderProduct.norms??""}/${orderProduct.unit??""}",

        style: ApplicationUtils.modelStyle
      ),
    );
  }


  //商品价格
  Widget _sumAmount(OrderProduct orderProduct,) {
    return Text(
      '￥${orderProduct.price ?? ""}x\n${orderProduct.proNumber ?? ""}',
      style: ApplicationUtils.priceModel,
      textAlign: TextAlign.right,
    );
  }

  Widget getListWidget(List<OrderProduct> list,OrderModel orderModel) {
    List<Widget> listWidget = [];
    for (int i = 0; i < list.length; i++) {
      OrderProduct orderProduct = list[i];
      //列表项 传入列表数据及索引
      listWidget.add(_listWidget(orderProduct,orderModel));
      if(i==0){
        break;
      }
    }
    return Column(
      children: listWidget,
    );
  }
}
