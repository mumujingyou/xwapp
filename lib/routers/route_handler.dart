import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:xingwang_project/Pages/addAddress.dart';
import 'package:xingwang_project/Pages/addReceipt.dart';
import 'package:xingwang_project/Pages/apply_fefund_page.dart';
import 'package:xingwang_project/Pages/buyer_order_detail_page.dart';
import 'package:xingwang_project/Pages/buyer_order_page.dart';
import 'package:xingwang_project/Pages/check_buyer_fefund_page.dart';
import 'package:xingwang_project/Pages/createOrder_page.dart';
import 'package:xingwang_project/Pages/editAddress.dart';
import 'package:xingwang_project/Pages/addressManager.dart';
import 'package:xingwang_project/Pages/editReceipt.dart';
import 'package:xingwang_project/Pages/good_detail.dart';
import 'package:xingwang_project/Pages/login_page.dart';
import 'package:xingwang_project/Pages/main_Page.dart';
import 'package:xingwang_project/Pages/my_refund_detail_page.dart';
import 'package:xingwang_project/Pages/my_order_detail_page.dart';
import 'package:xingwang_project/Pages/my_order_page.dart';
import 'package:xingwang_project/Pages/my_stock_page.dart';
import 'package:xingwang_project/Pages/noticeList_page.dart';
import 'package:xingwang_project/Pages/passWord_change_page.dart';
import 'package:xingwang_project/Pages/pay_page.dart';
import 'package:xingwang_project/Pages/receiptDetail.dart';
import 'package:xingwang_project/Pages/receiptManager.dart';
import 'package:xingwang_project/Pages/refuseRefundPage.dart';
import 'package:xingwang_project/Pages/status_change_page.dart';
import 'package:xingwang_project/Pages/yindao_page.dart';

//创建Handler用来接收路由参数及返回第二个页面对象
//Handler secondPageHandler = Handler(
//    handlerFunc: (BuildContext context,Map<String,List<String>> params){
//      //读取goodId参数 first即为第一个数据
//      String goodId = params['goodId'].first;
//      return SecondPage(goodId);
//    }
//);

Handler loginPageHandler = Handler(
    handlerFunc: (BuildContext context,Map<String,List<String>> params){
      return LoginPage();
    }
);

Handler mainPageHandler = Handler(
    handlerFunc: (BuildContext context,Map<String,List<String>> params){
      return MainPage();
    }
);

Handler goodDetailPageHandler = Handler(
    handlerFunc: (BuildContext context,Map<String,List<String>> params){
      //读取goodId参数 first即为第一个数据
      String goodId = params['goodId'].first;
      return GoodDetailPage(id: goodId,);
    }
);

Handler statusChangePageHandler = Handler(
    handlerFunc: (BuildContext context,Map<String,List<String>> params){
      return StatusChangePage();
    }
);

Handler rootPageHandler = Handler(
    handlerFunc: (BuildContext context,Map<String,List<String>> params){
      return HomePage();
    }
);

Handler passWordChangeHandler = Handler(
    handlerFunc: (BuildContext context,Map<String,List<String>> params){
      return PassWordChangPage();
    }
);

Handler addressManagerHandler = Handler(
    handlerFunc: (BuildContext context,Map<String,List<String>> params){
      String isCanPop = params["isCanPop"]?.first;
      return AddressManager(isCanPop: isCanPop,);
    }
);

Handler editAddressHandler = Handler(
    handlerFunc: (BuildContext context,Map<String,List<String>> params){

      return EditAddress();
    }
);

Handler addAddressHandler = Handler(
    handlerFunc: (BuildContext context,Map<String,List<String>> params){
      return AddAddress();
    }
);

Handler createOrderHandler = Handler(
    handlerFunc: (BuildContext context,Map<String,List<String>> params){
      return CreateOrder();
      //return Sample();
    }
);

Handler myOrderHandler = Handler(
    handlerFunc: (BuildContext context,Map<String,List<String>> params){
      return MyOrderPage();
    }
);

Handler myOrderDetailHandler = Handler(
    handlerFunc: (BuildContext context,Map<String,List<String>> params){
      return MyOrderDetailPage();
    }
);

Handler myApplyRefundHandler = Handler(
    handlerFunc: (BuildContext context,Map<String,List<String>> params){
      return ApplyRefundPage();
    }
);

Handler buyerOrderHandler = Handler(
    handlerFunc: (BuildContext context,Map<String,List<String>> params){
      return BuyerOrderPage();
    }
);

Handler buyerOrderDetailHandler = Handler(
    handlerFunc: (BuildContext context,Map<String,List<String>> params){
      return BuyerOrderDetailPage();
    }
);

Handler checkBuyerRefundPageHandler = Handler(
    handlerFunc: (BuildContext context,Map<String,List<String>> params){
      return CheckBuyerRefundPage();
    }
);

Handler myStockListHandler = Handler(
    handlerFunc: (BuildContext context,Map<String,List<String>> params){
      return MyStockPage();
    }
);

Handler myRefundDetailHandler = Handler(
    handlerFunc: (BuildContext context,Map<String,List<String>> params){
      return MyRefundDetailPage();
    }
);

Handler payPageHandler = Handler(
    handlerFunc: (BuildContext context,Map<String,List<String>> params){
      return PayPage();
    }
);


Handler noticeListPageHandler = Handler(
    handlerFunc: (BuildContext context,Map<String,List<String>> params){
      return NoticeListPage();
    }
);

Handler refuseRefundPageHandler = Handler(
    handlerFunc: (BuildContext context,Map<String,List<String>> params){
      return RefuseRefundPage();
    }
);

Handler receiptManagerPageHandler = Handler(
    handlerFunc: (BuildContext context,Map<String,List<String>> params){
      //return MyHomePage(title: "hhhh",);
      return ReceiptManager();
    }
);

Handler addReceiptPageHandler = Handler(
    handlerFunc: (BuildContext context,Map<String,List<String>> params){
      return AddReceipt();
    }
);

Handler editReceiptPageHandler = Handler(
    handlerFunc: (BuildContext context,Map<String,List<String>> params){
      return EditReceipt();
    }
);

Handler receiptDetailPageHandler = Handler(
    handlerFunc: (BuildContext context,Map<String,List<String>> params){
      return ReceiptDetail();
    }
);