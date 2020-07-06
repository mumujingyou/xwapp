import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xingwang_project/Model/imageCamera.dart';
import 'package:xingwang_project/Model/myOrder.dart';
import 'package:xingwang_project/Model/refundReason.dart';
import 'package:xingwang_project/Utils/PictureLooking.dart';
import 'package:xingwang_project/Utils/application.dart';
import 'package:xingwang_project/api/api.dart';
import 'package:xingwang_project/routers/routes.dart';

class ApplyRefundPage extends StatefulWidget {
  final OrderModel myOrderModel;
  final bool isCanUpdate;
  final bool isToNotice;

  const ApplyRefundPage({Key key, this.myOrderModel, this.isCanUpdate = false, this.isToNotice=false,})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ApplyRefundPageState();
  }
}

class ApplyRefundPageState extends State<ApplyRefundPage> {
  OrderModel myOrderModel;
  List<RefundReason> list = [];
  bool isCanUpdate = false;
  bool isToNotice=false;

  @override
  void initState() {
    myOrderModel = widget.myOrderModel;
    isCanUpdate = widget.isCanUpdate;
    isToNotice=widget.isToNotice;
    _getDefault();
    super.initState();
  }

  Future _getDefault() async {
    phoneCon.text = myOrderModel.order.phone;
    nickNameCon.text = myOrderModel.order.nickName;
  }

  void getRefundReasonList() async {
    API.selectRefundReasonList(sendProduct).then((value) {
      list = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isCanUpdate == false ? '申请退款' : "修改退款申请",
          style: TextStyle(fontSize: 25),
        ),
        centerTitle: true,
        backgroundColor: ApplicationUtils.appBarColor,
        actions: <Widget>[
          FlatButton(
              child: Text(
                "确认",
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
              onPressed: () {
                enterRefund();
              }),
        ],
      ),
      backgroundColor: Colors.grey[200],
      body: ListView(
        children: <Widget>[
          getListWidget(myOrderModel.orderProductList),
          SizedBox(
            height: 2,
          ),
          sendStatusContainer(),
          SizedBox(
            height: 2,
          ),
          refundAmountContainer(),
          SizedBox(
            height: 2,
          ),
          refundReasonContainer(),
          SizedBox(
            height: 2,
          ),
          //createItem(nickNameCon, "联系人", maxLength: 20),
          nickNameContainer(),
          SizedBox(
            height: 2,
          ),
          phoneContainer(),
          SizedBox(
            height: 2,
          ),
          remarkContainer(),
          SizedBox(
            height: 2,
          ),
          cameraImage(),
        ],
      ),
    );
  }

