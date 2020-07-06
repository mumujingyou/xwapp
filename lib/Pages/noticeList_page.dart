import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:xingwang_project/Model/myOrder.dart';
import 'package:xingwang_project/Model/noticeModel.dart';
import 'package:xingwang_project/Pages/buyer_order_detail_page.dart';
import 'package:xingwang_project/Pages/check_buyer_fefund_page.dart';
import 'package:xingwang_project/Pages/my_order_detail_page.dart';
import 'package:xingwang_project/Pages/my_refund_detail_page.dart';
import 'package:xingwang_project/Pages/refuseRefundPage.dart';
import 'package:xingwang_project/Utils/application.dart';
import 'package:xingwang_project/api/api.dart';
import 'package:xingwang_project/components/loadingDialog.dart';
import 'package:xingwang_project/routers/application.dart';
import 'package:xingwang_project/routers/routes.dart';

class NoticeListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return NoticeListPageState();
  }
}

class NoticeListPageState extends State<NoticeListPage> {
  List<NoticeModel> lists = [];
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

  NoticeListPageState() {
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
    API.getAppRemindList(start).then((value) {
      setState(() {
        lists.addAll(value.data);
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
    var isCurrent = ModalRoute.of(context).isCurrent;
    if (isCurrent) {
      _pullToRefresh();
    }
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            '消息提醒',
            style: TextStyle(fontSize: 25),
          ),
          centerTitle: true,
          backgroundColor: ApplicationUtils.appBarColor,
        ),
        backgroundColor: Colors.grey[200],
        body: lists.length == 0
            ? new Center(
                child: isEmpty
                    ? new Text("亲，您还没有消息呢")
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
                      return createItem(lists[index]);
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


  Widget createItem(NoticeModel noticeModel){
    return InkWell(
      onTap: (){

        if(noticeModel.type=="1"){//买家下单
          navigatorToBuyerOrderDetail(noticeModel);
        }else if(noticeModel.type=="2"){//买家发起退款
          navigatorToCheckBuyerRefundPage(noticeModel);
        }else if(noticeModel.type=="0"){//我的库存列表
          Application.router.navigateTo(
            context,
            "${Routes.myStockList}",
            transition: TransitionType.fadeIn,
          );
        }else if(noticeModel.type=="3"){//平台同意我的退款详情
          navigatorToMyRefundPage(noticeModel);
        }else if(noticeModel.type=="4"){//平台拒绝我的退款详情
          navigatorToRefuseRefundPage(noticeModel);
        }else if(noticeModel.type=="5"){//我的订单详情取消订单
          navigatorToMyOrderDetailPage(noticeModel);
        }
      },
      child: Column(
        children: <Widget>[
          Container(height: 60,color: Colors.white,child: Row(
            children: <Widget>[
              Icon(Icons.email,color: Colors.green,),
              SizedBox(width: 10,),
              Column(mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                Text(noticeModel.title??""),
                Text(noticeModel.remindTime??""),
              ],),
            ],
          ),),
          SizedBox(height: 20,)
        ],
      ),
    );
  }

  void navigatorToBuyerOrderDetail(NoticeModel noticeModel) {
    BuildContext buildContext;
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          buildContext = context;
          return new LoadingDialog(
            text: "拼命加载中…",
          );
        });
    Future.delayed(new Duration(seconds: 1),(){
      API.orderDetail(noticeModel.orderId).then((value) {
        Navigator.pop(buildContext);
        Navigator.push(context, new MaterialPageRoute(builder: (context) {
          return BuyerOrderDetailPage(
            orderModel: value,
          );
        }));
      });
    });

  }


  void navigatorToCheckBuyerRefundPage(NoticeModel noticeModel) {
    ApplicationUtils.showLoading(context,time: 1);
    Future.delayed(new Duration(seconds: 1),(){
      API.orderDetail(noticeModel.orderId).then((value) {
        Navigator.push(context, new MaterialPageRoute(builder: (context) {
          return CheckBuyerRefundPage(
            orderModel: value,
          );
        }));
      });
    });
  }


  void navigatorToMyRefundPage(NoticeModel noticeModel) {
    ApplicationUtils.showLoading(context,time: 1);
    Future.delayed(new Duration(seconds: 1),(){
      API.orderDetail(noticeModel.orderId).then((value) {
        Navigator.push(context, new MaterialPageRoute(builder: (context) {
          return MyRefundDetailPage(
            orderModel: value,
          );
        }));
      });
    });
  }

  void navigatorToRefuseRefundPage(NoticeModel noticeModel) {

    BuildContext buildContext;
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          buildContext = context;
          return new LoadingDialog(
            text: "拼命加载中…",
          );
        });
    Future.delayed(new Duration(seconds: 1),(){
      API.orderDetail(noticeModel.orderId).then((value) {
        OrderModel orderModel=value;
        if(orderModel.order.refundStatus == 2){//拒绝退款
          Navigator.pop(buildContext);

          Navigator.push(context, new MaterialPageRoute(builder: (context) {
            return RefuseRefundPage(
              orderModel: value,
              isToNotice: true,
            );
          }));
        }else if(orderModel.order.refundStatus == 0){//重新发起退款
          Navigator.pop(buildContext);

          Navigator.push(context, new MaterialPageRoute(builder: (context) {
            return MyRefundDetailPage(
              orderModel: value,
            );
          }));
        }else if(orderModel.order.refundStatus == 1){//已退款
          Navigator.pop(buildContext);

          Navigator.push(context, new MaterialPageRoute(builder: (context) {
            return MyRefundDetailPage(
              orderModel: value,
            );
          }));
        }else{
          Navigator.pop(buildContext);

          Navigator.push(context, new MaterialPageRoute(builder: (context) {
            return MyOrderDetailPage(
              myOrderModel: value,
            );
          }));
        }

      });
    });

  }

  void navigatorToMyOrderDetailPage(NoticeModel noticeModel) {
    ApplicationUtils.showLoading(context,time: 1);
    Future.delayed(new Duration(seconds: 1),(){
      API.orderDetail(noticeModel.orderId).then((value) {
        Navigator.push(context, new MaterialPageRoute(builder: (context) {
          return MyOrderDetailPage(
            myOrderModel: value,
          );
        }));
      });
    });
  }

}
