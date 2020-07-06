import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:xingwang_project/Model/addressModelList.dart';
import 'package:xingwang_project/Model/receiptModel.dart';
import 'package:xingwang_project/Utils/application.dart';
import 'package:xingwang_project/api/api.dart';
import 'package:xingwang_project/components/huxingButton.dart';
import 'package:xingwang_project/components/loadingDialog.dart';
import 'package:xingwang_project/components/myBanYuanButton.dart';
import 'package:city_pickers/city_pickers.dart';


class EditReceipt extends StatefulWidget {

  final ReceiptModel receiptModel;

  const EditReceipt({Key key, this.receiptModel}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return EditReceiptState();
  }
}

class EditReceiptState extends State<EditReceipt> {

  TextStyle style=TextStyle(fontSize: 15);
  bool isPerson=true;
  ReceiptModel receiptModel;

  @override
  void initState() {
    receiptModel=widget.receiptModel;
    if(receiptModel.billType=="1"){
      nickNameController.text=receiptModel.name;
      personPhoneController.text=receiptModel.phone;
      emailController.text=receiptModel.email;
      isPerson=true;
    }else if(receiptModel.billType=="2"){
      isPerson=false;
      companyNameController.text=receiptModel.name;
      taxController.text=receiptModel.taxNo;
      companyAddressController.text=receiptModel.unit;
      companyPhoneController.text=receiptModel.phone;
      bankNameController.text=receiptModel.bank;
      bankNoController.text=receiptModel.acBank;

    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          title: Text(
            '编辑发票抬头',
            style: TextStyle(fontSize: 25),
          ),
          centerTitle: true,
          backgroundColor: ApplicationUtils.appBarColor,
          actions: <Widget>[
            FlatButton(
                child: Text(
                  "保存",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
                onPressed: () {
                    save();
                }),
          ],
        ),
        body: bottomWidget());
  }

  Widget bottomWidget(){
    if(isPerson){
      return createPersonWidget();
    }else{
      return createCompanyWidget();
    }
  }

  Widget createAddressItem(String name,String hint,TextEditingController controller) {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(name,style: style,),
              Container(
                width: ApplicationUtils.widther,
                child: TextField(
                  enableInteractiveSelection: false,
                  maxLines: 2,
                  style: style,
                  controller: controller,
                  decoration:
                  InputDecoration(border: InputBorder.none, hintText: hint),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 2,)
      ],
    );
  }

  Widget createItem(String name,String hint,TextEditingController controller,{TextInputType textInputType=TextInputType.text}) {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(name,style: style,),
              Container(
                width: ApplicationUtils.widther,
                child: TextField(
                  keyboardType: textInputType,
                  enableInteractiveSelection: false,
                  style: style,
                  controller: controller,
                  decoration:
                  InputDecoration(border: InputBorder.none, hintText: hint),
                ),
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
      createItem("姓名","开票人姓名（必填）",nickNameController),
     // createItem("身份证号","身份证号码（个人报销时必填）",idController),
     // createItem("地址","居住地址",addressController),
      createItem("电话号码","个人联系电话",personPhoneController,textInputType: TextInputType.phone),
      createItem("电子邮箱","电子邮箱信息",emailController,textInputType: TextInputType.emailAddress),
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
      createItem("单位名称","抬头名称（必填）",companyNameController),
      createItem("税号","15-20位（企业报销时必填）",taxController,textInputType: TextInputType.number),
      createAddressItem("单位地址","公司地址",companyAddressController),
      createItem("电话号码","公司电话",companyPhoneController,textInputType: TextInputType.phone),
      createItem("开户银行","开户银行名称",bankNameController),
      createItem("银行账户","银行账号",bankNoController,textInputType: TextInputType.number),

    ],);
  }

  save(){
    if(isPerson){//个人

      if(personPhoneController.text!=""){
        if(ApplicationUtils.isChinaPhoneLegal(personPhoneController.text)==false){
          Fluttertoast.showToast(msg:"电话号码不正确");
          return;
        }
      }

      if(emailController.text!=""){
        if(ApplicationUtils.isEmail(emailController.text)==false){
          Fluttertoast.showToast(msg:"邮箱不正确");
          return;
        }
      }
      ApplicationUtils.showLoadingBool(context, () async {
        Map result = await API.updateBillSet(name: nickNameController.text, id: receiptModel.id,
            phone: personPhoneController.text,email: emailController.text,billType: "1");
        if (result["data"]==true) {
          Fluttertoast.showToast(msg: result["msg"]);
          Navigator.pop(context);
          return true;
        } else {
          Fluttertoast.showToast(msg: result["msg"]);
          return false;
        }
      });
    }else{//公司
      if(companyPhoneController.text!=""){
        if(ApplicationUtils.isChinaPhoneLegal(companyPhoneController.text)==false){
          Fluttertoast.showToast(msg:"电话号码不正确");
          return;
        }
      }
      ApplicationUtils.showLoadingBool(context, () async {
        Map result = await API.updateBillSet(name: companyNameController.text,taxNo: taxController.text,unit: companyAddressController.text,
            phone: companyPhoneController.text,bank: bankNameController.text,acBank: bankNoController.text,billType: "2",id:receiptModel.id);
        if (result["data"]==true) {
          Fluttertoast.showToast(msg: result["msg"]);
          Navigator.pop(context);
          return true;
        } else {
          Fluttertoast.showToast(msg: result["msg"]);
          return false;
        }
      });
    }
  }



}
