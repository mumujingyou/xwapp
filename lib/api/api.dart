import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xingwang_project/Model/addressModelList.dart';
import 'package:xingwang_project/Model/imageCamera.dart';
import 'package:xingwang_project/Model/myOrder.dart';
import 'package:xingwang_project/Model/noticeModel.dart';
import 'package:xingwang_project/Model/orderProductVo.dart';
import 'package:xingwang_project/Model/productModel.dart';
import 'package:xingwang_project/Model/productType.dart';
import 'package:xingwang_project/Model/province.dart';
import 'package:xingwang_project/Model/receiptModel.dart';
import 'package:xingwang_project/Model/refunDetailModel.dart';
import 'package:xingwang_project/Model/refundReason.dart';
import 'package:xingwang_project/Model/shoppingCarModel.dart';
import 'package:xingwang_project/Model/stockProductModel.dart';
import 'package:xingwang_project/Model/userModel.dart';
import 'package:xingwang_project/Model/weChatPay.dart';
import 'package:xingwang_project/Utils/printUtil.dart';

class API {
  static String signa = "";

  static UserModel userModel=new UserModel();
  static String address = "http://xwsingle.piggogo.cn/api/";

  static String loginUrl = address + "login";
  static String changePassWordUrl = address + "changePassword";
  static String changeHeadImg = address + "changeHeadImg";

  static String productType=address+"productType/getList";
  static String productPage=address+"product/getPageList";
  static String productDetail=address+"product/getProductInfo";
  static String productDetailImageUrl=address+"product/getProductBannerPics";
  static String addressList=address+"deliveryAddress/list";
  static String deleteAddressUrl=address+"deliveryAddress/remove";
  static String editAddressUrl=address+"deliveryAddress/edit";
  static String addAddressUrl=address+"deliveryAddress/add";
  static String getProvinceUrl=address+"areas/getProvinceList";
  static String getCityUrl=address+"areas/getCityList";
  static String getDistrictUrl=address+"areas/getDistrictList";
  static String getShoppingCarListUrl=address+"buyCart/getBuyCartList";
  static String addShoppingCarUrl=address+"buyCart/createOrChangeBuyCart";
  static String addShoppingCarOneCountUrl=address+"buyCart/addCart";
  static String decreaseShoppingCarOneCountUrl=address+"buyCart/subtractCart";
  static String editShoppingCarCountUrl=address+"buyCart/mindCart";
  static String deleteShoppingCarUrl=address+"buyCart/remove";
  static String createOrderUrl=address+"order/createOrder";
  static String getOrderPageListUrl=address+"order/getPageList";
  static String orderDetailUrl=address+"order/detail";
  static String orderListBuyerUrl=address+"order/listBuyer";
  static String orderSendOutUrl=address+"order/sendOut";
  static String supplierStockGetPageListUrl=address+"supplierStock/getPageList";
  static String orderRefundAppApplyRefundUrl=address+"refundOrder/appApplyRefund";
  static String uploadWxFileUrl=address+"upload/uploadRefundPic";
  static String selectRefundReasonListUrl=address+"/refundOrder/selectRefundReasonList";
  static String selectRefundOrderByNoUrl=address+"orderRefund/selectRefundOrderByNo";
  static String orderReceiveUrl=address+"order/receipt";
  static String refundDetailUrl=address+"refundOrder/selectRefundOrderByNo";
  static String checkBuyerRefundUrl=address+"refundOrder/handleOrderRefund";
  static String supplierPayAgainUrl=address+"order/supplierPayAgain";
  static String cancelOrderUrl=address+"order/cancel";
  static String appRemindList=address+"appRemind/getPageList";
  static String appAnnulRefundUrl=address+"refundOrder/appAnnulRefund";
  static String addBillSetUrl=address+"billSet/addBillSet";
  static String removeBillSetUrl=address+"billSet/remove";
  static String updateBillSetUrl=address+"billSet/updateBillSet";
  static String getBillSetByIdUrl=address+"billSet/getBillSetById";
  static String getBillSetListUrl=address+"billSet/getBillSetList";
  static String selectBillApplyByOrderNoUrl=address+"billApply/selectBillApplyByOrderNo";