  //商品列表项
  Widget _listWidget(OrderProduct orderProduct) {
    return InkWell(
      onTap: () {
        //Application.router.navigateTo(MainPage.context, "${Routes.goodDetailPage}",transition:TransitionType.fadeIn,);
      },
      child: Container(
        padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              bottom: BorderSide(width: 1.0, color: Colors.black12),
            )),
        //水平方向布局
        child: Row(
          children: <Widget>[
            //返回商品图片
            _goodsImage(orderProduct),
            SizedBox(
              width: 10,
            ),
            //右侧使用垂直布局
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _goodsName(orderProduct),
                  _goodsFunction(orderProduct),
                  _goodsNorms(orderProduct),
                  _sumAmount(orderProduct),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  //商品图片
  Widget _goodsImage(OrderProduct orderProduct) {
    return Container(
      width: 100,
      height: 100,
      child: Image.network(
        orderProduct.picId,
        fit: BoxFit.fitWidth,
      ),
    );
  }

  //商品名称
  Widget _goodsName(OrderProduct orderProduct) {
    return Container(
      //width: 150,
      child: Text(
        orderProduct.proName ?? "",
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: ApplicationUtils.goodListNameTextStyle,
      ),
    );
  }

  //商品功效
  Widget _goodsFunction(OrderProduct orderProduct,) {
    return Container(
      //width: 150,
      child: Text(
          "品牌：${orderProduct.brand ?? ""}",
          overflow: TextOverflow.ellipsis,
          style: ApplicationUtils.modelStyle
      ),
    );
  }

  //商品属性
  Widget _goodsNorms(OrderProduct orderProduct,) {
    return Container(
      //width: 150,
      child: Text(
          "包装规格：${orderProduct.norms ?? ""}/${orderProduct.unit ?? ""}",

          style: ApplicationUtils.modelStyle
      ),
    );
  }

  //商品价格
  Widget _sumAmount(OrderProduct orderProduct,) {
    return Container(
      width: 150,
      child: Row(
        children: <Widget>[
          Text(
            '￥${orderProduct.price}x${orderProduct.proNumber}',
            style: TextStyle(color: Colors.red),
          ),
        ],
      ),
    );
  }


  Widget getListWidget(List<OrderProduct> list) {
    List<Widget> listWidget = [];
    for (int i = 0; i < list.length; i++) {
      OrderProduct orderProduct = list[i];
      //列表项 传入列表数据及索引
      listWidget.add(_listWidget(orderProduct));
    }
    return Column(
      children: listWidget,
    );
  }

  Widget sendStatusContainer() {
    return Container(
      padding: EdgeInsets.all(10),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          RichText(
            text: TextSpan(style: TextStyle(fontSize: 18), children: [
              TextSpan(
                  text: "*",
                  style: TextStyle(color: Colors.red, fontSize: 15)),
              TextSpan(
                  text: "发货状态",
                  style: TextStyle(color: Colors.black, fontSize: 15)),

            ]),
            textDirection: TextDirection.ltr,
          ),
          Container(width: ApplicationUtils.width,
              child: sendStatus(myOrderModel.order)),
        ],
      ),
    );
  }

  Widget refundAmountContainer() {
    return Container(
      padding: EdgeInsets.all(10),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          RichText(
            text: TextSpan(style: TextStyle(fontSize: 18), children: [
              TextSpan(
                  text: "*",
                  style: TextStyle(color: Colors.red, fontSize: 15)),
              TextSpan(
                  text: "退款金额",
                  style: TextStyle(color: Colors.black, fontSize: 15)),

            ]),
            textDirection: TextDirection.ltr,
          ),
          Container(
              width: ApplicationUtils.width,
              child: Text("￥${myOrderModel.order.totalFee}")),
        ],
      ),
    );
  }

  String sendProduct = "";

  Widget sendStatus(Order order) {
    if (order.orderStatus == 1) {
      sendProduct = "0";
      return Text("未发货");
    } else if (order.orderStatus == 2) {
      sendProduct = "1";
      return Text("已发货");
    } else {
      return Text("");
    }
  }

  RefundReason refundReason = new RefundReason();

  Widget refundReasonContainer() {
    return InkWell(
      onTap: () {
        showBottomDialog();
      },
      child: Container(
        padding: EdgeInsets.all(10),
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            RichText(
              text: TextSpan(style: TextStyle(fontSize: 18), children: [
                TextSpan(
                    text: "*",
                    style: TextStyle(color: Colors.red, fontSize: 15)),
                TextSpan(
                    text: "退款原因",
                    style: TextStyle(color: Colors.black, fontSize: 15)),

              ]),
              textDirection: TextDirection.ltr,
            ),
            Container(width: ApplicationUtils.width,
              child: Row(
                children: <Widget>[
                  Text(refundReason.content ?? ""),
                  Expanded(flex: 1, child: Container(),),
                  new Icon(Icons.keyboard_arrow_down),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


  var nickNameCon = new TextEditingController();
  var phoneCon = new TextEditingController();
  var remark = new TextEditingController();

  Widget nickNameContainer() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          RichText(
            text: TextSpan(style: TextStyle(fontSize: 18), children: [
              TextSpan(
                  text: "*",
                  style: TextStyle(color: Colors.red, fontSize: 15)),
              TextSpan(
                  text: "联系人",
                  style: TextStyle(color: Colors.black, fontSize: 15)),

            ]),
            textDirection: TextDirection.ltr,
          ),
          Container(
            width: ApplicationUtils.width,
            child: TextField(

              enableInteractiveSelection: false,
              controller: nickNameCon,
              decoration:
              InputDecoration(border: InputBorder.none, hintText: "请输入联系人"),
            ),
          ),
        ],
      ),
    );
  }


  Widget phoneContainer() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          RichText(
            text: TextSpan(style: TextStyle(fontSize: 18), children: [
              TextSpan(
                  text: "*",
                  style: TextStyle(color: Colors.red, fontSize: 15)),
              TextSpan(
                  text: "联系电话",
                  style: TextStyle(color: Colors.black, fontSize: 15)),

            ]),
            textDirection: TextDirection.ltr,
          ),
          Container(
            width: ApplicationUtils.width,
            child: TextField(
              enableInteractiveSelection: false,
              controller: phoneCon,
              decoration:
              InputDecoration(border: InputBorder.none, hintText: "请输入联系人电话"),
            ),
          ),
        ],
      ),
    );
  }


  Widget remarkContainer() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          RichText(
            text: TextSpan(style: TextStyle(fontSize: 18), children: [
              TextSpan(
                  text: "退款说明",
                  style: TextStyle(color: Colors.black, fontSize: 15)),

            ]),
            textDirection: TextDirection.ltr,
          ),
          Container(
            width: ApplicationUtils.width,
            child: TextField(
              enableInteractiveSelection: false,
              //maxLength: 60,
              maxLines: 2,
              controller: remark,
              decoration:
              InputDecoration(border: InputBorder.none, hintText: "请输入退款说明"),
            ),
          ),
        ],
      ),
    );
  }


