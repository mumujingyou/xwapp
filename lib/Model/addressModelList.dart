class AddressModelList {
  String msg;
  int code;
  List<AddressModel> data;

  AddressModelList({this.msg, this.code, this.data});

  AddressModelList.fromJson(Map<String, dynamic> json) {
    msg = json['msg'];
    code = json['code'];
    if (json['data'] != null) {
      data = new List<AddressModel>();
      json['data'].forEach((v) {
        data.add(new AddressModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['msg'] = this.msg;
    data['code'] = this.code;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AddressModel {
  String id;
  String relationId;
  int relationType;
  int province;
  int city;
  int district;
  String address;
  String phone;
  String nickName;
  int defaultStatus;
  String createTime;
  double latitude;
  double longitude;
  String provinceName;
  String cityName;
  String districtName;

  AddressModel({this.id,
    this.relationId,
    this.relationType,
    this.province,
    this.city,
    this.district,
    this.address,
    this.phone,
    this.nickName,
    this.defaultStatus,
    this.createTime,
    this.latitude,
    this.longitude,
    this.provinceName,
    this.cityName,
    this.districtName});

  AddressModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    relationId = json['relationId'];
    relationType = json['relationType'];
    province = json['province'];
    city = json['city'];
    district = json['district'];
    address = json['address'];
    phone = json['phone'];
    nickName = json['nickName'];
    defaultStatus = json['defaultStatus'];
    createTime = json['createTime'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    provinceName = json['provinceName'];
    cityName = json['cityName'];
    districtName = json['districtName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['relationId'] = this.relationId;
    data['relationType'] = this.relationType;
    data['province'] = this.province;
    data['city'] = this.city;
    data['district'] = this.district;
    data['address'] = this.address;
    data['phone'] = this.phone;
    data['nickName'] = this.nickName;
    data['defaultStatus'] = this.defaultStatus;
    data['createTime'] = this.createTime;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['provinceName'] = this.provinceName;
    data['cityName'] = this.cityName;
    data['districtName'] = this.districtName;
    return data;
  }

}
