import 'dart:io';

import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xingwang_project/Pages/main_Page.dart';
import 'package:xingwang_project/Utils/PictureLooking.dart';
import 'package:xingwang_project/Utils/application.dart';
import 'package:xingwang_project/components/loadingDialog.dart';
import 'package:xingwang_project/components/myCircleAvator.dart';
import 'package:xingwang_project/routers/application.dart';
import 'package:xingwang_project/routers/routes.dart';

import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:xingwang_project/api/api.dart';

class StatusChangePage extends StatefulWidget {
  @override
  StatusChangePageState createState() {
    return StatusChangePageState();
  }
}

class StatusChangePageState extends State<StatusChangePage> {
  String headImg = "";

  @override
  void initState() {
    headImg = API.userModel.headImg;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '资料修改',
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
            onPressed: () {
              Application.router.navigateTo(
                context,
                "${Routes.noticeListPage}",
                transition: TransitionType.fadeIn,
              );
            },
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          InkWell(
            child: CircleHeadImgRight(
                imagePath: headImg ??
                    "http://pic1.win4000.com/wallpaper/d/58006e5a6ddd1.jpg",
                tittle: "我的头像"),
            onTap: () {
              _showDialog(context);
            },
          ),
          InkWell(
            child: MyListTile(tittle: "密码修改"),
            onTap: () {
              Application.router.navigateTo(
                context,
                Routes.passWordChange,
                transition: TransitionType.fadeIn,
              );
            },
          ),
        ],
      ),
    );
  }

  void _showDialog(BuildContext cxt) {
    showCupertinoModalPopup<int>(
        context: cxt,
        builder: (cxt) {
          var dialog = CupertinoActionSheet(
            cancelButton: CupertinoActionSheetAction(
                onPressed: () {
                  Navigator.pop(cxt, 0);
                },
                child: Text("取消")),
            actions: <Widget>[
              CupertinoActionSheetAction(
                  isDestructiveAction: true,
                  onPressed: () async {
                    var image =
                        await ImagePicker.pickImage(source: ImageSource.camera);
                    if (image != null) {
                      File croppedFile = await ImageCropper.cropImage(
                          sourcePath: image.path,
                          aspectRatioPresets: [CropAspectRatioPreset.square]);

                      API.changeAvatar(croppedFile).then((value) async {
                        setState(() {
                          headImg = value;
                        });
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        prefs.setString("headImg", value);
                        API.userModel.headImg = headImg;
                      });
                    }
                    Navigator.of(cxt).pop();
                    ApplicationUtils.showLoading(context);
                  },
                  child: Text('拍照')),
              CupertinoActionSheetAction(
                  onPressed: () async {
                    var image = await ImagePicker.pickImage(
                        source: ImageSource.gallery);
                    //没有选择图片或者没有拍照
                    if (image != null) {
                      File croppedFile = await ImageCropper.cropImage(
                          sourcePath: image.path,
                          aspectRatioPresets: [CropAspectRatioPreset.square]);
                      API.changeAvatar(croppedFile).then((value) async {
                        setState(() {
                          headImg = value;
                        });
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        prefs.setString("headImg", value);
                        API.userModel.headImg = headImg;
                      });
                    }
                    Navigator.of(cxt).pop();
                    ApplicationUtils.showLoading(context);
                  },
                  child: Text('从相册中选择')),
              CupertinoActionSheetAction(
                  onPressed: () {
                    Navigator.of(cxt).pop();
                    Navigator.of(context).push(NinePicture([headImg], 0));
                  },
                  child: Text('查看照片')),
            ],
          );
          return dialog;
        });
  }
}