  static Future<Map<String,dynamic>> login(String phone, String password) async {
    Dio dio = new Dio();
    var formData = {
      'username': "$phone",
      "password": "$password",
      "signa": API.signa
    };
    var response = await dio.post(loginUrl, queryParameters: formData);
    print(response);
    if (response.data["code"] == 500) {
      return {"msg":response.data["msg"],"data":false};

    } else {
      Map map = Map<String, dynamic>.from(response.data["data"]);
      print(response.data["data"]);
      userModel = UserModel.fromJson(map);
    return {"msg":response.data["msg"],"data":true};

  }
  }

  static Future<Map<String,dynamic>> changePassWord(String oldPW, String password) async {
    Dio dio = new Dio();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String supplierId = prefs.getString("id");
    var formData = {
      'oldPW': "$oldPW",
      "password": "$password",
      "signa": API.signa,
      "supplierId": supplierId
    };
    var response = await dio.post(changePassWordUrl, queryParameters: formData);
    if (response.data["code"] == 0) {
      return {"msg":response.data["msg"],"data":true};
    } else {
      return {"msg":response.data["msg"],"data":false};
    }
  }

  static Future<String> changeAvatar(File file) async {
    Dio dio = new Dio();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String supplierId = prefs.getString("id");

    FormData formData = FormData.fromMap({
      "file": await MultipartFile.fromFile(file.path),
      "supplierId": supplierId,
      "signa": API.signa,
    });
    print(formData.toString());
    print(file.path);

    var response = await dio.post(changeHeadImg, data: formData);
    print(response.data.toString());
    if (response.data["code"] == 0) {
      return response.data["data"];
    } else {
      return "";
    }
  }

  static Future<List<ProductType>> getProductType() async {
    Dio dio = new Dio();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String supplierId = prefs.getString("id");
    var formData = {'supplierId': supplierId, "signa": API.signa};
    var response = await dio.post(productType, queryParameters: formData);
    if (response.data["code"] == 500) {
      //错误
      return null;
    } else {
      Map map = Map<String, dynamic>.from(response.data);
      return ProductTypeOut.fromJson(map).data;
    }
  }

  static Future<ProductList> getProductPage(String type, int start) async {
    Dio dio = new Dio();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String supplierId = prefs.getString("id");
    var formData = {
      'supplierId': supplierId,
      "signa": API.signa,
      "type": type,
      "start": start,
      "length": 10
    };
    var response = await dio.post(productPage, queryParameters: formData);
    if (response.data["code"] == 500) {
      //错误
      return null;
    } else {
      Map map = Map<String, dynamic>.from(response.data["data"]);
      return ProductList.fromJson(map);
    }
  }

  static Future<ProductModel> getProductDetail(String id) async {
    Dio dio = new Dio();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String supplierId = prefs.getString("id");
    var formData = {'supplierId': supplierId, "signa": API.signa, "id": id};
    print(formData);
    var response = await dio.post(productDetail, queryParameters: formData);
    print(response);
    if (response.data["code"] == 500) {
      //错误
      return null;
    } else {
      Map map = Map<String, dynamic>.from(response.data["data"]);
      return new ProductModel.fromJson(map);
    }
  }

  static Future<List<String>> getProductDetailImageUrl(String id) async {
    Dio dio = new Dio();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String supplierId = prefs.getString("id");
    var formData = {'supplierId': supplierId, "signa": API.signa, "id": id};
    var response =
        await dio.post(productDetailImageUrl, queryParameters: formData);
    if (response.data["code"] == 500) {
      //错误
      return null;

    }else{

      List<String> list=[];
      List<dynamic> dataList=response.data["data"];
      for(int i=0;i<dataList.length;i++){
        list.add(dataList[i]["path"]);

      }
      return list;
    }
  }

  //获得地址列表
  static Future<List<AddressModel>> getAddressList() async {
    Dio dio = new Dio();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String supplierId = prefs.getString("id");
    var formData = {
      'supplierId': supplierId,
      "signa": API.signa,
    };
    var response = await dio.post(addressList, queryParameters: formData);
    if (response.data["code"] == 500) {
      //错误
      return null;
    } else {
      Map map = Map<String, dynamic>.from(response.data);
      return AddressModelList.fromJson(map).data;
    }
  }

