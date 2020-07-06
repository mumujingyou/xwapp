import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:xingwang_project/Model/addressModelList.dart';
import 'package:xingwang_project/Utils/application.dart';
import 'package:xingwang_project/api/api.dart';
import 'package:xingwang_project/components/huxingButton.dart';
import 'package:xingwang_project/components/loadingDialog.dart';
import 'package:xingwang_project/components/myBanYuanButton.dart';
import 'package:city_pickers/city_pickers.dart';


class AddReceipt extends StatefulWidget {


  @override
  State<StatefulWidget> createState() {
    return AddReceiptState();
  }
}

class AddReceiptState extends State<AddReceipt> {

  TextStyle style=TextStyle(fontSize: 15);
  bool isPerson=true;
  Color personColor=Colors.red;
  Color companyColor=Colors.grey;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          title: Text(
            '新增发票抬头',
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
        body: Container(
          child: Column(
            children: <Widget>[
              typeWidget(),
              SizedBox(height: 10,),
              bottomWidget(),
            ],
          ),
        ));
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
              RefundStatusWidget(string: "个人",color: personColor,width: 80,height: 30,fontSize: 15,function: (){

                setState(() {
                  isPerson=true;
                  personColor=Colors.red;
                  companyColor=Colors.grey;
                });

              },),
              SizedBox(width: 10,),
              RefundStatusWidget(string: "单位",color: companyColor,width: 80,height: 30,fontSize: 15,function: (){
                setState(() {
                  isPerson=false;
                  companyColor=Colors.red;
                  personColor=Colors.grey;
                });

              },),

            ],)
          ),
        ],
      ),
    );
  }


  Widget bottomWidget(){
    if(isPerson){
      return createPersonWidget();
    }else{
      return createCompanyWidget();
    }
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

  var nickNameController = TextEditingController();
  var idController = TextEditingController();
  var addressController = TextEditingController();
  var personPhoneController = TextEditingController();
  var emailController = TextEditingController();

  Widget createPersonWidget(){
    return Column(children: <Widget>[
      createItem("姓名","开票人姓名（必填）",nickNameController),
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
        Map result = await API.addBillSet(name: nickNameController.text,unit: addressController.text,
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
        Map result = await API.addBillSet(name: companyNameController.text,taxNo: taxController.text,unit: companyAddressController.text,
            phone: companyPhoneController.text,bank: bankNameController.text,acBank: bankNoController.text,billType: "2");
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
