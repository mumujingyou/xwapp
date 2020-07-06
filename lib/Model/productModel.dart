
class ProductList {

  List<ProductModel> data;
  int total=0;

  ProductList({this.data,this.total});

  ProductList.fromJson(Map<String, dynamic> json) {
    if(json["total"]!=null){
      total=json["total"];
    }
    if (json['data'] != null) {
      data = new List<ProductModel>();
      json['data'].forEach((v) {
        data.add(new ProductModel.fromJson(v));
      });
    }
  }
}


class ProductModel {
  String id;
  String proNo;
  String proName;
  String norms;
  String brand;
  String model;
  String unit;
  int repertory;
  double weight;
  String picId;
  double agencyPrice;
  double retailPrice;
  String type;
  String content;
  String remarks;
  int onSale;
  int hotSale;
  int orderNumber;
  String createBy;
  String createTime;
  String updateBy;
  String updateTime;
  int delFlag;
  //String url;

  ProductModel(
      {this.id,
        this.proNo,
        this.proName,
        this.norms,
        this.brand,
        this.model,
        this.unit,
        this.repertory,
        this.weight,
        this.picId,
        this.agencyPrice,
        this.retailPrice,
        this.type,
        this.content,
        this.remarks,
        this.onSale,
        this.hotSale,
        this.orderNumber,
        this.createBy,
        this.createTime,
        this.updateBy,
        this.updateTime,
        this.delFlag,
        //this.url,
        });

  ProductModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    proNo = json['proNo'];
    proName = json['proName'];
    norms = json['norms'];
    brand = json['brand'];
    model = json['model'];
    unit = json['unit'];
    repertory = json['repertory'];
    weight = json['weight'];
    picId = json['picId'];
    agencyPrice = json['agencyPrice'];
    retailPrice = json['retailPrice'];
    type = json['type'];
    content = json['content'];
    remarks = json['remarks'];
    onSale = json['onSale'];
    hotSale = json['hotSale'];
    orderNumber = json['orderNumber'];
    createBy = json['createBy'];
    createTime = json['createTime'];
    updateBy = json['updateBy'];
    updateTime = json['updateTime'];
    delFlag = json['delFlag'];
    //url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['proNo'] = this.proNo;
    data['proName'] = this.proName;
    data['norms'] = this.norms;
    data['brand'] = this.brand;
    data['model'] = this.model;
    data['unit'] = this.unit;
    data['repertory'] = this.repertory;
    data['weight'] = this.weight;
    data['picId'] = this.picId;
    data['agencyPrice'] = this.agencyPrice;
    data['retailPrice'] = this.retailPrice;
    data['type'] = this.type;
    data['content'] = this.content;
    data['remarks'] = this.remarks;
    data['onSale'] = this.onSale;
    data['hotSale'] = this.hotSale;
    data['orderNumber'] = this.orderNumber;
    data['createBy'] = this.createBy;
    data['createTime'] = this.createTime;
    data['updateBy'] = this.updateBy;
    data['updateTime'] = this.updateTime;
    data['delFlag'] = this.delFlag;
    //data['url'] = this.url;
    return data;
  }
}