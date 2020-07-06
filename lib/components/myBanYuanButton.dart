import 'package:flutter/material.dart';

class MyBanYuanButton extends StatelessWidget {
  final Function function;
  final String string;
  final double width;
  final double height;
  final double fontSize;
  final Color color;

  const MyBanYuanButton({Key key, this.function, this.string, this.width=300, this.height=50, this.fontSize=20, this.color=Colors.red,})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: InkWell(
        onTap: () {
          function();
        },
        child: Container(
          width: width,
          height: height,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5), color: color),
          child: Text(
            string, style: TextStyle(fontSize: fontSize, color: Colors.white),),
        ),
      ),
    );
  }



}
