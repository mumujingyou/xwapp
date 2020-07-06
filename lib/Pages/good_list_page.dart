import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:xingwang_project/Model/productModel.dart';
import 'package:xingwang_project/Pages/main_Page.dart';
import 'package:xingwang_project/Utils/application.dart';
import 'package:xingwang_project/api/api.dart';
import 'package:xingwang_project/routers/application.dart';
import 'package:xingwang_project/routers/routes.dart';

//商品列表页面   //商城列表
class GoodListPage extends StatefulWidget {
  _GoodListPageState createState() => _GoodListPageState();

  final String type;

  const GoodListPage({Key key, this.type}) : super(key: key);
}

class _GoodListPageState extends State<GoodListPage> {
  //初始化数据模型

  List<ProductModel> lists = [];

  //int start=0;

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

  _GoodListPageState() {
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
    API.getProductPage(widget.type, start).then((value) {
      setState(() {
        lists.addAll(value.data);
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

  //商品列表项
  Widget _listWidget(List<ProductModel> newList, int index) {
    return InkWell(
      onTap: () {
        Application.router
            .navigateTo(
          context,
          "${Routes.goodDetailPage}?goodId=${newList[index].id}",
          transition: TransitionType.fadeIn,
        )
            .then((value) {
          if (value == true) {
            MainPageState.instance.refresh(1);
          }
        });
      },
      child: Container(
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
            _goodsImage(newList, index),
            SizedBox(
              width: 10,
            ),
            //右侧使用垂直布局
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _goodsName(newList, index),
                  _goodsFunction(newList, index),
                  _goodsNorms(newList, index),
                  _goodsPrice(newList, index),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  //商品图片
  Widget _goodsImage(List<ProductModel> productModelList, int index) {
    return Container(
      width: 150,
      height: 150,
      child: Image.network(
        productModelList[index].picId,
        fit: BoxFit.fitWidth,
      ),
    );
  }

  //商品名称
  Widget _goodsName(List<ProductModel> productModelList, int index) {
    return Container(
      //width: 150,
      child: Text(
        productModelList[index].proName??"",
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: ApplicationUtils.goodListNameTextStyle,
      ),
    );
  }

  //商品功效
  Widget _goodsFunction(List<ProductModel> productModelList, int index) {
    return Container(
      //width: 150,
      child: Text(
        "品牌：${productModelList[index].brand??""}",
        overflow: TextOverflow.ellipsis,
        style: ApplicationUtils.modelStyle
      ),
    );
  }

  //商品属性
  Widget _goodsNorms(List<ProductModel> productModelList, int index) {
    return Container(
      //width: 150,
      child: Text(
        "包装规格：${productModelList[index].norms??""}/${productModelList[index].unit??""}",

        style: ApplicationUtils.modelStyle
      ),
    );
  }

  //商品价格
  Widget _goodsPrice(List newList, int index) {
    return Container(
      width: 150,
      child: Row(
        children: <Widget>[
          Text(
            '价格:￥${newList[index].agencyPrice??""}',
            style: TextStyle(color: Colors.red),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return lists.length == 0
        ? new Center(
        child: isEmpty
            ? new Text("亲，您的商场列表是空的")
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
            return _listWidget(lists, index);
          }
        },
        controller: _controller, //指明控制器加载更多使用
      ),
      onRefresh: _pullToRefresh,
    );
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
}
