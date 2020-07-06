class ShoppingCarModel {
  String id;
  String wechatUserId;
  String productId;
  String supplierId;
  int proNumber;
  String createTime;
  String updateTime;
  String proName;
  String norms;
  String brand;
  String model;
  String unit;
  int repertory;
  double weight;
  String picId;
  double price;
  bool status=false;

  ShoppingCarModel(
      {this.id,
        this.wechatUserId,
        this.productId,
        this.supplierId,
        this.proNumber,
        this.createTime,
        this.updateTime,
        this.proName,
        this.norms,
        this.brand,
        this.model,
        this.unit,
        this.repertory,
        this.weight,
        this.picId,
        this.price});

  ShoppingCarModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    wechatUserId = json['wechatUserId'];
    productId = json['productId'];
    supplierId = json['supplierId'];
    proNumber = json['proNumber'];
    createTime = json['createTime'];
    updateTime = json['updateTime'];
    proName = json['proName'];
    norms = json['norms'];
    brand = json['brand'];
    model = json['model'];
    unit = json['unit'];
    repertory = json['repertory'];
    weight = json['weight'];
    picId = json['picId'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['wechatUserId'] = this.wechatUserId;
    data['productId'] = this.productId;
    data['supplierId'] = this.supplierId;
    data['proNumber'] = this.proNumber;
    data['createTime'] = this.createTime;
    data['updateTime'] = this.updateTime;
    data['proName'] = this.proName;
    data['norms'] = this.norms;
    data['brand'] = this.brand;
    data['model'] = this.model;
    data['unit'] = this.unit;
    data['repertory'] = this.repertory;
    data['weight'] = this.weight;
    data['picId'] = this.picId;
    data['price'] = this.price;
    return data;
  }
}