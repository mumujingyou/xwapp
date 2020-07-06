import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:xingwang_project/Model/myOrder.dart';
import 'package:xingwang_project/Model/refunDetailModel.dart';
import 'package:xingwang_project/Model/refundReason.dart';
import 'package:xingwang_project/Utils/PictureLooking.dart';
import 'package:xingwang_project/Utils/application.dart';
import 'package:xingwang_project/api/api.dart';
import 'package:xingwang_project/components/myBanYuanButton.dart';

class CheckBuyerRefundPage extends StatefulWidget {
  final OrderModel orderModel;
  final bool isCanPop;

  const CheckBuyerRefundPage({Key key, this.orderModel, this.isCanPop = true})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return CheckBuyerRefundPageState();
  }
}

class CheckBuyerRefundPageState extends State<CheckBuyerRefundPage> {
  OrderModel orderModel;
  bool isCanPop;
  List<RefundReason> refundList = [];
  RefundDetailModel refundDetailModel;

  @override
  void initState() {
    orderModel = widget.orderModel;
    isCanPop = widget.isCanPop;
    getRefundDetail();
    super.initState();
  }

  void getRefundReasonList() async {
    sendProduct = "${refundDetailModel.sendProduct}";

    API.selectRefundReasonList(sendProduct).then((value) {
      setState(() {
        refundList = value;
      });
    });
  }

  String title = "";

  void getRefundDetail() async {
    API.getRefundDetail(orderModel.order.orderNo).then((value) {
      setState(() {
        refundDetailModel = value;
        if (refundDetailModel.refundStatus == 0) {
          title = "审批退款详情";
        } else {
          title = "买家退款详情";
        }
        getPicIds();
        getRefundReasonList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: TextStyle(fontSize: 25),
        ),
        centerTitle: true,
        backgroundColor: ApplicationUtils.appBarColor,
      ),
      backgroundColor: Colors.grey[200],
      //body: Container(),

      body: refundDetailModel == null
          ? new Center(child: new CircularProgressIndicator())
          : ListView(
        children: <Widget>[
          getListWidget(orderModel.orderProductList),
          SizedBox(
            height: 2,
          ),
          refundAmountContainer(),
          SizedBox(
            height: 2,
          ),
          sendStatusContainer(),
          SizedBox(
            height: 2,
          ),
          refundReasonContainer(),
          SizedBox(
            height: 2,
          ),
          nickNameContainer(),
          SizedBox(
            height: 2,
          ),
          phoneContainer(),
          SizedBox(
            height: 5,
          ),
          buyerRefundRemarks(),
          SizedBox(
            height: 2,
          ),
          mysuggtionContainer(),
          SizedBox(height: 5,),

          cameraImageContainer(),
          SizedBox(
            height: 2,
          ),
          //firmRemarks(firmRemarksCon, "处理说明"),
          remarkContainer(),
          SizedBox(
            height: 5,
          ),

          refundDetailWidget(),
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
        orderProduct.proName,
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
            '合计:￥${orderProduct.price ?? ""}x${orderProduct.proNumber ?? ""}',
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
              child: sendStatus(refundDetailModel)),
        ],
      ),
    );
  }

  String sendProduct = "";

  Widget sendStatus(RefundDetailModel refundDetailModel) {
    return Text(refundDetailModel.sendProduct == 0 ? "未发货" : "已发货");
  }

