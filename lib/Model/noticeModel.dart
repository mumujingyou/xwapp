class NoticeModel {
  Null searchValue;
  Null createBy;
  String createTime;
  Null updateBy;
  Null updateTime;
  Null remark;
  var params;
  String id;
  String title;
  String isRead;
  String remindTime;
  String supplierId;
  String orderId;
  String type;

  NoticeModel({this.searchValue, this.createBy, this.createTime, this.updateBy, this.updateTime, this.remark, this.params, this.id, this.title, this.isRead, this.remindTime, this.supplierId, this.orderId, this.type});

  NoticeModel.fromJson(Map<String, dynamic> json) {
    searchValue = json['searchValue'];
    createBy = json['createBy'];
    createTime = json['createTime'];
    updateBy = json['updateBy'];
    updateTime = json['updateTime'];
    remark = json['remark'];
    params = json['params'] != null ? new NoticeModel.fromJson(json['params']) : null;
    id = json['id'];
    title = json['title'];
    isRead = json['isRead'];
    remindTime = json['remindTime'];
    supplierId = json['supplierId'];
    orderId = json['orderId'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['searchValue'] = this.searchValue;
    data['createBy'] = this.createBy;
    data['createTime'] = this.createTime;
    data['updateBy'] = this.updateBy;
    data['updateTime'] = this.updateTime;
    data['remark'] = this.remark;
    if (this.params != null) {
      data['params'] = this.params.toJson();
    }
    data['id'] = this.id;
    data['title'] = this.title;
    data['isRead'] = this.isRead;
    data['remindTime'] = this.remindTime;
    data['supplierId'] = this.supplierId;
    data['orderId'] = this.orderId;
    data['type'] = this.type;
    return data;
  }
}


class NoticeList {

  List<NoticeModel> data;
  int total=0;

  NoticeList({this.data,this.total});

  NoticeList.fromJson(Map<String, dynamic> json) {
    if(json["total"]!=null){
      total=json["total"];
    }
    if (json['data'] != null) {
      data = new List<NoticeModel>();
      json['data'].forEach((v) {
        data.add(new NoticeModel.fromJson(v));
      });
    }
  }
}
