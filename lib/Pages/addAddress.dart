import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:xingwang_project/Model/addressModelList.dart';
import 'package:xingwang_project/Utils/application.dart';
import 'package:xingwang_project/api/api.dart';
import 'package:xingwang_project/components/loadingDialog.dart';
import 'package:xingwang_project/components/myBanYuanButton.dart';
import 'package:city_pickers/city_pickers.dart';


class AddAddress extends StatefulWidget {


  @override
  State<StatefulWidget> createState() {
    return AddAddressState();
  }
}

class AddAddressState extends State<AddAddress> {
  var nickNameController = TextEditingController();
  var phoneController = TextEditingController();
  var addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          title: Text(
            '新增收货地址',
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
              createItem(nickNameController, "收货人"),
              createItem(phoneController, "联系电话",textInputType: TextInputType.phone),
              provinceCityDistrict(),
              createItem(addressController, "详细地址"),
              Expanded(
                child: Container(),
              ),
              tip(),
            ],
          ),
        ));
  }

  Widget createItem(TextEditingController controller, String hint,{TextInputType textInputType=TextInputType.text}) {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
          color: Colors.white,
          child: TextField(
            keyboardType: textInputType,
            enableInteractiveSelection: false,
            controller: controller,
            decoration:
                InputDecoration(border: InputBorder.none, hintText: hint),
          ),
        ),
        Divider(
          height: 1.0,
          color: Colors.grey[200],
        ),
      ],
    );
  }

  int status = 0;

  Widget defaultAddress() {
    return Container(
      color: Colors.white,
      child: Row(
        children: <Widget>[
          Container(padding: EdgeInsets.all(10), child: Text("设为默认地址")),
          Expanded(
            child: Container(),
          ),
          InkWell(
            child: Switch(
              value: status == 1,
              onChanged: (bool value) {
                if (value == true) {
                  status = 1;
                } else {
                  status = 0;
                }
              },
            ),
          )
        ],
      ),
    );
  }

  Widget provinceCityDistrict() {
    return Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text(resultArr.provinceId == null
                ? "省市区"
                : "${resultArr.provinceName??""} ${resultArr.cityName??""} ${resultArr.areaName??""}"),
            trailing: new Icon(Icons.keyboard_arrow_right),
            onTap: () {
              _clickEventFunc();
            },
          ),
          Divider(height: 1.0, color: Colors.grey[200]),
        ],
      ),
    );
  }

  Widget tip() {
    return Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Text(
            "温馨提醒您，省市区请不要选择港澳台地区",
            style: TextStyle(color: Colors.red),
          ),
          Divider(height: 1.0, color: Colors.grey[200]),
        ],
      ),
    );
  }

  Result resultArr = new Result();

  void _clickEventFunc() async{
    Result tempResult = await CityPickers.showCityPicker(
        context: context,
        theme: Theme.of(context).copyWith(primaryColor: Color(0xfffe1314)), // 设置主题
        locationCode: resultArr != null ? resultArr?.areaId ?? resultArr?.cityId ?? resultArr?.provinceId : null, // 初始化地址信息
        cancelWidget: Text(
          '取消',
          style: TextStyle(fontSize: 26,color: Color(0xff999999)),
        ),
        confirmWidget: Text(
          '确定',
          style: TextStyle(fontSize: 26, color: Color(0xfffe1314)),
        ),
        height: 220.0);
    if (tempResult != null) {
      setState(() {
        resultArr = tempResult;
      });
    }
  }

  void save() {
    if(ApplicationUtils.isChinaPhoneLegal(phoneController.text)==false){
      Fluttertoast.showToast(msg:"电话号码错误");
      return;

    }
    int province = -1;
    int city = -1;
    int district = -1;
    API.getProvince(resultArr.provinceName).then((value) {
      province = value;
      API.getCity(resultArr.cityName, value).then((value) {
        city = value;
        API.getDistrict(resultArr.areaName, value).then((value) {
          district = value;
        });
      });
    });

    print("province   $province");
    print("city   $city");

    print("district   $district");

    ApplicationUtils.showLoading(context,time: 3);
    // 延时1s执行返回
    Future.delayed(Duration(seconds: 3), () {
      AddressModel addressModel = AddressModel(
          province: province,
          city: city,
          district: district,
          nickName: nickNameController.text,
          phone: phoneController.text,
          address: addressController.text,
          defaultStatus: 1);
      API.addAddress(addressModel, province, city, district).then((value) {
        if (value["data"]) {
          Fluttertoast.showToast(msg:value["msg"]);

          Navigator.pop(context);
        } else {

          Fluttertoast.showToast(msg:value["msg"]);

        }
      });
    });
  }
}