  Widget refundReasonContainer() {
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
                  text: "退款原因",
                  style: TextStyle(color: Colors.black, fontSize: 15)),

            ]),
            textDirection: TextDirection.ltr,
          ),
          commonText(refundList.length <= 0
              ? ""
              : refundList[refundDetailModel.refundReason - 1].content),
        ],
      ),
    );
  }

  Widget commonText(String refundReason) {
    return Container(width: ApplicationUtils.width, child: Text(refundReason));
  }

  Widget nickNameContainer() {
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
                  text: "联系人",
                  style: TextStyle(color: Colors.black, fontSize: 15)),

            ]),
            textDirection: TextDirection.ltr,
          ),
          commonText(refundDetailModel.nickName),
        ],
      ),
    );
  }


  Widget phoneContainer() {
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
                  text: "联系电话",
                  style: TextStyle(color: Colors.black, fontSize: 15)),

            ]),
            textDirection: TextDirection.ltr,
          ),
          commonText(refundDetailModel.phone),
        ],
      ),
    );
  }

  Widget buyerRefundRemarks() {
//    if (refundDetailModel.remarks == null) {
//      return Container();
//    }
//    return Container(
//      padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
//      color: Colors.white,
//
//      child: RichText(
//        text: TextSpan(style: TextStyle(fontSize: 18), children: [
//          TextSpan(
//              text: "买家退款说明：",
//              style: TextStyle(color: Colors.red, fontSize: 17)),
//          TextSpan(
//              text: "${refundDetailModel.remarks}",
//              style: TextStyle(fontSize: 17, color: Colors.grey[600])),
//        ]),
//        textDirection: TextDirection.ltr,
//      ),);
    if (refundDetailModel.remarks == null) {
      return Container();
    }
    return Container(
      padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
      color: Colors.white,

      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          RichText(
            text: TextSpan(style: TextStyle(fontSize: 18), children: [
              TextSpan(
                  text: "买家退款说明",
                  style: TextStyle(color: Colors.red,fontSize: 15)),
//          TextSpan(
//              text: "${refundDetailModel.remarks}",
//              style: TextStyle(fontSize: 17, color: Colors.grey[600])),
            ]),
            textDirection: TextDirection.ltr,
          ),
          commonText("${refundDetailModel.remarks}"),

        ],
      ),);

  }

  Widget mysuggtionContainer() {
//    if (refundDetailModel.refundStatus == 0) {
//      return Container();
//    } else {
//      if (refundDetailModel.firmRemarks == null) return Container();
//      return Container(
//        padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
//        color: Colors.white,
//
//        child: RichText(
//          text: TextSpan(style: TextStyle(fontSize: 18), children: [
//            TextSpan(
//                text: "我的处理说明：",
//                style: TextStyle(color: Colors.blue, fontSize: 17)),
//            TextSpan(
//                text: "${refundDetailModel.firmRemarks}",
//                style: TextStyle(fontSize: 17, color: Colors.grey[600])),
//          ]),
//          textDirection: TextDirection.ltr,
//        ),);
//    }

    if (refundDetailModel.firmRemarks == null) {
      return Container();
    }
    return Container(
      padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
      color: Colors.white,

      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          RichText(
            text: TextSpan(style: TextStyle(fontSize: 18), children: [
              TextSpan(
                  text: "我的处理说明",
                  style: TextStyle(color: Colors.blue,fontSize: 15)),
//          TextSpan(
//              text: "${refundDetailModel.remarks}",
//              style: TextStyle(fontSize: 17, color: Colors.grey[600])),
            ]),
            textDirection: TextDirection.ltr,
          ),
          commonText("${refundDetailModel.firmRemarks}"),

        ],
      ),);
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
          commonText("￥${refundDetailModel.refundFee}"),
        ],
      ),
    );
  }

  var firmRemarksCon = new TextEditingController();

  Widget firmRemarks(TextEditingController controller, String hint,
      {int maxLines = 3}) {
    return refundDetailModel.refundStatus == 0
        ? Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
          color: Colors.white,
          child: TextField(
            enableInteractiveSelection: false,
            maxLength: 60,
            controller: controller,
            maxLines: maxLines,
            decoration:
            InputDecoration(border: InputBorder.none, hintText: hint),
          ),
        ),
        Divider(
          height: 1.0,
          color: Colors.grey[200],
        ),
      ],
    )
        : Container();
  }


  Widget remarkContainer() {
    return refundDetailModel.refundStatus == 0?Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          RichText(
            text: TextSpan(style: TextStyle(fontSize: 18), children: [
              TextSpan(
                  text: "处理说明",
                  style: TextStyle(color: Colors.black, fontSize: 15)),

            ]),
            textDirection: TextDirection.ltr,
          ),
          Container(
            width: ApplicationUtils.width,
            child: TextField(
              enableInteractiveSelection: false,
             // maxLength: 60,
              maxLines: 2,
              controller: firmRemarksCon,
              decoration:
              InputDecoration(border: InputBorder.none, hintText: "请输入处理说明"),
            ),
          ),
        ],
      ),
    ):Container();
  }


  Widget cameraImageContainer() {
    if (picIds == "") {
      return Container();
    } else {
      return Container(
        height: 100,
        color: Colors.white,
        padding: EdgeInsets.all(10),
        child: Row(
          children: imageCameraWidgetList(),
        ),
      );
    }
  }

  List<String> picIdList = [];

  List<Widget> imageCameraWidgetList() {
    List<Widget> list = [];
    for (int i = 0; i < picIdList.length; i++) {
      list.add(InkWell(
          onTap: () {
            Navigator.of(context).push(NinePicture(picIdList, i));
          },
          child: Container(
              padding: EdgeInsets.all(2), child: Image.network(picIdList[i]))));
    }
    print("${list.length}   =====");
    return list;
  }

  Widget refundDetailWidget() {
    if (refundDetailModel.refundStatus == 0) {
      return agreeOrRefuseRow(); //发起退货申请
    } else if (refundDetailModel.refundStatus == 1) {
      return Container();
    } else if (refundDetailModel.refundStatus == 2) {
      return Container();
    } else if (refundDetailModel.refundStatus == 3) {
      return Container();
    } else {
      return Container();
    }
  }

  Widget agreeOrRefuseRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        MyBanYuanButton(
          string: "同意退款",
          width: 120,
          height: 40,
          function: () {
            ApplicationUtils.showLoadingBool(context, () async {
              Map result = await API.checkBuyerRefund(
                  refundDetailModel.id, "1", firmRemarksCon.text);
              if (result["data"]) {
                Fluttertoast.showToast(msg: result["msg"]);
                Navigator.pop(context);
                return true;
              } else {
                Fluttertoast.showToast(msg: result["msg"]);
                return false;
              }
            });
          },
          fontSize: 20,
          color: Colors.green,
        ),
        MyBanYuanButton(
          string: "拒绝退款",
          width: 120,
          height: 40,
          function: () {
            ApplicationUtils.showLoadingBool(context, () async {
              Map result = await API.checkBuyerRefund(
                  refundDetailModel.id, "2", firmRemarksCon.text);
              if (result["data"]) {
                Fluttertoast.showToast(msg: result["msg"]);
                Navigator.pop(context);
                return true;
              } else {
                Fluttertoast.showToast(msg: result["msg"]);
                return false;
              }
            });
          },
          fontSize: 20,
        ),
      ],
    );
  }

  String picIds = "";

  //获取图片
  void getPicIds() {
    picIds = refundDetailModel.picIds;
    picIdList = picIds.split(",");
  }
}
