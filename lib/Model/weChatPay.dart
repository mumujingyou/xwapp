class WeChatPay {
  String appid;
  String partnerid;
  String prepayid;
  String packages;
  String noncestr;
  String timestamp;
  String sign;

  WeChatPay(
      {this.appid,
        this.partnerid,
        this.prepayid,
        this.packages,
        this.noncestr,
        this.timestamp,
        this.sign});

  WeChatPay.fromJson(Map<String, dynamic> json) {
    appid = json['appid'];
    partnerid = json['partnerid'];
    prepayid = json['prepayid'];
    packages = json['packages'];
    noncestr = json['noncestr'];
    timestamp = json['timestamp'];
    sign = json['sign'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['appid'] = this.appid;
    data['partnerid'] = this.partnerid;
    data['prepayid'] = this.prepayid;
    data['packages'] = this.packages;
    data['noncestr'] = this.noncestr;
    data['timestamp'] = this.timestamp;
    data['sign'] = this.sign;
    return data;
  }
}