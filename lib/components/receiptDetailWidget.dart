import 'package:flutter/material.dart';
import 'package:xingwang_project/Model/receiptModel.dart';
import 'package:xingwang_project/Utils/application.dart';
import 'package:xingwang_project/components/huxingButton.dart';

class ReceiptDetailWidget extends StatefulWidget{
  final   ReceiptModel receiptModel;

  const ReceiptDetailWidget({Key key, this.receiptModel}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ReceiptDetailWidgetState();
  }

}

class ReceiptDetailWidgetState extends State<ReceiptDetailWidget>{

  TextStyle style=TextStyle(fontSize: 15);
  bool isPerson=true;
  Color personColor=Colors.red;
  Color companyColor=Colors.grey;
  ReceiptModel receiptModel;


  @override
  void initState() {
    receiptModel=widget.receiptModel;
    if(receiptModel.billType=="1"){
      isPerson=true;
      personColor=Colors.red;
      companyColor=Colors.grey;
    }else if(receiptModel.billType=="2"){
      isPerson=false;
      personColor=Colors.grey;
      companyColor=Colors.red;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return bottomWidget();
  }



  Widget bottomWidget(){
    if(isPerson){
      return createPersonWidget();
    }else{
      return createCompanyWidget();
    }
  }


  Widget createItem(String name,String content) {
    return Column(
      children: <Widget>[
        Container(
          height: 40,
          padding: EdgeInsets.symmetric(horizontal: 10),
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(name,style: style,),
              Container(
                width: ApplicationUtils.widther,
                child:  Text(content,style: style,),
              ),
            ],
          ),
        ),
        SizedBox(height: 2,)
      ],
    );
  }

  Widget createAddressItem(String name,String content) {
    return Column(
      children: <Widget>[
        Container(
          height: 40,
          padding: EdgeInsets.symmetric(horizontal: 10),
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(name,style: style,maxLines: 2,),
              Container(
                width: ApplicationUtils.widther,
                child:  Text(content,style: style,),
              ),
            ],
          ),
        ),
        SizedBox(height: 2,)
      ],
    );
  }

  var nickNameController = TextEditingController();
  var idController = TextEditingController();
  var addressController = TextEditingController();
  var personPhoneController = TextEditingController();
  var emailController = TextEditingController();

  Widget createPersonWidget(){
    return Column(children: <Widget>[
      typeWidget(),
      SizedBox(height: 2,),
      createItem("姓名",receiptModel.name??""),
      //createItem("身份证号",receiptModel.icCard,),
      //createItem("地址",receiptModel.unit,),
      createItem("电话号码",receiptModel.phone??"",),
      createItem("电子邮箱",receiptModel.email??"",),
    ],);
  }

  var companyNameController = TextEditingController();
  var taxController = TextEditingController();
  var companyAddressController = TextEditingController();
  var companyPhoneController = TextEditingController();
  var bankNameController = TextEditingController();
  var bankNoController = TextEditingController();

  Widget createCompanyWidget(){
    return Column(children: <Widget>[
      typeWidget(),
      SizedBox(height: 2,),

      createItem("单位名称",receiptModel.name??"",),
      createItem("税号",receiptModel.taxNo??"",),
      createAddressItem("单位地址",receiptModel.unit??"",),
      createItem("电话号码",receiptModel.phone??"",),
      createItem("开户银行",receiptModel.bank??"",),
      createItem("银行账户",receiptModel.acBank??"",),

    ],);
  }


  Widget typeWidget(){
    return  Container(
      height: 50,
      padding: EdgeInsets.symmetric(horizontal: 10),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text("类型",style: style,),
          Container(
              width: ApplicationUtils.widther,
              child: Row(children: <Widget>[
                RefundStatusWidget(string: "个人",color: personColor,width: 80,height: 30,fontSize: 15,),
                SizedBox(width: 10,),
                RefundStatusWidget(string: "单位",color: companyColor,width: 80,height: 30,fontSize: 15,),

              ],)
          ),
        ],
      ),
    );
  }

}