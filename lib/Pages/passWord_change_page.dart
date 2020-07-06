import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xingwang_project/Utils/application.dart';
import 'package:xingwang_project/api/api.dart';
import 'package:xingwang_project/components/myBanYuanButton.dart';
import 'package:xingwang_project/components/myCircleAvator.dart';
import 'package:xingwang_project/routers/application.dart';
import 'package:xingwang_project/routers/routes.dart';

class PassWordChangPage extends StatefulWidget {
  @override
  PassWordChangPageState createState() {
    return PassWordChangPageState();
  }
}

class PassWordChangPageState extends State<PassWordChangPage> {
  var curentPassWord = new TextEditingController();
  var newPassWord = new TextEditingController();
  var anginNewPassWord = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text(
          '密码修改',
          style: TextStyle(fontSize: 25),
        ),
        centerTitle: true,
        backgroundColor: ApplicationUtils.appBarColor,
        actions: <Widget>[
          IconButton(
            icon: Image.asset(
              "assets/images/notice.png",
              width: 25,
            ),
            onPressed: () {},
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            createTextField(curentPassWord, "请输入当前密码"),
            createTextField(newPassWord, "请输入新密码"),
            createTextField(anginNewPassWord, "请再次输入新密码"),
            _saveButton()
          ],
        ),
      ),
    );
  }

  Widget createTextField(TextEditingController controller, String hint) {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10), color: Colors.white),
          child: TextField(
            enableInteractiveSelection: false,
              decoration: InputDecoration(
                hintText: hint,
                border: InputBorder.none,
              ),
              controller: controller,
              obscureText: true),
        ),
        SizedBox(
          height: 10,
        )
      ],
    );
  }

  _saveButton() {
    return MyBanYuanButton(
      color: Colors.green,
      string: "保存",
      function: () async {
        if (isCanChange() == false) {
          return;
        }
        ApplicationUtils.showLoading(context,time: 2);
        Map result=await API.changePassWord(curentPassWord.text, newPassWord.text);
        if (result["data"]) {
          Fluttertoast.showToast(msg: result["msg"]);
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setBool('isLogin', false);
          Application.router.navigateTo(context, "${Routes.loginPage}",
              transition: TransitionType.fadeIn,clearStack: true);
        } else {
          Fluttertoast.showToast(msg: result["msg"]);


        }
      },
    );
  }

  bool isCanChange() {
    if (newPassWord.text != anginNewPassWord.text) {
      Fluttertoast.showToast(msg: "两次输入新密码不一致，请重新输入");
      return false;
    }
    return true;
  }
}
