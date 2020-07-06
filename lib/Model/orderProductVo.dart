class OrderProductVo{
  String productId;
  int number;
  OrderProductVo(this.productId, this.number);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['productId'] = this.productId;
    data['number'] = this.number;
    return data;
  }
}