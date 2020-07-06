import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:xingwang_project/Model/addressModelList.dart';
import 'package:xingwang_project/Pages/editAddress.dart';
import 'package:xingwang_project/Utils/application.dart';
import 'package:xingwang_project/api/api.dart';
import 'package:xingwang_project/components/myBanYuanButton.dart';
import 'package:xingwang_project/routers/application.dart';
import 'package:xingwang_project/routers/routes.dart';

class AddressManager extends StatefulWidget {
  final String isCanPop;

  const AddressManager({Key key, this.isCanPop}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return AddressManagerState();
  }
}

class AddressManagerState extends State<AddressManager> {
  List<AddressModel> lists = [];

  @override
  void initState() {
    getAddressList();
    super.initState();
  }

  bool isEmpty = false;
  Future getAddressList() async {
    API.getAddressList().then((value) {
      setState(() {
        lists.clear();
        lists.addAll(value);
        if (lists.length == 0) {
          isEmpty = true;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '地址管理',
          style: TextStyle(fontSize: 25),
        ),
        centerTitle: true,
        backgroundColor: ApplicationUtils.appBarColor,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: lists.length == 0
                ? new Center(
                    child: isEmpty
                        ? new Text("亲，您还没有填写地址呢")
                        : new CircularProgressIndicator())
                : ListView.builder(
                    itemCount: lists.length,
                    itemBuilder: (context, index) {
                      return createItemAddress(lists, index);
                    }),
          ),
          MyBanYuanButton(
            color: Colors.green,
            string: "新增收货地址",
            function: () {
              Application.router.navigateTo(context, "${Routes.addAddress}",
                  transition: TransitionType.fadeIn);
            },
          ),
          SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }

  Widget createItemAddress(List<AddressModel> list, int index) {
    AddressModel addressModel = list[index];
    TextStyle style = TextStyle(fontSize: 15, color: Colors.grey);
    TextStyle addressStyle = TextStyle(fontSize: 15, color: Colors.grey[600]);

    return InkWell(
      onTap: () {
        if (widget.isCanPop == "true") {
          Navigator.pop(context, addressModel);
        }
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(15, 15, 15, 0),
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 7,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      addressModel.defaultStatus == 1
                          ? Container(
                              child: Text(
                                "默认",
                                style: TextStyle(color: Colors.white),
                              ),
                              width: 30,
                              height: 20,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(2),
                                  color: Colors.red),
                            )
                          : Container(),
                      Text(
                        addressModel.nickName,
                        style: style,
                      ),
                      Text(
                        addressModel.phone,
                        style: style,
                      ),
                    ],
                  ),
                  Text(
                    "${addressModel.provinceName}${addressModel.cityName}${addressModel.districtName ?? ""}${addressModel.address}",
                    style: addressStyle,
                  ),
                  Divider(
                    height: 1.0,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 20,
            ),
            Expanded(
              flex: 1,
              child: InkWell(
                child: Text(
                  "编辑",
                  style: TextStyle(fontSize: 15, color: Colors.green),
                ),
                onTap: () {
                  //Application.router.navigateTo(context, "${Routes.editAddress}?addressModel=$addressModel",transition: TransitionType.fadeIn);
                  Navigator.push(context,
                      new MaterialPageRoute(builder: (context) {
                    return EditAddress(
                      addressModel: addressModel,
                    );
                  }));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void deactivate() {
    var bool = ModalRoute.of(context).isCurrent;

    if (bool) {
      lists.clear();

      getAddressList();
    }
    super.deactivate();
  }
}
