import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:xingwang_project/Model/productModel.dart';
import 'package:xingwang_project/Model/shoppingCarModel.dart';
import 'package:xingwang_project/Pages/createOrder_page.dart';
import 'package:xingwang_project/Utils/application.dart';
import 'package:xingwang_project/api/api.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/dom.dart' as dom;


class GoodDetailPage extends StatefulWidget {
  final String id;

  const GoodDetailPage({Key key, this.id}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return GoodDetailPageState();
  }
}

class GoodDetailPageState extends State<GoodDetailPage> {
  TextStyle style = TextStyle(fontSize: 20, color: Colors.grey);

  ProductModel productModel;
  List<String> imageUrls = [];

  @override
  void initState() {
    super.initState();

    getProductDetail();
  }

  void getProductDetail() async {
    print("widget.id  ${widget.id}");
    API.getProductDetail(widget.id).then((value) {
      setState(() {
        productModel = value;
      });
    });

    API.getProductDetailImageUrl(widget.id).then((value) {
      setState(() {
        imageUrls = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '商品详情',
          style: TextStyle(fontSize: 25),
        ),
        centerTitle: true,
        backgroundColor: ApplicationUtils.appBarColor,
      ),
      body: productModel == null
          ? new Center(child: new CircularProgressIndicator())
          : Column(children: <Widget>[
        Expanded(
          flex: 1,
          child: ListView(
            children: <Widget>[
              _getSwiper(),
              _getTittle(),
              _threeWidget(),
              Container(
                height: 1,
                color: Colors.grey,
              ),
            _getPrice(),
              _getFunction(),
            ],
          ),
        ),
        _getBottomButton(),
      ],),
    );
  }

  Widget _swiperBuilder(BuildContext context, int index) {
    return (Image.network(
      imageUrls[index],
      fit: BoxFit.fill,
    ));
  }

  Widget _getSwiper() {
    return Container(
        width: MediaQuery
            .of(context)
            .size
            .width,
        height: 400.0,
        child: imageUrls.length == 0
            ? new Center(child: new CircularProgressIndicator())
            : Swiper(
          autoplay: true,
          itemBuilder: _swiperBuilder,
          itemCount: imageUrls.length,
          pagination: new SwiperPagination(
              builder: DotSwiperPaginationBuilder(
                color: Colors.white,
                activeColor: ApplicationUtils.appBarColor,
              )),
          control: new SwiperControl(),
          scrollDirection: Axis.horizontal,
          onTap: (index) => print('点击了第$index个'),
        ));
  }

  Widget _getTittle() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        productModel.proName,
        style: ApplicationUtils.goodListNameTextStyle,
      ),
    );
  }

  Widget _threeWidget() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            "运费：包邮",
            style: style,
          ),
          Text(
            "销量：${productModel.hotSale}",
            style: style,
          ),
          Text(
            "库存：${productModel.repertory}",
            style: style,
          ),
        ],
      ),
    );
  }


  Widget _getFunction() {
    String string=productModel.content;
    print(string);
    //RegExp exp = new RegExp("alt=\".+?\"");
    RegExp exp = new RegExp("alt=\".+?\"");

    string=string.replaceAll(exp,"");
    print(string);


    return Html(data: string,
      padding: EdgeInsets.all(8.0),
      linkStyle: const TextStyle(
        color: Colors.redAccent,
      ),
    );
  }

  Widget _getPrice() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        "￥${productModel.agencyPrice}",
        style: TextStyle(fontSize: 20,color: Colors.red),
      ),
    );
  }

  Widget _getBottomButton() {
    double height = 60;
    return Row(
      children: <Widget>[
//        Expanded(
//          flex: 1,
//          child: Container(
//            height: height,
//            decoration:
//            BoxDecoration(border: Border.all(width: 1, color: Colors.grey)),
//            child: Column(
//              mainAxisSize: MainAxisSize.min,
//              mainAxisAlignment: MainAxisAlignment.center,
//              children: <Widget>[
//                Image.asset(
//                  "assets/images/phone.png",
//                  width: 25,
//                ),
//                Text(
//                  "咨询",
//                  style: TextStyle(fontSize: 15, color: Colors.grey),
//                )
//              ],
//            ),
//          ),
//        ),
        Expanded(
          flex: 2,
          child: InkWell(
            onTap: () {
              Navigator.pop(context, true);
            },
            child: Container(
              height: height,
              decoration: BoxDecoration(
                  border: Border(
                      top: BorderSide(width: 1, color: Colors.grey),
                      bottom: BorderSide(width: 1, color: Colors.grey))),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    "assets/images/gouwucheleft.png",
                    width: 25,
                  ),
                  Text(
                    "购物车",
                    style: TextStyle(fontSize: 15, color: Colors.grey),
                  )
                ],
              ),
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: InkWell(
            onTap: () {
              showAlertDialog(context);
            },
            child: Container(
              alignment: Alignment.center,
              height: height,
              color: ApplicationUtils.appBarColor,
              child: Text(
                "加入购物车",
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: InkWell(
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return CreateOrder(list: getShoppingCarModelList());
              }));
            },
            child: Container(
              alignment: Alignment.center,
              height: height,
              color: Colors.red,
              child: Text(
                "立即购买",
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void showAlertDialog(BuildContext context) {
    var countController = TextEditingController();
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            content: TextField(
              enableInteractiveSelection: false,
              decoration: InputDecoration(
                hintText: "请输入个数",
              ),
              controller: countController,
              keyboardType: TextInputType.numberWithOptions(),
              inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
            ),
            title: Center(
                child: Text(
                  '填写个数',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold),
                )),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    API
                        .addShoppingCar(
                        widget.id, int.parse(countController.text))
                        .then((value) {
                      Navigator.of(context).pop();
                      Navigator.of(this.context).pop(true);
                    });
                  },
                  child: Text('确定')),
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('取消')),
            ],
          );
        });
  }

  List<ShoppingCarModel> getShoppingCarModelList() {
    List<ShoppingCarModel> lists = [];
    ShoppingCarModel shoppingCarModel = new ShoppingCarModel(
        proName: productModel.proName,
        brand: productModel.brand,
        norms: productModel.norms,
        price: productModel.agencyPrice,
        picId: productModel.picId,
        unit: productModel.unit,
        proNumber: 1,
        productId: productModel.id);
    lists.add(shoppingCarModel);
    return lists;
  }
}
