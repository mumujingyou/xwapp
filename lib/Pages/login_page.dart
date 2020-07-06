import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xingwang_project/Utils/application.dart';
import 'package:xingwang_project/api/api.dart';
import 'package:xingwang_project/components/myBanYuanButton.dart';
import 'package:xingwang_project/routers/application.dart';
import 'package:xingwang_project/routers/routes.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  var usernameController = new TextEditingController();
  var passwordController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ApplicationUtils.appBarColor,
        title: Text("登录账号", style: TextStyle(fontSize: 25)),
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        height: 500,
        child: Column(
          children: <Widget>[
            Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
              child: TextField(
                enableInteractiveSelection: false,

                decoration: InputDecoration(
                  hintText: "请输入账号",
                ),
                controller: usernameController,
              ),
            ),
            Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
              child: TextField(
                enableInteractiveSelection: false,

                decoration: InputDecoration(hintText: "请输入密码"),
                obscureText: true,
                controller: passwordController,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            MyBanYuanButton(
              color: Colors.green,
              string: "登录",
              function: () {
                onLogin();
              },
            ),
          ],
        ),
      ),
    );
  }

  void onLogin() {
    if (usernameController.text.isEmpty) {
      Fluttertoast.showToast(msg: "用户名不能为空哦");
    } else if (passwordController.text.isEmpty) {
      Fluttertoast.showToast(msg: "密码不能为空哦");
    } else {
      ApplicationUtils.showLoadingBool(context, () async {
        Map result = await API.login(
            usernameController.text, passwordController.text);
        if (result["data"]==true) {
          print(333333);
          _saveData().then((value) {
            if (value == true) {
              Fluttertoast.showToast(msg: result["msg"]);
              Navigator.pop(context);
              Application.router.navigateTo(context, "${Routes.mainPage}",
                  transition: TransitionType.fadeIn);
              return true;
            }else{
              return false;
            }
          });
          return true;
        } else {
          Fluttertoast.showToast(msg: result["msg"]);
          return false;
        }
      });
    }
  }

  _saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLogin', true);
    prefs.setString("phone", API.userModel.phone);
    prefs.setString("passWord", passwordController.text);
    prefs.setString("id", API.userModel.id);
    prefs.setString("headImg", API.userModel.headImg);
    prefs.setString("corporateName", API.userModel.corporateName);
    prefs.setString("personName", API.userModel.personName);
    return true;
  }

}
