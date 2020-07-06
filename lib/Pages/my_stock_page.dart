import 'package:flutter/material.dart';
import 'package:xingwang_project/Model/stockProductModel.dart';
import 'package:xingwang_project/Utils/application.dart';
import 'package:xingwang_project/api/api.dart';

class MyStockPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyStockPageState();
  }
}

class MyStockPageState extends State<MyStockPage> {
  List<StockProductModel> lists = [];
  TextStyle textStyle = new TextStyle(fontSize: 15, color: Colors.grey[500]);

  int currentPage = -1; //第一页
  int pageSize = 10; //页容量
  int totalSize = 0; //总条数
  String loadMoreText = "没有更多数据";
  TextStyle loadMoreTextStyle =
  new TextStyle(color: const Color(0xFF999999), fontSize: 14.0);
  TextStyle titleStyle =
  new TextStyle(color: const Color(0xFF757575), fontSize: 14.0);

  //初始化滚动监听器，加载更多使用
  ScrollController _controller = new ScrollController();

  MyStockPageState() {
    //固定写法，初始化滚动监听器，加载更多使用
    _controller.addListener(() {
      var maxScroll = _controller.position.maxScrollExtent;
      var pixel = _controller.position.pixels;
      if (maxScroll == pixel && lists.length < totalSize) {
        setState(() {
          loadMoreText = "正在加载中...";
          loadMoreTextStyle =
          new TextStyle(color: const Color(0xFF4483f6), fontSize: 14.0);
        });
        loadMoreData();
      } else {
        setState(() {
          loadMoreText = "没有更多数据";
          loadMoreTextStyle =
          new TextStyle(color: const Color(0xFF999999), fontSize: 14.0);
        });
      }
    });
  }

  bool isEmpty = false;

  //加载列表数据
  loadMoreData() async {
    this.currentPage++;
    int start = currentPage * 10;
    API.supplierStockGetPageList(start).then((value) {
      setState(() {
        lists.addAll(value.list);
        totalSize = value.total;
        if (lists.length == 0) {
          isEmpty = true;
        }
      });
    });
  }

  @override
  void initState() {
    loadMoreData();
    super.initState();
  }

  /**
   * 下拉刷新,必须异步async不然会报错
   */
  Future _pullToRefresh() async {
    currentPage = -1;
    lists.clear();
    loadMoreData();
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            '我的库存',
            style: TextStyle(fontSize: 25),
          ),
          centerTitle: true,
          backgroundColor: ApplicationUtils.appBarColor,
        ),
        backgroundColor: Colors.grey[200],


        body: lists.length == 0
            ? new Center(
            child: isEmpty
                ? new Text("亲，您的库存是空的")
                : new CircularProgressIndicator())
            : new RefreshIndicator(
          color: const Color(0xFF4483f6),
          //下拉刷新
          child: ListView.builder(
            itemCount: lists.length + 1,
            itemBuilder: (context, index) {
              if (index == lists.length) {
                return _buildProgressMoreIndicator();
              } else {
                return createItem(lists, index);
              }
            },
            controller: _controller, //指明控制器加载更多使用
          ),
          onRefresh: _pullToRefresh,
        ));
  }

  /**
   * 加载更多进度条
   */
  Widget _buildProgressMoreIndicator() {
    return new Padding(
      padding: const EdgeInsets.all(15.0),
      child: new Center(
        child: new Text(loadMoreText, style: loadMoreTextStyle),
      ),
    );
  }

  Widget createItem(List<StockProductModel> list, int index) {
    StockProductModel stockProductModel = list[index];
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(5),
      child: Column(
        children: <Widget>[
          createFirstItem(stockProductModel),
          getListWidget(list[index]),
        ],
      ),
    );
  }

  Widget createFirstItem(StockProductModel stockProductModel) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          "商品编号：${stockProductModel.proNo}",
          style: textStyle,
        ),
      ],
    );
  }

  //商品列表项
  Widget _listWidget(StockProductModel stockProductModel) {
    return Container(
      padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(width: 1.0, color: Colors.black12),
          )),
      //水平方向布局
      child: Row(
        children: <Widget>[
          //返回商品图片
          _goodsImage(stockProductModel),
          SizedBox(
            width: 10,
          ),
          //右侧使用垂直布局
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _goodsName(stockProductModel),
                _goodsFunction(stockProductModel),
                _goodsNorms(stockProductModel),
                agencyPrice(stockProductModel),
                retailPrice(stockProductModel),
                stockCount(stockProductModel)
              ],
            ),
          ),
        ],
      ),
    );
  }

  //商品图片
  Widget _goodsImage(StockProductModel stockProductModel) {
    return Container(
      width: 100,
      height: 100,
      child: stockProductModel.picId == null ? new Container(
        child: new CircularProgressIndicator(), padding: EdgeInsets.all(30),) :
      Image.network(
        stockProductModel.picId,
        fit: BoxFit.fitWidth,
      ),
    );
  }

  //商品名称
  Widget _goodsName(StockProductModel stockProductModel) {
    return Container(
      //width: 150,
      child: Text(
        stockProductModel.proName,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: ApplicationUtils.goodListNameTextStyle,
      ),
    );
  }

  //商品功效
  Widget _goodsFunction(StockProductModel stockProductModel,) {
    return Container(
      //width: 150,
      child: Text(
        "品牌：${stockProductModel.brand ?? ""}",
        overflow: TextOverflow.ellipsis,
        style: ApplicationUtils.modelStyle,

      ),
    );
  }

  //商品属性
  Widget _goodsNorms(StockProductModel stockProductModel,) {
    return Container(
      //width: 150,
      child: Text(
        "包装规格：${stockProductModel.norms ?? ""}/${stockProductModel.unit ?? ""}",


        style: ApplicationUtils.modelStyle,

      ),
    );
  }

  //商品价格
  Widget agencyPrice(StockProductModel stockProductModel,) {
    return Container(
      width: 150,
      child: Row(
        children: <Widget>[
          Text(
            '代理价:  ￥${stockProductModel.agencyPrice}',
            style: TextStyle(color: Colors.red),
          ),
        ],
      ),
    );
  }

  //商品价格
  Widget retailPrice(StockProductModel stockProductModel,) {
    return Container(
      width: 150,
      child: Row(
        children: <Widget>[
          Text(
            '零售价:  ￥${stockProductModel.retailPrice}',
            style: TextStyle(color: Colors.red),
          ),
        ],
      ),
    );
  }

  //商品价格
  Widget stockCount(StockProductModel stockProductModel,) {
    return Container(
      width: 150,
      child: Row(
        children: <Widget>[
          Text(
            '库存数:  ${stockProductModel.repertory}',
            style: TextStyle(color: Colors.red),
          ),
        ],
      ),
    );
  }

  Widget getListWidget(StockProductModel item) {
    return Column(
      children: [_listWidget(item)],
    );
  }
}