  //取得默认地址
  static Future<AddressModel> getDefaultAddress() async {
    Dio dio = new Dio();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String supplierId = prefs.getString("id");
    var formData = {
      'supplierId': supplierId,
      "signa": API.signa,
    };
    var response = await dio.post(addressList, queryParameters: formData);
    if (response.data["code"] == 500) {
      //错误
      return null;
    } else {
      Map map = Map<String, dynamic>.from(response.data);
      List<AddressModel> list = AddressModelList.fromJson(map).data;
      for (int i = 0; i < list.length; i++) {
        if (list[i].defaultStatus == 1) {
          return list[i];
        }
      }
    }
    return null;
  }

  static Future<Map<String,dynamic>> deleteAddress(String id) async {
    Dio dio = new Dio();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String supplierId = prefs.getString("id");
    var formData = {'supplierId': supplierId, "signa": API.signa, "id": id};
    var response = await dio.post(deleteAddressUrl, queryParameters: formData);
    if (response.data["code"] == 500) {
      //错误
      return {"msg":response.data["msg"],"data":false};
    } else {
      return {"msg":response.data["msg"],"data":true};
    }
  }

  //新增收货地址
  static Future<Map<String,dynamic>> addAddress(
      AddressModel addressModel, int province, int city, int district) async {
    Dio dio = new Dio();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String supplierId = prefs.getString("id");
    var formData = {
      'supplierId': supplierId,
      "signa": API.signa,
      "province": province,
      "city": city,
      "district": district,
      "address": addressModel.address,
      "phone": addressModel.phone,
      "nickName": addressModel.nickName,
      "defaultStatus": addressModel.defaultStatus
    };

    var response = await dio.post(addAddressUrl, queryParameters: formData);
    if (response.data["code"] == 500) {
      //错误
      return {"msg":response.data["msg"],"data":false};

    } else {
      return {"msg":response.data["msg"],"data":true};

    }
  }

  //编辑收货地址
  static Future<Map<String,dynamic>> editAddress(
      AddressModel addressModel, int province, int city, int district) async {
    Dio dio = new Dio();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String supplierId = prefs.getString("id");
    var formData = {
      'supplierId': supplierId,
      "signa": API.signa,
      "id": addressModel.id,
      "province": province,
      "city": city,
      "district": district,
      "address": addressModel.address,
      "phone": addressModel.phone,
      "nickName": addressModel.nickName,
      "defaultStatus": addressModel.defaultStatus
    };
    var response = await dio.post(editAddressUrl, queryParameters: formData);
    if (response.data["code"] == 500) {
      //错误
      return {"msg":response.data["msg"],"data":false};

    } else {
      return {"msg":response.data["msg"],"data":true};

    }
  }

  static Future<int> getProvince(String provinceStr) async {
    Dio dio = new Dio();

    var response = await dio.post(
      getProvinceUrl,
    );
    if (response.data["code"] == 500) {
      //错误
      return -1;
    } else {
      Map map = Map<String, dynamic>.from(response.data);
      List<dynamic> list = map["data"];
      for (int i = 0; i < list.length; i++) {
        ProvinceCityModel provinceModel = ProvinceCityModel.fromJson(list[i]);
        if (provinceModel.areaName == provinceStr) {
          return provinceModel.areaId;
        }
      }
      return -1;
    }
  }

  static Future<int> getCity(String cityStr, int parentId) async {
    Dio dio = new Dio();
    var formData = {
      'parentId': parentId,
    };

    var response = await dio.post(getCityUrl, queryParameters: formData);
    if (response.data["code"] == 500) {
      //错误
      return -1;
    } else {
      Map map = Map<String, dynamic>.from(response.data);
      List<dynamic> list = map["data"];
      for (int i = 0; i < list.length; i++) {
        ProvinceCityModel cityModel = ProvinceCityModel.fromJson(list[i]);
        if (cityModel.areaName == cityStr) {
          return cityModel.areaId;
        }
      }
      return -1;
    }
  }

