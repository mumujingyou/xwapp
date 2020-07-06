import 'package:city_pickers/city_pickers.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:xingwang_project/Model/addressModelList.dart';
import 'package:xingwang_project/Utils/application.dart';
import 'package:xingwang_project/api/api.dart';
import 'package:xingwang_project/components/loadingDialog.dart';
import 'package:xingwang_project/components/myBanYuanButton.dart';

class EditAddress extends StatefulWidget {
  final AddressModel addressModel;

  const EditAddress({Key key, this.addressModel}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return EditAddressState();
  }
}

class EditAddressState extends State<EditAddress> {
  var nickNameController = TextEditingController();
  var phoneController = TextEditingController();
  var addressController = TextEditingController();

  @override
  void initState() {
    nickNameController.text = widget.addressModel.nickName;
    phoneController.text = widget.addressModel.phone;
    addressController.text = widget.addressModel.address;

    resultArr = new Result(
        provinceName: widget.addressModel.provinceName,
        cityName: widget.addressModel.cityName,
        areaName: widget.addressModel.districtName);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          title: Text(
            '编辑收货地址',
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
          child: ListView(
            children: <Widget>[
              createItem(nickNameController, "收货人"),
              createItem(phoneController, "联系人",textInputType: TextInputType.phone),
              provinceCityDistrict(),

              createItem(addressController, "详细地址"),
              defaultAddress(widget.addressModel),
              SizedBox(
                height: 1,
              ),
              tip(),

              SizedBox(
                height: 10,
              ),
              MyBanYuanButton(
                string: "删除收货地址",
                function: () {
                  ApplicationUtils.showLoadingBool(context, () async {
                    Map result=await API.deleteAddress(widget.addressModel.id);
                    if (result["data"] == true) {
                      Fluttertoast.showToast(msg: result["msg"]);
                      Navigator.pop(context);
                      return true;
                    } else {
                      Fluttertoast.showToast(msg: result["msg"]);
                      return false;
                    }
                  });
                },
              ),

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

  int statusInt = 0;
  bool status = false;

  Widget defaultAddress(AddressModel addressModel) {
    return Container(
      color: Colors.white,
      child: Row(
        children: <Widget>[
          Container(padding: EdgeInsets.all(15), child: Text("默认地址")),
          Expanded(
            child: Container(),
          ),
          Switch(
            value: addressModel.defaultStatus == 1 ? true : false,
            onChanged: (bool value) {
              setState(() {
                status = value;
                if (status == true) {
                  statusInt = 1;
                } else {
                  statusInt = 0;
                }
              });
            },
          ),
        ],
      ),
    );
  }

  bool isCanChange=false;
  Widget provinceCityDistrict() {
    return Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text(isCanChange==false?"${widget.addressModel.provinceName}${widget.addressModel.cityName}${widget.addressModel.districtName}":
            "${resultArr.provinceName}${resultArr.cityName}${resultArr.areaName}"),
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

  void _clickEventFunc() async {
    Result tempResult = await CityPickers.showCityPicker(
        context: context,
        theme: Theme.of(context).copyWith(primaryColor: Color(0xfffe1314)),
        // 设置主题
        locationCode: resultArr != null
            ? resultArr.areaId ?? resultArr.cityId ?? resultArr.provinceId
            : null,
        // 初始化地址信息
        cancelWidget: Text(
          '取消',
          style: TextStyle(fontSize: 26, color: Color(0xff999999)),
        ),
        confirmWidget: Text(
          '确定',
          style: TextStyle(fontSize: 26, color: Color(0xfffe1314)),
        ),
        height: 220.0);
    if (tempResult != null) {
      setState(() {
        resultArr = tempResult;
        isCanChange=true;
      });
    }
  }

  void save() {
    if(ApplicationUtils.isChinaPhoneLegal(phoneController.text)==false){
      Fluttertoast.showToast(msg:"电话号码错误");
      return;

    }
    int province = widget.addressModel.province;
    int city = widget.addressModel.city;
    int district = widget.addressModel.district;
    API.getProvince(resultArr.provinceName).then((value) {
      province = value;
      API.getCity(resultArr.cityName, value).then((value) {
        city = value;
        API.getDistrict(resultArr.areaName, value).then((value) {
          district = value;
        });
      });
    });
    ApplicationUtils.showLoading(context,time: 3);
    Future.delayed(Duration(seconds: 3),(){
      AddressModel addressModel = AddressModel(
          province: province,
          city: city,
          district: district,
          nickName: nickNameController.text,
          phone: phoneController.text,
          address: addressController.text,
          defaultStatus: statusInt,
          id: widget.addressModel.id);
      API.editAddress(addressModel, province, city, district).then((value) {
        if (value["data"]) {
          Fluttertoast.showToast(msg: value["msg"]);

          Navigator.pop(context);
        } else {
          Fluttertoast.showToast(msg: value["msg"]);
        }
      });
    });
  }
}
