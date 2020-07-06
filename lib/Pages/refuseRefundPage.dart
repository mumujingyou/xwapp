import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:xingwang_project/Model/myOrder.dart';
import 'package:xingwang_project/Model/refunDetailModel.dart';
import 'package:xingwang_project/Pages/apply_fefund_page.dart';
import 'package:xingwang_project/Utils/application.dart';
import 'package:xingwang_project/api/api.dart';
import 'package:xingwang_project/components/huxingButton.dart';

class RefuseRefundPage extends StatefulWidget {
  final OrderModel orderModel;
  final bool isToNotice;

  const RefuseRefundPage({Key key, this.orderModel, this.isToNotice=false}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return RefuseRefundPageState();
  }
}

class RefuseRefundPageState extends State<RefuseRefundPage>{

  RefundDetailModel refundDetailModel;
  OrderModel orderModel;
  bool isToNotice=false;

  @override
  void initState() {
    orderModel = widget.orderModel;
    isToNotice=widget.isToNotice;
    getRefundDetail();
    super.initState();
  }

  void getRefundDetail() async {
    API.getRefundDetail(orderModel.order.orderNo).then((value) {
      setState(() {
        refundDetailModel = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            '退款详情',
            style: TextStyle(fontSize: 25),
          ),
          centerTitle: true,
          backgroundColor: ApplicationUtils.appBarColor,
        ),
        backgroundColor: Colors.grey[200],
        body: Column(children: <Widget>[
          refuseText(),
          SizedBox(height: 1,),
          resultText(refundDetailModel?.firmRemarks??""),
          SizedBox(height: 1,),
          editContainer(),
          SizedBox(height: 5,),
          refundFormation(),
          SizedBox(height: 1,),
          productList(orderModel),
        ],)
    );
  }


  Widget refuseText(){
    return Container(
      padding: const EdgeInsets.all(8.0),
      color: Colors.white,
      height: 70,
      child: Row(
        children: <Widget>[
          Text("商家已拒绝退款",style: TextStyle(color: ApplicationUtils.orangeColor,
              fontSize: 22),),
        ],
      ),
    );
  }

  Widget resultText(String result){
    return Container(
      padding: const EdgeInsets.all(8.0),
      color: Colors.white,
      height: 50,
      child: Row(
        children: <Widget>[
          Text("处理结果：$result",style: ApplicationUtils.modelStyle,),
        ],
      ),
    );
  }

  Widget editContainer(){
    return Container(
      padding: const EdgeInsets.all(8.0),
      color: Colors.white,
      child: Column(crossAxisAlignment:CrossAxisAlignment.start,children: <Widget>[

        Text("您可以修改申请后再次发起，商家会重新处理",style:TextStyle(fontSize: 16, color: Colors.grey[500]),),
        SizedBox(height: 20,),
        Row(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
          RefundStatusWidget(string: "取消退款",color:ApplicationUtils.grey,function: cancelRefund,),
          SizedBox(width: 5,),
          RefundStatusWidget(string: "修改申请",color:ApplicationUtils.orangeColor ,function: (){
            Navigator.push(context,
                new MaterialPageRoute(builder: (context) {
                  return ApplyRefundPage(
                    myOrderModel: orderModel,
                    isCanUpdate: true,
                    isToNotice: isToNotice,
                  );
                }));
          },),

        ],),
      ],)
    );
  }

  void cancelRefund(){
    ApplicationUtils.showLoadingBool(context, () async {
      Map result = await API.appAnnulRefund(orderModel.order.orderRefundId);
      if (result["data"]) {
        Fluttertoast.showToast(msg: result["msg"]);

        Navigator.pop(context);
        return true;
      } else {
        Fluttertoast.showToast(msg: result["msg"]);

        return false;
      }
    });
  }




  Widget refundFormation(){
    return Container(
      padding: const EdgeInsets.all(8.0),
      color: Colors.white,
      height: 50,
      child: Row(
        children: <Widget>[
          Text("退款信息",style: ApplicationUtils.modelStyle,),
        ],
      ),
    );
  }