  static Future<int> getDistrict(String districtStr, int parentId) async {
    Dio dio = new Dio();
    var formData = {
      'parentId': parentId,
    };

    var response = await dio.post(getDistrictUrl, queryParameters: formData);
    if (response.data["code"] == 500) {
      //错误
      return -1;
    } else {
      Map map = Map<String, dynamic>.from(response.data);
      List<dynamic> list = map["data"];
      for (int i = 0; i < list.length; i++) {
        ProvinceCityModel cityModel = ProvinceCityModel.fromJson(list[i]);
        if (cityModel.areaName == districtStr) {
          return cityModel.areaId;
        }
      }
      return -1;
    }
  }

  static Future<List<ShoppingCarModel>> getShoppingCarList() async {
    Dio dio = new Dio();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String supplierId = prefs.getString("id");
    var formData = {
      'supplierId': supplierId,
      "signa": API.signa,
    };
    var response =
        await dio.post(getShoppingCarListUrl, queryParameters: formData);
    print(response);
    if (response.data["code"] == 500) {
      //错误
      return null;
    } else {
      List<dynamic> dataLists = response.data["data"];
      List<ShoppingCarModel> list = [];
      for (int i = 0; i < dataLists.length; i++) {
        ShoppingCarModel shoppingCarModel =
            ShoppingCarModel.fromJson(dataLists[i]);
        list.add(shoppingCarModel);
      }
      return list;
    }
  }

  static Future<Map<String,dynamic>> addShoppingCar(String productId, int number) async {
    Dio dio = new Dio();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String supplierId = prefs.getString("id");
    var formData = {'supplierId': supplierId, "signa": API.signa,"productId":productId,"number":number};
    print(formData.toString());
    var response = await dio.post(
        addShoppingCarUrl, queryParameters: formData);
    print(response.data.toString());
    if (response.data["code"] == 500) { //错误
      return {"msg":response.data["msg"],"data":false};
    } else {
      return {"msg":response.data["msg"],"data":true};

    }
  }

  static Future<Map<String,dynamic>> addShoppingCarOneCount(String id) async {
    Dio dio = new Dio();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String supplierId = prefs.getString("id");
    var formData = {'supplierId': supplierId, "signa": API.signa, "id": id};
    var response =
        await dio.post(addShoppingCarOneCountUrl, queryParameters: formData);
    if (response.data["code"] == 500) {
      //错误
      return {"msg":response.data["msg"],"data":false};

    } else {
      return {"msg":response.data["msg"],"data":true};

    }
  }

  static Future<Map<String,dynamic>> decreaseShoppingCarOneCount(String id) async {
    Dio dio = new Dio();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String supplierId = prefs.getString("id");
    var formData = {'supplierId': supplierId, "signa": API.signa, "id": id};
    var response = await dio.post(decreaseShoppingCarOneCountUrl,
        queryParameters: formData);
    if (response.data["code"] == 500) {
      //错误
      return {"msg":response.data["msg"],"data":false};

    } else {
      return {"msg":response.data["msg"],"data":true};

    }
  }

  static Future<Map<String,dynamic>> editShoppingCarCount(String id, int number) async {
    Dio dio = new Dio();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String supplierId = prefs.getString("id");
    var formData = {
      'supplierId': supplierId,
      "signa": API.signa,
      "id": id,
      "number": number
    };
    var response =
        await dio.post(editShoppingCarCountUrl, queryParameters: formData);
    if (response.data["code"] == 500) {
      //错误
      return {"msg":response.data["msg"],"data":false};

    } else {
      return {"msg":response.data["msg"],"data":true};

    }
  }

  static Future<Map<String,dynamic>> deleteShoppingCar(
    String id,
  ) async {
    Dio dio = new Dio();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String supplierId = prefs.getString("id");
    var formData = {
      'supplierId': supplierId,
      "signa": API.signa,
      "id": id,
    };
    var response =
        await dio.post(deleteShoppingCarUrl, queryParameters: formData);
    if (response.data["code"] == 0) {
      //错误
      return {"msg":response.data["msg"],"data":true};

    } else {
      return {"msg":response.data["msg"],"data":false};

    }
  }

