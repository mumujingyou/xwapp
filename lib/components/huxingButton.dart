import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RefundStatusWidget extends StatelessWidget {

  final double height;
  final double width;
  final Color color;
  final String string;
  final Function function;
  final double fontSize;

  const RefundStatusWidget({Key key, this.height=25, this.width=60, this.color, this.string, this.function, this.fontSize=13}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(child: Container(
      margin: EdgeInsets.only(left: 0, top: 0),
      //设置 child 居中
      alignment: Alignment(0, 0),
      height: height,
      width: width,
      //边框设置
      decoration: new BoxDecoration(
        //背景
        color: Colors.white,
        //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
        borderRadius: BorderRadius.all(Radius.circular(25.0)),
        //设置四周边框
        border: new Border.all(width: 2, color: color),
      ),
      child: Text(string, style: TextStyle(fontSize: fontSize, color: color),),
    ), onTap: function,);
  }
}