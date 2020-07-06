import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xingwang_project/Model/userModel.dart';
import 'package:xingwang_project/api/api.dart';
import 'package:xingwang_project/routers/application.dart';
import 'package:xingwang_project/routers/routes.dart';
import 'package:connectivity/connectivity.dart';

/*
引导层
 */

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomePageState();
  }
}


class HomePageState extends State<HomePage>{

  //网络状态描述
  String _connectStateDescription;

  var subscription;
  @override
  void initState() {
    super.initState();
    //监测网络变化
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (result == ConnectivityResult.mobile) {
        setState(() {
          _connectStateDescription = "手机网络";
        });
      } else if (result == ConnectivityResult.wifi) {
        setState(() {
          _connectStateDescription = "Wifi网络";
        });
      } else {
        setState(() {
          _connectStateDescription = "无网络";
        });
      }
      print(_connectStateDescription);
      Fluttertoast.showToast(msg: "连接到$_connectStateDescription");
    });
  }

  @override
  void dispose() {
    super.dispose();
    //在页面销毁的时候一定要取消网络状态的监听
    subscription.cancle();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
          children: <Widget>[
            new ConstrainedBox(
              constraints: BoxConstraints.expand(),
              child: new Image.asset(
                "assets/images/loginbg.png",
                fit: BoxFit.fill,
              ),
            ),
            Align(
              child: Text(
                "兴望农业",
                style: TextStyle(fontSize: 50, color: Colors.white),
              ),
              alignment: new FractionalOffset(0.5, 0.7),
            ),
            Align(
              child: IconButton(
                icon: Image.asset(
                  "assets/images/login.png",
                  fit: BoxFit.fill,
                ),
                onPressed: () {
                  if(_connectStateDescription=="无网络"){
                    Fluttertoast.showToast(msg: "请连接网络");
                    return;
                  }
                  _isLogin().then((value) {
                    if (value == true) {
                      Application.router.navigateTo(
                          context, "${Routes.mainPage}",
                          transition: TransitionType.fadeIn);
                    } else {
                      Application.router.navigateTo(
                          context, "${Routes.loginPage}",
                          transition: TransitionType.fadeIn);
                    }
                  });
                },
                iconSize: 180,
              ),
              alignment: new FractionalOffset(0.5, 0.9),
            )
          ],
        ));
  }

  //是否已经登录过
  Future<bool> _isLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool result = prefs.getBool("isLogin");
    String headImg = prefs.getString("headImg");
    String corporateName = prefs.getString('corporateName');
    API.userModel.headImg = headImg;
    API.userModel.corporateName = corporateName;
    return result;
  }

}