  //代理商下单
  static Future<Map<String,dynamic>> createOrder(
      String remark, String address, List<OrderProductVo> list,String billSetId) async {
    Dio dio = new Dio();
    dio.options.contentType = ContentType.parse('application/json').toString();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String supplierId = prefs.getString("id");
    var formData = {
      'supplierId': supplierId,
      "signa": API.signa,
      "remark": remark,
      "address": address,
      "list": list,
      "billSetId": billSetId

    };
    var response = await dio.post(createOrderUrl, data: formData);
    print(response);
    if (response.data["code"] == 0) {
      //成功
      dynamic json = response.data["data"];
      return {"msg":WeChatPay.fromJson(json),"data":true};

    } else {
      return {"msg":response.data["msg"],"data":false};

    }
  }

  static Future<OrderClass> getOrderPageList(int start) async {
    Dio dio = new Dio();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String supplierId = prefs.getString("id");
    var formData = {
      'relationId': supplierId,
      "signa": API.signa,
      "start": start,
      "length": 10,
    };
    var response =
        await dio.post(getOrderPageListUrl, queryParameters: formData);

    print(response);
    if (response.data["code"] == 0) {
      List<dynamic> dynamicList = response.data["data"]["data"];
      List<OrderModel> list = [];
      for (int i = 0; i < dynamicList.length; i++) {
        Order order = Order.fromJson(dynamicList[i]["order"]);
        List<dynamic> orderProductDynamicList = dynamicList[i]["list"];
        List<OrderProduct> orderProductList = [];
        for (int j = 0; j < orderProductDynamicList.length; j++) {
          OrderProduct orderProduct =
              OrderProduct.fromJson(orderProductDynamicList[j]);
          orderProductList.add(orderProduct);
        }
        OrderModel myOrderModel =
            new OrderModel(order: order, orderProductList: orderProductList);
        list.add(myOrderModel);
      }

      OrderClass myOrder = new OrderClass(
          total: response.data["data"]["total"], myOrderModelLists: list);
      return myOrder;
    } else {
      return null;
    }
  }

  //获得订单详情
  static Future<OrderModel> orderDetail(String id) async {
//TODO
    Dio dio = new Dio();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String supplierId = prefs.getString("id");
    var formData = {
      'supplierId': supplierId,
      "signa": API.signa,
      "id": id,
    };
    var response = await dio.post(orderDetailUrl, queryParameters: formData);
    if (response.data["code"] == 0) {
      Order order=Order.fromJson(response.data["data"]["data"]["order"]);
      List<OrderProduct> list=[];
      List<dynamic> listDynamic=response.data["data"]["data"]["list"];
      for(int i=0;i<listDynamic.length;i++){
        list.add(OrderProduct.fromJson(listDynamic[i]));
      }
      OrderModel orderModel=new OrderModel(order: order,orderProductList: list);
      return orderModel;
    } else {
      return null;
    }
  }

  //买家订单列表
  static Future<OrderClass> getBuyerOrderList(int start) async {
    Dio dio = new Dio();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String supplierId = prefs.getString("id");
    var formData = {
      'supplierId': supplierId,
      "signa": API.signa,
      "start": start,
      "length": 10,
    };
    var response = await dio.post(orderListBuyerUrl, queryParameters: formData);
    print(response);
    if (response.data["code"] == 0) {
      List<dynamic> dynamicList = response.data["data"]["data"];
      List<OrderModel> list = [];
      for (int i = 0; i < dynamicList.length; i++) {
        Order order = Order.fromJson(dynamicList[i]["order"]);
        List<dynamic> orderProductDynamicList = dynamicList[i]["list"];
        List<OrderProduct> orderProductList = [];
        for (int j = 0; j < orderProductDynamicList.length; j++) {
          OrderProduct orderProduct =
              OrderProduct.fromJson(orderProductDynamicList[j]);
          orderProductList.add(orderProduct);
        }
        OrderModel myOrderModel =
            new OrderModel(order: order, orderProductList: orderProductList);
        list.add(myOrderModel);
      }

      OrderClass myOrder = new OrderClass(
          total: response.data["data"]["total"], myOrderModelLists: list);
      return myOrder;
    } else {
      return null;
    }
  }

