import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:fluwx_pay_only/fluwx_pay_only.dart' as fluwx;
import 'package:xingwang_project/Model/weChatPay.dart';
import 'package:xingwang_project/components/loadingDialog.dart';
import 'package:xingwang_project/routers/application.dart';
import 'package:xingwang_project/routers/routes.dart';


class ApplicationUtils {

  static  double width = 250;
  static  double widther = 250;


  static Color appBarColor = Color(0xff73CE3C);
  static Color orangeColor=Color.fromARGB(255, 250, 104, 14);
  static Color grey=Colors.grey[400];


  static TextStyle goodListNameTextStyle = TextStyle(color: Colors.black,
      fontSize: 23, fontWeight: FontWeight.w500);

  static TextStyle modelStyle = new TextStyle(fontSize: 18, color: Colors.grey[500]);
  static TextStyle priceModel = TextStyle(color: Colors.black,
      fontSize: 20, fontWeight: FontWeight.w400);


  static void showLoading(BuildContext context, {int time = 4}) {
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

    Future.delayed(Duration(seconds: time), () {
      Navigator.pop(buildContext);
    });
  }


  static Future showLoadingBool(BuildContext context,Function() function) async {
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
    bool result=await function();
    if(result){
      print(2222);
      Navigator.pop(buildContext);
    }else{
      print(1111);
      Navigator.pop(buildContext);
    }

  }

  //初始化微信支付
  static void initFluwx() async {
    await fluwx.registerWxApi(
      appId: "wx3bd501bac71972f0",
      doOnAndroid: true,
      doOnIOS: true,
    );
    var result = await fluwx.isWeChatInstalled();
    listenWeChat();
    print("is installed $result");
  }

  //微信支付
  static void weChatPayFunction(WeChatPay weChatPay, BuildContext context,
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
        Future.delayed(Duration(seconds: 10), () {
          Navigator.pop(context);
          if (isCanPop) {
            Application.router.navigateTo(context, "${Routes.myOrder}",
                transition: TransitionType.fadeIn);
          }
        });
      }
    });
  }


  //微信支付2
  static void weChatPayFunction2(WeChatPay weChatPay, BuildContext context,
      {bool isRun = true}) {
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
        Future.delayed(Duration(seconds: 1), () {
          Navigator.pop(context);
          if (isRun) {
            Application.router.navigateTo(context, "${Routes.myOrder}",
                transition: TransitionType.fadeIn);
          }
        });
      }
    });
  }


  static int result = 10;

  static void listenWeChat() {
    // 监听支付结果
    fluwx.responseFromPayment.listen((data) {
      result = data.errCode;
      print("result");
    });
  }


  static bool isChinaPhoneLegal(String str) {
    return new RegExp('^((13[0-9])|(15[^4])|(166)|(17[0-8])|(18[0-9])|(19[8-9])|(147,145))\\d{8}\$').hasMatch(str);
  }

  /// 检查是否是邮箱格式
  static bool isEmail(String input) {
    /// 邮箱正则
    final String regexEmail = "^\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*\$";
    if (input == null || input.isEmpty) return false;
    return new RegExp(regexEmail).hasMatch(input);
  }

}