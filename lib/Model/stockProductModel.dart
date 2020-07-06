class StockProductModel {
  String id;
  String supplierId;
  String proNo;
  String proName;
  String norms;
  String brand;
  String model;
  String unit;
  int repertory;
  double weight;
  double agencyPrice;
  double retailPrice;
  String type;
  String createTime;
  String updateTime;
  String delFlag;
  String picId;

  StockProductModel(
      {this.id,
        this.supplierId,
        this.proNo,
        this.proName,
        this.norms,
        this.brand,
        this.model,
        this.unit,
        this.repertory,
        this.weight,
        this.agencyPrice,
        this.retailPrice,
        this.type,
        this.createTime,
        this.updateTime,
        this.delFlag,
        this.picId});

  StockProductModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    supplierId = json['supplierId'];
    proNo = json['proNo'];
    proName = json['proName'];
    norms = json['norms'];
    brand = json['brand'];
    model = json['model'];
    unit = json['unit'];
    repertory = json['repertory'];
    weight = json['weight'];
    agencyPrice = json['agencyPrice'];
    retailPrice = json['retailPrice'];
    type = json['type'];
    createTime = json['createTime'];
    updateTime = json['updateTime'];
    delFlag = json['delFlag'];
    picId = json['picId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['supplierId'] = this.supplierId;
    data['proNo'] = this.proNo;
    data['proName'] = this.proName;
    data['norms'] = this.norms;
    data['brand'] = this.brand;
    data['model'] = this.model;
    data['unit'] = this.unit;
    data['repertory'] = this.repertory;
    data['weight'] = this.weight;
    data['agencyPrice'] = this.agencyPrice;
    data['retailPrice'] = this.retailPrice;
    data['type'] = this.type;
    data['createTime'] = this.createTime;
    data['updateTime'] = this.updateTime;
    data['delFlag'] = this.delFlag;
    data['picId'] = this.picId;
    return data;
  }
}

class StockProduct{
  int total;
  List<StockProductModel> list;

  StockProduct({this.total, this.list});

}