  //买家订单发货
  static Future<Map<String,dynamic>> orderSendOut(String id) async {
//TODO
    Dio dio = new Dio();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String supplierId = prefs.getString("id");
    var formData = {
      'supplierId': supplierId,
      "signa": API.signa,
      "id": id,
    };
    var response = await dio.post(orderSendOutUrl, queryParameters: formData);
    print(response);
    if (response.data["code"] == 0) {
      return {"msg":response.data["msg"],"data":true};

    } else {
      return {"msg":response.data["msg"],"data":false};

    }
  }

  //代理商库存列表
  static Future<StockProduct> supplierStockGetPageList(int start) async {
//TODO
    Dio dio = new Dio();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String supplierId = prefs.getString("id");
    var formData = {
      'supplierId': supplierId,
      "signa": API.signa,
      "start": start,
      "length": 10,
    };
    var response =
        await dio.post(supplierStockGetPageListUrl, queryParameters: formData);
    print(response);
    if (response.data["code"] == 0) {
      List<StockProductModel> list = [];
      List<dynamic> dynamicList = response.data["data"]["data"];
      int total = response.data["data"]["total"];
      for (int i = 0; i < dynamicList.length; i++) {
        Map map = dynamicList[i];
        StockProductModel stockProductModel = StockProductModel.fromJson(map);
        list.add(stockProductModel);
      }
      StockProduct stockProduct = new StockProduct(total: total, list: list);
      return stockProduct;
    } else {
      return null;
    }
  }

  //我的订单申请退款
  static Future<Map<String,dynamic>> orderRefundAppApplyRefund(
      String orderNo,
      int refundReason,
      String remarks,
      String nickName,
      String phone,
      String picIds) async {
//TODO
    Dio dio = new Dio();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String supplierId = prefs.getString("id");
    var formData = {
      'supplierId': supplierId,
      "signa": API.signa,
      "orderNo": orderNo,
      "refundReason": refundReason,
      "remarks": remarks,
      "nickName": nickName,
      "phone": phone,
      "picIds": picIds
    };
    var response =
        await dio.post(orderRefundAppApplyRefundUrl, queryParameters: formData);
    print(response);
    if (response.data["code"] == 0) {
      return {"msg":response.data["msg"],"data":true};
    } else {
      return {"msg":response.data["msg"],"data":false};
    }
  }

  //上传图片
  static Future<ImageCamera> uploadWxFile(File file) async {
    Dio dio = new Dio();
    FormData formData = FormData.fromMap({
      "file": await MultipartFile.fromFile(file.path),
    });

    var response = await dio.post(uploadWxFileUrl, data: formData);
    print(response);
    if (response.data["code"] == 0) {
      ImageCamera imageCamera = new ImageCamera(
          offstage: false,
          url: response.data["data"]["path"],
          id: response.data["data"]["id"]);
      return imageCamera;
    } else {
      return null;
    }
  }

  //退款理由列表
  static Future<List<RefundReason>> selectRefundReasonList(
      String sendProduct) async {
//TODO
    Dio dio = new Dio();
    var formData = {
      'sendProduct': sendProduct,
    };
    var response =
        await dio.post(selectRefundReasonListUrl, queryParameters: formData);
    if (response.data["code"] == 0) {
      List<dynamic> dynamicList = response.data["data"];
      List<RefundReason> refundReasonList = [];
      for (int i = 0; i < dynamicList.length; i++) {
        RefundReason refundReason = RefundReason.fromJson(dynamicList[i]);
        refundReasonList.add(refundReason);
      }

      return refundReasonList;
    } else {
      return null;
    }
  }

  //确认收货
  static Future<Map<String,dynamic>> orderReceive(String id) async {
    Dio dio = new Dio();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String supplierId = prefs.getString("id");
    var formData = {
      'supplierId': supplierId,
      "signa": API.signa,
      "id": id,
    };
    var response = await dio.post(orderReceiveUrl, queryParameters: formData);
    if (response.data["code"] == 0) {
      return {"msg":response.data["msg"],"data":true};

    } else {
      return {"msg":response.data["msg"],"data":false};

    }
  }

