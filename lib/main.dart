import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/services.dart';
import 'package:xingwang_project/Pages/status_change_page.dart';
import 'package:xingwang_project/Pages/yindao_page.dart';
import 'package:xingwang_project/api/api.dart';
import 'package:xingwang_project/routers/routes.dart';
import './routers/application.dart';


void main() {
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])//强制竖屏显示
      .then((_) {
    runApp(new MyApp());
  });
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    //创建路由对象
    final router = Router();
    //配置路由集Routes的路由对象
    Routes.configureRoutes(router);
    //指定Application的路由对象
    Application.router = router;

    _getNow();



    return Container(
      child: MaterialApp(
        title: '兴望农业',
        theme: ThemeData(
            primarySwatch: Colors.green
        ),
        debugShowCheckedModeBanner: false,//去掉右上角的debug
        //生成路由的回调函数，当导航的命名路由的时候，会使用这个来生成界面
        onGenerateRoute: Application.router.generator,
        //主页指定为第一个页面
        home: HomePage(),
      ),
    );
  }


  void _getNow(){
    var nowTime = DateTime.now();//获取当前时间

    String nowTimeTemp=nowTime.toString();

    String timeTemp= nowTimeTemp.split(" ").first;

    String time="";
    List<String> times= timeTemp.split("-");
    times.forEach(
        (item){
          time+=item;
        }
    );

    String signa="ppaQunXin${time}";
    var bytes = utf8.encode(signa); // data being hashed

    var digest = sha256.convert(bytes);

    API.signa="$digest";
    print(digest);
  }


}





