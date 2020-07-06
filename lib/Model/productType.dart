class ProductTypeOut {
  String msg;
  int code;
  List<ProductType> data;

  ProductTypeOut({this.msg, this.code, this.data});

  ProductTypeOut.fromJson(Map<String, dynamic> json) {
    msg = json['msg'];
    code = json['code'];
    if (json['data'] != null) {
      data = new List<ProductType>();
      json['data'].forEach((v) {
        data.add(new ProductType.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['msg'] = this.msg;
    data['code'] = this.code;
    if (this.data != null) {
      data['data'] = this.data.map((v) {
        return v.toJson();
      }).toList();
    }
    return data;
  }
}

class ProductType {
  String id;
  String typeNo;
  String typeName;
  int orderNumber;
  String remakes;
  String createBy;
  String createTime;
  String updateBy;
  String updateTime;
  int delFlag;
  String picId;
  String url;

  ProductType(
      {this.id,
        this.typeNo,
        this.typeName,
        this.orderNumber,
        this.remakes,
        this.createBy,
        this.createTime,
        this.updateBy,
        this.updateTime,
        this.delFlag,
        this.picId,
        this.url});

  ProductType.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    typeNo = json['typeNo'];
    typeName = json['typeName'];
    orderNumber = json['orderNumber'];
    remakes = json['remakes'];
    createBy = json['createBy'];
    createTime = json['createTime'];
    updateBy = json['updateBy'];
    updateTime = json['updateTime'];
    delFlag = json['delFlag'];
    picId = json['picId'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['typeNo'] = this.typeNo;
    data['typeName'] = this.typeName;
    data['orderNumber'] = this.orderNumber;
    data['remakes'] = this.remakes;
    data['createBy'] = this.createBy;
    data['createTime'] = this.createTime;
    data['updateBy'] = this.updateBy;
    data['updateTime'] = this.updateTime;
    data['delFlag'] = this.delFlag;
    data['picId'] = this.picId;
    data['url'] = this.url;
    return data;
  }
}