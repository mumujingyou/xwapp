import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:xingwang_project/Model/addressModelList.dart';
import 'package:xingwang_project/Model/receiptModel.dart';
import 'package:xingwang_project/Pages/editReceipt.dart';
import 'package:xingwang_project/Utils/application.dart';
import 'package:xingwang_project/api/api.dart';
import 'package:xingwang_project/components/huxingButton.dart';
import 'package:xingwang_project/components/loadingDialog.dart';
import 'package:xingwang_project/components/myBanYuanButton.dart';
import 'package:city_pickers/city_pickers.dart';
import 'package:xingwang_project/components/receiptDetailWidget.dart';
import 'package:xingwang_project/routers/application.dart';
import 'package:xingwang_project/routers/routes.dart';


class ReceiptDetail extends StatefulWidget {


  final ReceiptModel receiptModel;

  const ReceiptDetail({Key key ,this.receiptModel}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ReceiptDetailState();
  }
}

class ReceiptDetailState extends State<ReceiptDetail> {

  TextStyle style=TextStyle(fontSize: 15);
  bool isPerson=true;
  ReceiptModel receiptModel;

  @override
  void initState() {
    receiptModel=widget.receiptModel;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          title: Text(
            '发票抬头详情',
            style: TextStyle(fontSize: 25),
          ),
          centerTitle: true,
          backgroundColor: ApplicationUtils.appBarColor,
          actions: <Widget>[
            FlatButton(
                child: new Icon(Icons.edit,color: Colors.white,),
                onPressed: () {
                  Navigator.pop(this.context);

                  Navigator.push(context, new MaterialPageRoute(builder: (context) {
                    return EditReceipt(
                      receiptModel: receiptModel,
                    );
                  }));
                }
                ),

          ],
        ),
        body: Container(
          child: Column(
            children: <Widget>[
              ReceiptDetailWidget(receiptModel: receiptModel,),
            ],
          ),
        ));
  }



}
