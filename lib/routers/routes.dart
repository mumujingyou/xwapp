import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'route_handler.dart';


//路由集
class Routes{
  //根路径
  static String root = '/';
  //登录页面路径
  static String loginPage = '/loginPage';
  //主页面
  static String mainPage = '/mainPage';
  //商品详情
  static String goodDetailPage = '/goodDetailPage';
  //资料修改
  static String statusChange = '/statusChange';
  //密码修改
  static String passWordChange = '/passWordChange';
  //图片切割
  static String imageClip = '/imageClip';
  //地址管理
  static String addressManager = '/addressManager';
  //编辑收货地址
  static String editAddress = '/editAddress';
  //新增收货地址
  static String addAddress = '/addAddress';


  static String createOrder = '/createOrder';
  //我的订单
  static String myOrder = '/myOrder';
  //我的订单详情
  static String myOrderDetail = '/myOrderDetail';
  //申请退款
  static String applyRefund = '/applyRefund';
  //买家订单列表
  static String buyerOrder = '/buyerOrder';
  //买家订单详情
  static String buyerOrderDetail = '/buyerOrderDetail';
  //审批买家退款
  static String checkBuyerRefund = '/checkBuyerRefund';
  //我的库存列表
  static String myStockList = '/myStockList';
  //我的退款详情
  static String myRefundDetail = '/myRefundDetail';
  //微信支付
  static String payPage = '/payPage';
  //消息提醒
  static String noticeListPage = '/noticeListPage';
  //拒绝退款
  static String refuseRefundPage="/refuseRefundPage";
  //发票管理
  static String receiptManagerPage="/receiptManager";
  //新增发票
  static String addReceiptPage="/addReceiptPage";
  //编辑发票
  static String editReceiptPage="/editReceiptPage";
  //发票详情
  static String receiptDetailPage="/ReceiptDetailPage";

  //配置路由对象
  static void configureRoutes(Router router){

    //没有找到路由的回调方法
    router.notFoundHandler = Handler(
        handlerFunc: (BuildContext context,Map<String,List<String>> params){
          print('error::: router 没有找到');
        }
    );

    //定义页面路由的Handler
    router.define(loginPage, handler: loginPageHandler);
    router.define(mainPage, handler: mainPageHandler);
    router.define(goodDetailPage, handler: goodDetailPageHandler);
    router.define(statusChange, handler: statusChangePageHandler);
    router.define(root, handler: rootPageHandler);
    router.define(passWordChange, handler: passWordChangeHandler);
    router.define(addressManager, handler: addressManagerHandler);
    router.define(editAddress, handler: editAddressHandler);
    router.define(addAddress, handler: addAddressHandler);
    router.define(createOrder, handler: createOrderHandler);
    router.define(myOrder, handler: myOrderHandler);
    router.define(myOrderDetail, handler: myOrderDetailHandler);
    router.define(applyRefund, handler: myApplyRefundHandler);
    router.define(buyerOrder, handler: buyerOrderHandler);
    router.define(buyerOrderDetail, handler: buyerOrderDetailHandler);
    router.define(checkBuyerRefund, handler: checkBuyerRefundPageHandler);
    router.define(myStockList, handler: myStockListHandler);
    router.define(myRefundDetail, handler: myRefundDetailHandler);
    router.define(payPage, handler: payPageHandler);
    router.define(noticeListPage, handler: noticeListPageHandler);
    router.define(refuseRefundPage, handler: refuseRefundPageHandler);
    router.define(receiptManagerPage, handler: receiptManagerPageHandler);
    router.define(addReceiptPage, handler: addReceiptPageHandler);
    router.define(editReceiptPage, handler: editReceiptPageHandler);
    router.define(receiptDetailPage, handler: receiptDetailPageHandler);



  }

}