//  Widget remarkContainer(TextEditingController controller, String hint) {
//    return Container(
//      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
//      color: Colors.white,
//      child: TextField(
//        maxLines: 3,
//        maxLength: 60,
//        controller: controller,
//        decoration:
//        InputDecoration(border: InputBorder.none, hintText: hint),
//      ),
//    );
//  }

  void showBottomDialog() {
    getRefundReasonList();

    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 250,
            color: Colors.transparent,
            child: refundReasonList(),
          );
        });
  }

  Widget refundReasonList() {
    return list.length == 0
        ? new Center(child: new CircularProgressIndicator())
        : ListView.builder(
        itemCount: list.length,
        itemBuilder: (context, index) {
          RefundReason refundReason = list[index];
          return ListTile(
            title: Text(refundReason.content),
            onTap: () {
              setState(() {
                Navigator.pop(context);
                this.refundReason = refundReason;
              });
            },
          );
        });
  }

  void _showDialog(BuildContext cxt) {
    showCupertinoModalPopup<int>(
        context: cxt,
        builder: (cxt) {
          var dialog = CupertinoActionSheet(
            cancelButton: CupertinoActionSheetAction(
                onPressed: () {
                  Navigator.pop(cxt, 0);
                },
                child: Text("取消")),
            actions: <Widget>[
              CupertinoActionSheetAction(
                  onPressed: () async {
                    var image =
                    await ImagePicker.pickImage(source: ImageSource.camera);
                    if (image != null) {
                      File croppedFile = await ImageCropper.cropImage(
                          sourcePath: image.path,
                          aspectRatioPresets: [CropAspectRatioPreset.square]);
                      API.uploadWxFile(croppedFile).then((value) async {
                        setState(() {
                          imageCameraList.add(value);
                        });
                      });
                    }
                    Navigator.of(cxt).pop();
                    ApplicationUtils.showLoading(context);
                  },
                  child: Text('相机')),
              CupertinoActionSheetAction(
                  onPressed: () async {
                    var image = await ImagePicker.pickImage(
                        source: ImageSource.gallery);
                    //没有选择图片或者没有拍照
                    if (image != null) {
                      File croppedFile = await ImageCropper.cropImage(
                          sourcePath: image.path,
                          aspectRatioPresets: [CropAspectRatioPreset.square]);
                      API.uploadWxFile(croppedFile).then((value) async {
                        setState(() {
                          imageCameraList.add(value);
                        });
                      });
                    }
                    Navigator.of(cxt).pop();
                    ApplicationUtils.showLoading(context);
                  },
                  child: Text('相册')),
            ],
          );
          return dialog;
        });
  }

  Widget cameraImage() {
    return Container(
      height: 100,
      color: Colors.white,
      padding: EdgeInsets.all(5),
      child: Row(
        children: <Widget>[
          imageCameraWidgetList(),
          imageCameraList.length != 3
              ? Container(height: 80, child: InkWell(
            child: Image.asset("assets/images/camera.png"),
            onTap: () {
              _showDialog(context);
            },
          ),)
              : Container(),
        ],
      ),
    );
  }

  Widget createCameraImageItem(ImageCamera imageCamera, int index) {
    return Offstage(
      offstage: false, //这里控制
      child: Container(
        width: 100,
          padding: EdgeInsets.all(2),
          child: Stack(
            children: <Widget>[
              Align(
                child: Container(width: 75,height: 80,
                  child: InkWell(child: Image.network(imageCamera.url), onTap: () {
                    Navigator.of(context).push(NinePicture(imageUrls, index));
                  },),
                ),
                alignment: Alignment.center,
              ),
              Align(
                child: GestureDetector(child: Icon(Icons.cancel,size: 20,),onTap: (){
                  setState(() {
                    imageCameraList.removeAt(index);
                  });
                },),
                alignment: Alignment.topRight,

              ),

            ],
          )),
    );
  }

