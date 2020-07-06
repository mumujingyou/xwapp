import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:xingwang_project/Model/receiptModel.dart';
import 'package:xingwang_project/Pages/receiptDetail.dart';
import 'package:xingwang_project/Utils/application.dart';
import 'package:xingwang_project/api/api.dart';
import 'package:xingwang_project/routers/application.dart';
import 'package:xingwang_project/routers/routes.dart';
import 'package:flutter_slidable_list_view/flutter_slidable_list_view.dart';
class ReceiptManager extends StatefulWidget {


  @override
  State<StatefulWidget> createState() {
    return ReceiptManagerState();
  }
}

class ReceiptManagerState extends State<ReceiptManager> {
  List<ReceiptModel> lists = [];

  bool isEmpty=false;

  @override
  void initState() {
    getReceiptList();

    super.initState();
  }


  Future getReceiptList() async {
    API.getBillSetList(billType: "").then((value) {
      if (value["data"]) {
        setState(() {
          lists.clear();
          lists.addAll(value["msg"]);
          if (lists.length == 0) {
            isEmpty = true;
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '发票抬头',
          style: TextStyle(fontSize: 25),
        ),
        centerTitle: true,
        backgroundColor: ApplicationUtils.appBarColor,
        actions: <Widget>[
          InkWell(
            onTap: (){
              Application.router.navigateTo(context, "${Routes.addReceiptPage}",
                  transition: TransitionType.fadeIn);
            },
            child: Container(
              padding: const EdgeInsets.all(10.0),
              child: Icon(Icons.add,size: 35,),
            ),
          ),
        ],
      ),
      body:lists.length==0?Center(child: Center(
          child: isEmpty
              ? new Text("亲，您还没有填写地址呢")
              : new CircularProgressIndicator()),): Container(child: getListView(),),

    );
  }

  Widget createReceiptItem(ReceiptModel receiptModel) {
    return InkWell(
      onTap: (){
        Navigator.push(context, new MaterialPageRoute(builder: (context) {
          return ReceiptDetail(
            receiptModel: receiptModel,
          );
        }));
      },
      child: Column(
        children: <Widget>[
          Container(
            color: Colors.white,
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(receiptModel.name,
                  style: TextStyle(fontSize: 20, color: Colors.grey),),
                Icon(Icons.keyboard_arrow_right)
              ],),
          ),
          SizedBox(height: 5,)
        ],
      ),
    );
  }

  Widget addReceipt() {
    return InkWell(
      onTap: () {
        Application.router.navigateTo(context, "${Routes.addReceiptPage}",
            transition: TransitionType.fadeIn);
      },
      child: Container(
        padding: const EdgeInsets.all(8.0),
        color: Colors.white,
        height: 50,
        child: Row(
          children: <Widget>[
            Text(
              "+新增发票抬头", style: TextStyle(color: ApplicationUtils.appBarColor,
                fontSize: 20),),
          ],
        ),
      ),
    );
  }

  Widget getListView(){
    return SlideListView(
      itemBuilder: (bc, index) {
        return GestureDetector(
          child: Container(
            padding: EdgeInsets.all(10),
            child: createReceiptItem(lists[index]),
          ),
          onTap: () {

          },
          behavior: HitTestBehavior.translucent,
        );
      },
      actionWidgetDelegate:
      ActionWidgetDelegate(1, (actionIndex, listIndex) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[Icon(Icons.delete,color: Colors.white,), Text('删除',style: TextStyle(color: Colors.white),)],
        );
      }, (int indexInList, int index, BaseSlideItem item) {
        //deleteReceipt(lists[index],item);
        item.remove();
        //print(lists.length);
        print(lists[indexInList].name);
        API.removeBillSet(lists[indexInList].id);
      }, [Colors.redAccent]),
      dataList: lists,
      refreshCallback: () async {
        await Future.delayed(Duration(seconds: 1),(){

        });
        return;
      },
    );
  }


  @override
  void deactivate() {
    var bool = ModalRoute
        .of(context)
        .isCurrent;
    if (bool) {
      lists.clear();

      getReceiptList();
    }
    super.deactivate();
  }


}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  List<int> data = List();

  @override
  void initState() {
    super.initState();
    data = List.generate(20, (index) {
      return index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Container(
        child: SlideListView(
          itemBuilder: (bc, index) {
            return GestureDetector(
              child: Container(
                padding: EdgeInsets.all(10),
                child: Row(
                  children: <Widget>[
                    Text('child ${data[index]}'),
                    RaisedButton(
                      child: Text('button ${data[index]}'),
                      onPressed: () {
                        print('button click ${data[index]}');
                      },
                    )
                  ],
                ),
              ),
              onTap: () {
                print('tap ${data[index]}');
              },
              behavior: HitTestBehavior.translucent,
            );
          },
          actionWidgetDelegate:
          ActionWidgetDelegate(2, (actionIndex, listIndex) {
            if (actionIndex == 0) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[Icon(Icons.delete), Text('delete')],
              );
            } else {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  listIndex > 5 ? Icon(Icons.close) : Icon(Icons.adjust),
                  Text('close')
                ],
              );
            }
          }, (int indexInList, int index, BaseSlideItem item) {
            if (index == 0) {
              item.remove();
            } else {
              item.close();
            }
          }, [Colors.redAccent, Colors.blueAccent]),
          dataList: data,
          refreshCallback: () async {
            await Future.delayed(Duration(seconds: 2));
            return;
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