  //商品列表项
  Widget _listWidget(OrderProduct orderProduct, int index,
      OrderModel orderModel) {
    return Container(
      padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(width: 1.0, color: Colors.black12),
          )),
      //水平方向布局
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          //返回商品图片
          _goodsImage(orderProduct),
          SizedBox(
            width: 10,
          ),

          //右侧使用垂直布局
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _goodsName(orderProduct,),
              _goodsModel(orderProduct),
              _goodsNorms(orderProduct),
            ],
          ),
          Expanded(flex: 1, child: Container(),),
          Container(
            child: Column(children: <Widget>[
              _sumAmount(orderProduct),
            ],),
          )
        ],
      ),
    );
  }


  //商品图片
  Widget _goodsImage(OrderProduct orderProduct) {
    return Container(
      width: 100,
      height: 100,
      child: orderProduct.picId == null ? new Container(
        child: new CircularProgressIndicator(), padding: EdgeInsets.all(30),) :
      Image.network(
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
  Widget _goodsModel(OrderProduct orderProduct,) {
    return Container(
      //width: 150,
      child: Text(
        "品牌：${orderProduct.brand ?? ""}",
        overflow: TextOverflow.ellipsis,
        style: ApplicationUtils.modelStyle,
      ),
    );
  }

  //商品属性
  Widget _goodsNorms(OrderProduct orderProduct,) {
    print(orderProduct.norms);
    return Container(
      child: Text(
        "包装规格：${orderProduct.norms ?? ""}/${orderProduct.unit ?? ""}",
        style: ApplicationUtils.modelStyle,
      ),
    );
  }

  //商品价格
  Widget _sumAmount(OrderProduct orderProduct,) {
    return Text(
      '￥${orderProduct.price ?? ""}x\n${orderProduct.proNumber ?? ""}',
      style: ApplicationUtils.priceModel,
      textAlign: TextAlign.right,
    );
  }

  Widget getListWidget(List<OrderProduct> list, OrderModel orderModel) {
    List<Widget> listWidget = [];
    for (int i = 0; i < list.length; i++) {
      OrderProduct orderProduct = list[i];
      //列表项 传入列表数据及索引
      listWidget.add(_listWidget(orderProduct, i, orderModel));
    }
    return Column(
      children: listWidget,
    );
  }

  Widget productList(OrderModel myOrderModel) {
    return Column(
      children: <Widget>[
        InkWell(
          onTap: () {},
          child: Container(
            color: Colors.white,
            padding: EdgeInsets.all(5),
            child: Column(
              children: <Widget>[
                createFirstItem(myOrderModel.order),
                getListWidget(myOrderModel.orderProductList, myOrderModel),
                createBottom(
                    myOrderModel, myOrderModel.orderProductList.length),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 30,
        )
      ],
    );
  }

  Widget createFirstItem(Order order) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          "订单号：${order.orderNo ?? ""}",
          style: ApplicationUtils.modelStyle,
        ),
      ],
    );
  }

  Widget createBottom(OrderModel orderModel, int length) {
    return Container(height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          RichText(
            text: TextSpan(style: TextStyle(fontSize: 18), children: [
              TextSpan(
                  text: "共计", style: ApplicationUtils.modelStyle),
              TextSpan(
                  text: "$length", style: TextStyle(color: Colors.red)),
              TextSpan(
                  text: "件商品", style: ApplicationUtils.modelStyle),
            ]),
            textDirection: TextDirection.ltr,
          ),

          Row(
            children: <Widget>[
              RichText(
                text: TextSpan(style: TextStyle(fontSize: 18), children: [
                  TextSpan(text: "合计:", style: ApplicationUtils.modelStyle),
                  TextSpan(text: "￥${orderModel.order.totalFee}",
                      style: TextStyle(color: Colors.red)),

                ]),
                textDirection: TextDirection.ltr,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

