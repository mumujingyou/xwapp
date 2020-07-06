class ProvinceCityModel {
  int areaId;
  String areaCode;
  String areaName;
  int level;
  String cityCode;
  String center;
  int parentId;

  ProvinceCityModel(
      {this.areaId,
        this.areaCode,
        this.areaName,
        this.level,
        this.cityCode,
        this.center,
        this.parentId});

  ProvinceCityModel.fromJson(Map<String, dynamic> json) {
    areaId = json['areaId'];
    areaCode = json['areaCode'];
    areaName = json['areaName'];
    level = json['level'];
    cityCode = json['cityCode'];
    center = json['center'];
    parentId = json['parentId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['areaId'] = this.areaId;
    data['areaCode'] = this.areaCode;
    data['areaName'] = this.areaName;
    data['level'] = this.level;
    data['cityCode'] = this.cityCode;
    data['center'] = this.center;
    data['parentId'] = this.parentId;
    return data;
  }
}