//  Widget createCameraImageItem(ImageCamera imageCamera, int index) {
//    return Offstage(
//      offstage: false, //这里控制
//      child: Container(
//          width: 100,
//          height: 100,
//          padding: EdgeInsets.all(2),
//          child: Stack(
//            children: <Widget>[
//              Container(
//                width: 50,
//                height: 50,
//                child: Align(
//                  child: InkWell(child: Image.network(imageCamera.url), onTap: () {
//                    Navigator.of(context).push(NinePicture(imageUrls, index));
//                  },),
//                  alignment: Alignment.centerLeft,
//
//                ),
//              ),
//              Container(
//                child: GestureDetector(
//                  onTap: () {
//                    setState(() {
//                      imageCameraList.removeAt(index);
//                    });
//                  },
//                  child: Align(
//                    child: Icon(Icons.cancel,size: 20,),
//                    alignment: Alignment.topRight,
//
//                  ),
//                ),
//              ),
//
//            ],
//          )),
//    );
//  }


  List<ImageCamera> imageCameraList = [];
  List<String> imageUrls = [];

  Widget imageCameraWidgetList() {
    List<Widget> list = [];
    imageUrls.clear();
    for (int i = 0; i < imageCameraList.length; i++) {
      list.add(createCameraImageItem(imageCameraList[i], i));
      imageUrls.add(imageCameraList[i].url);
    }
    return Row(
      children: list,
    );
  }

  void enterRefund() {
    String picIdsTemp = "";
    var picIds;
    if (imageCameraList.length >= 1) {
      for (int i = 0; i < imageCameraList.length; i++) {
        picIdsTemp += "${imageCameraList[i].id},";
      }
      picIds = picIdsTemp.substring(0, picIdsTemp.length - 1);
    }

    ApplicationUtils.showLoading(context, time: 1);
    API.orderRefundAppApplyRefund(
        myOrderModel.order.orderNo,
        refundReason.type,
        remark.text,
        nickNameCon.text,
        phoneCon.text,
        picIds)
        .then((value) {
      if (value["data"]) {
        Fluttertoast.showToast(msg: value["msg"]);
        if(isToNotice){
          Navigator.of(context).popUntil(ModalRoute.withName(Routes.noticeListPage));
        }else{
          Navigator.of(context).popUntil(ModalRoute.withName(Routes.myOrder));
        }

      } else {
        Fluttertoast.showToast(msg: value["msg"]);

      }
    });
  }
}