  //获取订单退款信息
  static Future<RefundDetailModel> getRefundDetail(String orderNo) async {
    Dio dio = new Dio();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String supplierId = prefs.getString("id");
    var formData = {
      'supplierId': supplierId,
      "signa": API.signa,
      "orderNo": orderNo,
    };
    var response = await dio.post(refundDetailUrl, queryParameters: formData);
    print(response);
    if (response.data["code"] == 0) {
      dynamic json = response.data["data"];
      RefundDetailModel refundDetailModel = RefundDetailModel.fromJson(json);
      return refundDetailModel;
    } else {
      return null;
    }
  }

  //处理买家订单退款
  static Future<Map<String,dynamic>> checkBuyerRefund(
      String id, String refundStatus, String firmRemarks) async {
    Dio dio = new Dio();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String supplierId = prefs.getString("id");
    var formData = {
      'supplierId': supplierId,
      "signa": API.signa,
      "id": id,
      "refundStatus": refundStatus,
      "firmRemarks": firmRemarks
    };
    var response =
        await dio.post(checkBuyerRefundUrl, queryParameters: formData);
    print(response);
    if (response.data["code"] == 0) {
      return {"msg":response.data["msg"],"data":true};
    } else {
      return {"msg":response.data["msg"],"data":false};
    }
  }

  //代理商重新支付
  static Future<WeChatPay> supplierPayAgain(String id) async {
    Dio dio = new Dio();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String supplierId = prefs.getString("id");
    var formData = {
      'supplierId': supplierId,
      "signa": API.signa,
      "id": id,
    };
    var response =
        await dio.post(supplierPayAgainUrl, queryParameters: formData);
    if (response.data["code"] == 0) {
      //成功
      dynamic json = response.data["data"];
      return WeChatPay.fromJson(json);
    } else {
      return null;
    }
  }

  static Future<Map<String,dynamic>> cancelOrder(String id,) async {
    Dio dio = new Dio();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String supplierId = prefs.getString("id");
    var formData = {
      'supplierId': supplierId,
      "signa": API.signa,
      "id": id,
    };
    var response = await dio.post(cancelOrderUrl, queryParameters: formData);
    if (response.data["code"] == 0) {
      return {"msg":response.data["msg"],"data":true};

    } else {
      return {"msg":response.data["msg"],"data":false};

    }
  }



  //获取消息列表
  static Future<NoticeList> getAppRemindList(int start) async {
    Dio dio = new Dio();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String supplierId = prefs.getString("id");
    var formData = {
      'supplierId': supplierId,
      "signa": API.signa,
      "start": start,
      "length": 10
    };
    var response = await dio.post(appRemindList, queryParameters: formData);
//    print(response);
    PrintUtil.showLargeLog(response.toString(), 250);
    if (response.data["code"] == 0) {
      List<dynamic> dynamicList = response.data["data"]["data"];
      List<NoticeModel> list=[];
      for(int i=0;i<dynamicList.length;i++){
        list.add(NoticeModel.fromJson(dynamicList[i]));
      }
      NoticeList noticeList=new NoticeList(total: response.data["data"]["total"],data: list);
      return noticeList;
    } else {
      return null;
    }
  }


  //取消退款申请
  static Future<Map<String,dynamic>> appAnnulRefund(String orderRefundId,) async {
    Dio dio = new Dio();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String supplierId = prefs.getString("id");
    var formData = {
      'supplierId': supplierId,
      "signa": API.signa,
      "orderRefundId": orderRefundId,
    };
    var response = await dio.post(appAnnulRefundUrl, queryParameters: formData);
    if (response.data["code"] == 0) {
      return {"msg":response.data["msg"],"data":true};

    } else {
      return {"msg":response.data["msg"],"data":false};
    }
  }



