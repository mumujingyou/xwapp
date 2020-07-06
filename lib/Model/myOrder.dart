class Order {
  String id;
  int relationType;
  String relationId;
  String orderNo;
  String remarkBody;
  String feeType;
  double totalFee;
  String tradeType;
  String payTime;
  String createTime;
  String updateTime;
  String remark;
  String address;
  String phone;
  String nickName;
  int orderStatus;
  String transactionId;
  String supplierId;
  String orderRefundId;
  int refundStatus;
  int timeRemain;
  Order(
      {this.id,
        this.relationType,
        this.relationId,
        this.orderNo,
        this.remarkBody,
        this.feeType,
        this.totalFee,
        this.tradeType,
        this.payTime,
        this.createTime,
        this.updateTime,
        this.remark,
        this.address,
        this.phone,
        this.nickName,
        this.orderStatus,
        this.transactionId,
        this.supplierId,
        this.orderRefundId,
        this.refundStatus,
        this.timeRemain});

  Order.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    relationType = json['relationType'];
    relationId = json['relationId'];
    orderNo = json['orderNo'];
    remarkBody = json['remarkBody'];
    feeType = json['feeType'];
    totalFee = json['totalFee'];
    tradeType = json['tradeType'];
    payTime = json['payTime'];
    createTime = json['createTime'];
    updateTime = json['updateTime'];
    remark = json['remark'];
    address = json['address'];
    phone = json['phone'];
    nickName = json['nickName'];
    orderStatus = json['orderStatus'];
    transactionId = json['transactionId'];
    supplierId = json['supplierId'];
    orderRefundId = json['orderRefundId'];
    refundStatus = json['refundStatus'];
    timeRemain=json['timeRemain'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['relationType'] = this.relationType;
    data['relationId'] = this.relationId;
    data['orderNo'] = this.orderNo;
    data['remarkBody'] = this.remarkBody;
    data['feeType'] = this.feeType;
    data['totalFee'] = this.totalFee;
    data['tradeType'] = this.tradeType;
    data['payTime'] = this.payTime;
    data['createTime'] = this.createTime;
    data['updateTime'] = this.updateTime;
    data['remark'] = this.remark;
    data['address'] = this.address;
    data['phone'] = this.phone;
    data['nickName'] = this.nickName;
    data['orderStatus'] = this.orderStatus;
    data['transactionId'] = this.transactionId;
    data['supplierId'] = this.supplierId;
    data['orderRefundId'] = this.orderRefundId;
    data['refundStatus'] = this.refundStatus;
    data['timeRemain']=this.timeRemain;
    return data;
  }
}

class OrderProduct {
  String id;
  String oderId;
  String productId;
  int proNumber;
  double price;
  double totalPrice;
  String proNo;
  String proName;
  String norms;
  String brand;
  String model;
  String unit;
  double weight;
  String picId;
  String createTime;

  OrderProduct(
      {this.id,
        this.oderId,
        this.productId,
        this.proNumber,
        this.price,
        this.totalPrice,
        this.proNo,
        this.proName,
        this.norms,
        this.brand,
        this.model,
        this.unit,
        this.weight,
        this.picId,
        this.createTime});

  OrderProduct.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    oderId = json['oderId'];
    productId = json['productId'];
    proNumber = json['proNumber'];
    price = json['price'];
    totalPrice = json['totalPrice'];
    proNo = json['proNo'];
    proName = json['proName'];
    norms = json['norms'];
    brand = json['brand'];
    model = json['model'];
    unit = json['unit'];
    weight = json['weight'];
    picId = json['picId'];
    createTime = json['createTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['oderId'] = this.oderId;
    data['productId'] = this.productId;
    data['proNumber'] = this.proNumber;
    data['price'] = this.price;
    data['totalPrice'] = this.totalPrice;
    data['proNo'] = this.proNo;
    data['proName'] = this.proName;
    data['norms'] = this.norms;
    data['brand'] = this.brand;
    data['model'] = this.model;
    data['unit'] = this.unit;
    data['weight'] = this.weight;
    data['picId'] = this.picId;
    data['createTime'] = this.createTime;
    return data;
  }
}

//订单模型
class OrderModel{

  Order order;

  List<OrderProduct> orderProductList;

  OrderModel({this.order, this.orderProductList,});

}

class OrderClass{
  int total=0;
  List<OrderModel> myOrderModelLists;

  OrderClass({this.total, this.myOrderModelLists});

}

