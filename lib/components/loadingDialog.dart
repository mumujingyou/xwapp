/*
 * 自定义等待加载提示框
 * Created by ZhangJun on 2018-11-29
 */

import 'package:flutter/material.dart';
import 'package:xingwang_project/Utils/application.dart';

class LoadingDialog extends Dialog {
  final String text;

  LoadingDialog({Key key, @required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Material(
      type: MaterialType.transparency,
      child: new Center(
        child: new SizedBox(
          width: 120.0,
          height: 120.0,
          child: new Container(
            decoration: ShapeDecoration(
              color: Color(0xffffffff),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(8.0),
                ),
              ),
            ),
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                new CircularProgressIndicator(backgroundColor:ApplicationUtils.appBarColor),
                new Padding(
                  padding: const EdgeInsets.only(
                    top: 20.0,
                  ),
                  child: new Text(text),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
