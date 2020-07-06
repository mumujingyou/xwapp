import 'package:flutter/material.dart';
import 'package:xingwang_project/Utils/application.dart';

class RoundCheckBox extends StatefulWidget {
  final bool value;

  final Function(bool) onChanged;

  RoundCheckBox({Key key, this.onChanged, this.value})
      : super(key: key);

  @override
  RoundCheckBoxState createState() => RoundCheckBoxState();
}

class RoundCheckBoxState extends State<RoundCheckBox>
    with TickerProviderStateMixin {
  bool value;
  Function(bool) onChanged;

  @override
  void initState() {
    value = widget.value;
    onChanged = widget.onChanged;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
          onTap: () {
            setState(() {
              value = !value;
              onChanged(value);
            });
          },
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: value
                ? Icon(
              Icons.check_circle,
              size: 25.0,
              color: ApplicationUtils.appBarColor,
            )
                : Icon(
              Icons.panorama_fish_eye,
              size: 25.0,
              color: Colors.grey,
            ),
          )),
    );
  }

  void changeStatus(bool bool) {
    setState(() {
      value = bool;
    });
  }
}

class MyCheckBox extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyCheckBoxState();
  }

}

class MyCheckBoxState extends State<MyCheckBox> {

  bool check=false;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Checkbox(
      value: this.check,
      activeColor: Colors.blue,
      onChanged: (bool val) {
        // val 是布尔值
        this.setState(() {
          this.check = !this.check;
        });
      },
    );



  }

}

