class RefundDetailModel {
  String id;
  String refundNo;
  String orderNo;
  double totalFee;
  double refundFee;
  String feeType;
  int sendProduct;
  int refundReason;
  String remarks;
  String firmRemarks;
  String nickName;
  String phone;
  int refundStatus;
  String createTime;
  String finishTime;
  String picIds;
  String returnMsg;

  RefundDetailModel(
      {this.id,
        this.refundNo,
        this.orderNo,
        this.totalFee,
        this.refundFee,
        this.feeType,
        this.sendProduct,
        this.refundReason,
        this.remarks,
        this.firmRemarks,
        this.nickName,
        this.phone,
        this.refundStatus,
        this.createTime,
        this.finishTime,
        this.picIds,
        this.returnMsg});

  RefundDetailModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    refundNo = json['refundNo'];
    orderNo = json['orderNo'];
    totalFee = json['totalFee'];
    refundFee = json['refundFee'];
    feeType = json['feeType'];
    sendProduct = json['sendProduct'];
    refundReason = json['refundReason'];
    remarks = json['remarks'];
    firmRemarks = json['firmRemarks'];
    nickName = json['nickName'];
    phone = json['phone'];
    refundStatus = json['refundStatus'];
    createTime = json['createTime'];
    finishTime = json['finishTime'];
    picIds = json['picIds'];
    returnMsg = json['returnMsg'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['refundNo'] = this.refundNo;
    data['orderNo'] = this.orderNo;
    data['totalFee'] = this.totalFee;
    data['refundFee'] = this.refundFee;
    data['feeType'] = this.feeType;
    data['sendProduct'] = this.sendProduct;
    data['refundReason'] = this.refundReason;
    data['remarks'] = this.remarks;
    data['firmRemarks'] = this.firmRemarks;
    data['nickName'] = this.nickName;
    data['phone'] = this.phone;
    data['refundStatus'] = this.refundStatus;
    data['createTime'] = this.createTime;
    data['finishTime'] = this.finishTime;
    data['picIds'] = this.picIds;
    data['returnMsg'] = this.returnMsg;

    return data;
  }
}