class ReceiptModel {
  String id;
  String name;
  String taxNo;
  String unit;
  String phone;
  String bank;
  String acBank;
  int creatorType;
  String creator;
  String createTime;
  String billType;
  String icCard;
  String email;
  String orderNo;


  ReceiptModel(
      {this.id,
        this.name,
        this.taxNo,
        this.unit,
        this.phone,
        this.bank,
        this.acBank,
        this.creatorType,
        this.creator,
        this.createTime,
        this.billType,
        this.icCard,
        this.email,
        this.orderNo});

  ReceiptModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    taxNo = json['taxNo'];
    unit = json['unit'];
    phone = json['phone'];
    bank = json['bank'];
    acBank = json['acBank'];
    creatorType = json['creatorType'];
    creator = json['creator'];
    createTime = json['createTime'];
    billType = json['billType'];
    icCard = json['icCard'];
    email = json['email'];
    orderNo = json['orderNo']??"";

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['taxNo'] = this.taxNo;
    data['unit'] = this.unit;
    data['phone'] = this.phone;
    data['bank'] = this.bank;
    data['acBank'] = this.acBank;
    data['creatorType'] = this.creatorType;
    data['creator'] = this.creator;
    data['createTime'] = this.createTime;
    data['billType'] = this.billType;
    data['icCard'] = this.icCard;
    data['email'] = this.email;
    data["orderNo"]=this.orderNo;
    return data;
  }
}