import 'package:flutter/material.dart';

TextStyle style = TextStyle(fontSize: 20, color: Colors.grey);

class CircleHeadImg extends StatelessWidget {

  final String tittle;
  final String imagePath;
  final Function function;

  CircleHeadImg({this.tittle, this.imagePath, this.function});

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      InkWell(
        child: ListTile(
          title: Text(tittle, style: style),
          leading: new CircleAvatar(
            radius: 25.0,
            backgroundImage: NetworkImage(
              imagePath,),),
          trailing: new Icon(Icons.keyboard_arrow_right),
        ),
        onTap: function,
      ),
      Divider(height: 1.0, color: Colors.grey,),

    ],);
  }
}


class CircleHeadImgRight extends StatelessWidget {

  final String tittle;
  final String imagePath;
  final Function function;

  CircleHeadImgRight({this.tittle, this.imagePath, this.function});

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      InkWell(
        child: ListTile(
          title: Text(tittle, style: style),
          trailing: Container(
              width: 80, child: Row(
            children: <Widget>[
              new CircleAvatar(
                radius: 25.0,
                backgroundImage: NetworkImage(
                  imagePath,),),
              new Icon(Icons.keyboard_arrow_right),
            ],
          )),
        ),
        onTap: function,
      ),
      Divider(height: 1.0, color: Colors.grey,),

    ],);
  }
}


class MyListTile extends StatelessWidget {
  final String tittle;
  final String imagePath;
  final Function function;

  MyListTile({this.tittle, this.imagePath, this.function});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Column(children: <Widget>[
        ListTile(
          title: Text(tittle, style: style),
          leading: imagePath != null
              ? Image.asset(imagePath, width: 30,)
              : null,
          trailing: new Icon(Icons.keyboard_arrow_right),
        ),
        Divider(height: 1.0, color: Colors.grey,),

      ],),
      onTap: function,
    );
  }
}