  //新增发票抬头
  static Future<Map<String,dynamic>> addBillSet(
  {String billType,String name,String taxNo,String unit,String phone,String bank,String acBank,
  String email}) async {
    Dio dio = new Dio();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String supplierId = prefs.getString("id");
    var formData = {
      'supplierId': supplierId,
      "signa": API.signa,
      "name": name,
      "taxNo": taxNo,
      "unit": unit,
      "phone": phone,
      "bank": bank,
      "acBank": acBank,
      "billType": billType,
      "email": email,
    };
    var response = await dio.post(addBillSetUrl, queryParameters: formData);
    print(response);
    if (response.data["code"] == 0) {
      return {"msg":response.data["msg"],"data":true};
    } else {
      return {"msg":response.data["msg"],"data":false};
    }
  }

  //删除发票抬头
  static Future<Map<String,dynamic>> removeBillSet(String id) async {
    Dio dio = new Dio();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String supplierId = prefs.getString("id");
    var formData = {
      'supplierId': supplierId,
      "signa": API.signa,
      "id": id,
    };
    var response = await dio.post(removeBillSetUrl, queryParameters: formData);
    print(response);
    if (response.data["code"] == 0) {
      return {"msg":response.data["msg"],"data":true};

    } else {
      return {"msg":response.data["msg"],"data":false};
    }
  }


  //编辑发票抬头
  static Future<Map<String,dynamic>> updateBillSet(
  {String id,String name,String taxNo,String unit,String phone,String bank,String acBank,String billType,String icCard,
  String email}
      ) async {
    Dio dio = new Dio();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String supplierId = prefs.getString("id");
    var formData = {
      'supplierId': supplierId,
      "signa": API.signa,
      "name": name,
      "taxNo": taxNo,
      "unit": unit,
      "phone": phone,
      "bank": bank,
      "acBank": acBank,
      "billType": billType,
      "id": id,
      "icCard": icCard,
      "email": email,


    };
    var response = await dio.post(updateBillSetUrl, queryParameters: formData);
    if (response.data["code"] == 0) {
      return {"msg":response.data["msg"],"data":true};

    } else {
      return {"msg":response.data["msg"],"data":false};
    }
  }


  //获取发票抬头信息
  static Future<Map<String,dynamic>> getBillSetById(String id) async {
    Dio dio = new Dio();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String supplierId = prefs.getString("id");
    var formData = {
      'supplierId': supplierId,
      "signa": API.signa,
      "id": id,
    };
    var response = await dio.post(getBillSetByIdUrl, queryParameters: formData);
    if (response.data["code"] == 0) {
      Map map=response.data["data"];
      return {"msg":ReceiptModel.fromJson(map),"data":true};
    } else {
      return {"msg":response.data["msg"],"data":false};
    }
  }


  //根据订单编号orderNo查询订单发票抬头
  static Future<Map<String,dynamic>> selectBillApplyByOrderNo(String orderNo) async {
    Dio dio = new Dio();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String supplierId = prefs.getString("id");
    var formData = {
      'supplierId': supplierId,
      "signa": API.signa,
      "orderNo": orderNo,
    };
    var response = await dio.post(selectBillApplyByOrderNoUrl, queryParameters: formData);
    print(response);
    if (response.data["code"] == 0) {
      Map map=response.data["data"];
      return {"msg":ReceiptModel.fromJson(map),"data":true};
    } else {
      return {"msg":response.data["msg"],"data":false};
    }
  }


  //获取发票抬头信息列表
  static Future<Map<String,dynamic>> getBillSetList({String billType}) async {
    Dio dio = new Dio();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String supplierId = prefs.getString("id");
    var formData = {
      'supplierId': supplierId,
      "signa": API.signa,
      "billType":billType,

    };
    var response = await dio.post(getBillSetListUrl, queryParameters: formData);
    print(response);
    if (response.data["code"] == 0) {
      List<dynamic> dynamicList=response.data["data"];
      List<ReceiptModel> receiptList=[];
      for(int i=0;i<dynamicList.length;i++){
        receiptList.add(ReceiptModel.fromJson(dynamicList[i]));
      }
      return {"msg":receiptList,"data":true};
    } else {
      return {"msg":response.data["msg"],"data":false};
    }
  }

}
