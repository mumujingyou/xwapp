class UserModelOut {
  String msg;
  int code;
  UserModel data;

  UserModelOut({this.msg, this.code, this.data});

  UserModelOut.fromJson(Map<String, dynamic> json) {
    msg = json['msg'];
    code = json['code'];
    data = json['data'] != null ? new UserModel.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['msg'] = this.msg;
    data['code'] = this.code;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class UserModel {
  String id;
  String supplierNo;
  String phone;
  String passWord;
  String headImg;
  String personName;
  String corporateName;
  String icrNumber;
  String cpAddress;
  int cpProvince;
  int cpCity;
  int cpDistrict;
  String deptAddress;
  int deptCity;
  int deptProvince;
  int deptDistrict;
  String nature;
  String remarks;
  String picId;
  String createBy;
  String updateBy;
  String createTime;
  String updateTime;
  int delFlag;
  String url;
  String deptProvinceName;
  String deptCityName;
  String deptDistrictName;
  String cpProvinceName;
  String cpCityName;
  String cpDistrictName;
  double longitude;
  double latitude;

  UserModel(
      {this.id,
        this.supplierNo,
        this.phone,
        this.passWord,
        this.headImg,
        this.personName,
        this.corporateName,
        this.icrNumber,
        this.cpAddress,
        this.cpProvince,
        this.cpCity,
        this.cpDistrict,
        this.deptAddress,
        this.deptCity,
        this.deptProvince,
        this.deptDistrict,
        this.nature,
        this.remarks,
        this.picId,
        this.createBy,
        this.updateBy,
        this.createTime,
        this.updateTime,
        this.delFlag,
        this.url,
        this.deptProvinceName,
        this.deptCityName,
        this.deptDistrictName,
        this.cpProvinceName,
        this.cpCityName,
        this.cpDistrictName,
        this.longitude,
        this.latitude});

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    supplierNo = json['supplierNo'];
    phone = json['phone'];
    passWord = json['passWord'];
    headImg = json['headImg'];
    personName = json['personName'];
    corporateName = json['corporateName'];
    icrNumber = json['icrNumber'];
    cpAddress = json['cpAddress'];
    cpProvince = json['cpProvince'];
    cpCity = json['cpCity'];
    cpDistrict = json['cpDistrict'];
    deptAddress = json['deptAddress'];
    deptCity = json['deptCity'];
    deptProvince = json['deptProvince'];
    deptDistrict = json['deptDistrict'];
    nature = json['nature'];
    remarks = json['remarks'];
    picId = json['picId'];
    createBy = json['createBy'];
    updateBy = json['updateBy'];
    createTime = json['createTime'];
    updateTime = json['updateTime'];
    delFlag = json['delFlag'];
    url = json['url'];
    deptProvinceName = json['deptProvinceName'];
    deptCityName = json['deptCityName'];
    deptDistrictName = json['deptDistrictName'];
    cpProvinceName = json['cpProvinceName'];
    cpCityName = json['cpCityName'];
    cpDistrictName = json['cpDistrictName'];
    longitude = json['longitude'];
    latitude = json['latitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['supplierNo'] = this.supplierNo;
    data['phone'] = this.phone;
    data['passWord'] = this.passWord;
    data['headImg'] = this.headImg;
    data['personName'] = this.personName;
    data['corporateName'] = this.corporateName;
    data['icrNumber'] = this.icrNumber;
    data['cpAddress'] = this.cpAddress;
    data['cpProvince'] = this.cpProvince;
    data['cpCity'] = this.cpCity;
    data['cpDistrict'] = this.cpDistrict;
    data['deptAddress'] = this.deptAddress;
    data['deptCity'] = this.deptCity;
    data['deptProvince'] = this.deptProvince;
    data['deptDistrict'] = this.deptDistrict;
    data['nature'] = this.nature;
    data['remarks'] = this.remarks;
    data['picId'] = this.picId;
    data['createBy'] = this.createBy;
    data['updateBy'] = this.updateBy;
    data['createTime'] = this.createTime;
    data['updateTime'] = this.updateTime;
    data['delFlag'] = this.delFlag;
    data['url'] = this.url;
    data['deptProvinceName'] = this.deptProvinceName;
    data['deptCityName'] = this.deptCityName;
    data['deptDistrictName'] = this.deptDistrictName;
    data['cpProvinceName'] = this.cpProvinceName;
    data['cpCityName'] = this.cpCityName;
    data['cpDistrictName'] = this.cpDistrictName;
    data['longitude'] = this.longitude;
    data['latitude'] = this.latitude;
    return data;
  }
}