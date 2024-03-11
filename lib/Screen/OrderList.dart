import 'dart:async';
import 'dart:convert';
import 'package:eshopmultivendor/Helper/ApiBaseHelper.dart';
import 'package:eshopmultivendor/Helper/AppBtn.dart';
import 'package:eshopmultivendor/Helper/Color.dart';
import 'package:eshopmultivendor/Helper/Constant.dart';
import 'package:eshopmultivendor/Helper/Session.dart';
import 'package:eshopmultivendor/Helper/String.dart';
import 'package:eshopmultivendor/Model/OrdersModel/OrderItemsModel.dart';
import 'package:eshopmultivendor/Model/OrdersModel/OrderModel.dart';
import 'package:eshopmultivendor/Screen/Home.dart';
import 'package:eshopmultivendor/Screen/OrderDetail.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class OrderList extends StatefulWidget {
  @override
  _OrderListState createState() => _OrderListState();
}

class _OrderListState extends State<OrderList> with TickerProviderStateMixin {
  bool _isNetworkAvail = true;
  Animation? buttonSqueezeanimation;
  AnimationController? buttonController;
  String _searchText = "", _lastsearch = "";
  bool? isSearching;
  int scrollOffset = 0;
  ScrollController? scrollController;
  bool scrollLoadmore = true, scrollGettingData = false, scrollNodata = false;
  final TextEditingController _controller = TextEditingController();
  List<Order_Model> orderList = [];
  Icon iconSearch = Icon(
    Icons.search,
    color: primary,
    size: 25,
  );

  Widget? appBarTitle;
  ApiBaseHelper apiBaseHelper = ApiBaseHelper();
  List<Order_Model> tempList = [];
  String? activeStatus;
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();
  String? start, end;

  String? all,
      received,
      processed,
      shipped,
      delivered,
      cancelled,
      returned,
      awaiting;
  List<String> statusList = [
    ALL,
    PLACED,
    PROCESSED,
    SHIPED,
    DELIVERD,
    CANCLED,
    RETURNED,
  ];

  Future<Null> _refresh() async {
    print("refresh is not working here now ");
    return getOrder();
  }

  Future<Null> callApi() async {
    print("get orders is not working here now ");
    getOrder();
  }

  @override
  void initState() {
    scrollOffset = 0;
    Future.delayed(Duration.zero, this.getOrder);
    // getOrder();
    appBarTitle = Text(
      //  getTranslated(context, "ORDER")!,
      "Orders",
      style: TextStyle(color: grad2Color),
    );
    buttonController = new AnimationController(
        duration: new Duration(milliseconds: 2000), vsync: this);
    scrollController = ScrollController(keepScrollOffset: true);
    scrollController!.addListener(_transactionscrollListener);

    buttonSqueezeanimation = new Tween(
      begin: width * 0.7,
      end: 50.0,
    ).animate(
      new CurvedAnimation(
        parent: buttonController!,
        curve: new Interval(
          0.0,
          0.150,
        ),
      ),
    );
    _controller.addListener(() {
      if (_controller.text.isEmpty) {
        if (mounted)
          setState(() {
            _searchText = "";
          });
      } else {
        if (mounted)
          setState(() {
            _searchText = _controller.text;
          });
      }

      if (_lastsearch != _searchText &&
          (_searchText == '' || (_searchText.length > 2))) {
        _lastsearch = _searchText;
        scrollLoadmore = true;
        scrollOffset = 0;
        getOrder();
      }
    });

    super.initState();
  }

  _transactionscrollListener() {
    if (scrollController!.offset >=
        scrollController!.position.maxScrollExtent &&
        !scrollController!.position.outOfRange) {
      if (mounted)
        setState(
              () {
            scrollLoadmore = true;
            getOrder();
          },
        );
    }
  }

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  new GlobalKey<RefreshIndicatorState>();

  updateOrder(String status, String orderId) async {
    var headers = {
      'Cookie': 'ci_session=6d242d3b9be5944614dc38a4046fca54b4cd4096'
    };
    var request = http.MultipartRequest(
        'POST', Uri.parse('${baseUrl}accept_reject_status'));
    request.fields.addAll({'status': '${status}', 'order_id': '${orderId}'});
    print("checking params here ${request.fields}");
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var finalResult = await response.stream.bytesToString();
      final jsonResponse = json.decode(finalResult);
      print("vvvvvv ${jsonResponse['status']}");
      if (jsonResponse['error'] == false) {
        orderList.clear();
        setState(() {
          setSnackbar("${jsonResponse['message']}");
          activeStatus = null;
          scrollLoadmore = true;
          scrollOffset = 0;

          getOrder();
        });

        // Navigator.pop(context);
      } else {
        setState(() {
          setSnackbar("${jsonResponse['message']}");
        });
        _refresh();
        // Navigator.pop(context);
      }
    } else {
      print(response.reasonPhrase);
    }
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: lightWhite,
        appBar: getAppbar(),
        body: _isNetworkAvail ? _showContent() : noInternet(context));
  }

  void _handleSearchStart() {
    if (!mounted) return;
    setState(
          () {
        isSearching = true;
      },
    );
  }

  Future<void> _startDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: startDate,
        firstDate: DateTime(2020, 1),
        lastDate: DateTime.now());
    if (picked != null)
      setState(
            () {
          startDate = picked;
          start = DateFormat('dd-MM-yyyy').format(startDate);

          if (start != null && end != null) {
            scrollLoadmore = true;
            scrollOffset = 0;
            getOrder();
          }
        },
      );
  }

  Future<void> _endDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: startDate,
        firstDate: startDate,
        lastDate: DateTime.now());
    if (picked != null)
      setState(
            () {
          endDate = picked;
          end = DateFormat('dd-MM-yyyy').format(endDate);
          if (start != null && end != null) {
            scrollLoadmore = true;
            scrollOffset = 0;
            getOrder();
          }
        },
      );
  }

  void _handleSearchEnd() {
    if (!mounted) return;
    setState(
          () {
        iconSearch = Icon(
          Icons.search,
          color: primary,
          size: 25,
        );
        appBarTitle = Text(
          getTranslated(context, "ORDER")!,
          style: TextStyle(color: grad2Color),
        );
        isSearching = false;
        _controller.clear();
      },
    );
  }

  Widget noInternet(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            noIntImage(),
            noIntText(context),
            noIntDec(context),
            AppBtn(
              title: getTranslated(context, "NO_INTERNET")!,
              btnAnim: buttonSqueezeanimation,
              btnCntrl: buttonController,
              onBtnSelected: () async {
                _playAnimation();

                Future.delayed(Duration(seconds: 2)).then(
                      (_) async {
                    _isNetworkAvail = await isNetworkAvailable();
                    if (_isNetworkAvail) {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                              super.widget)).then((value) {
                        setState(() {});
                      });
                    } else {
                      await buttonController!.reverse();
                      if (mounted) setState(() {});
                    }
                  },
                );
              },
            )
          ],
        ),
      ),
    );
  }

  AppBar getAppbar() {
    return AppBar(
      title: appBarTitle,
      elevation: 5,
      titleSpacing: 0,
      iconTheme: IconThemeData(color: primary),
      backgroundColor: white,
      leading: Builder(
        builder: (BuildContext context) {
          return Container(
            margin: EdgeInsets.all(10),
            child: InkWell(
              borderRadius: BorderRadius.circular(4),
              onTap: () => Navigator.of(context).pop(),
              child: Center(
                child: Icon(
                  Icons.keyboard_arrow_left,
                  color: primary,
                  size: 30,
                ),
              ),
            ),
          );
        },
      ),
      actions: <Widget>[
        Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          decoration: shadow(),
          child: InkWell(
            borderRadius: BorderRadius.circular(4),
            onTap: () {
              if (!mounted) return;
              setState(() {
                if (iconSearch.icon == Icons.search) {
                  iconSearch = Icon(
                    Icons.close,
                    color: primary,
                    size: 25,
                  );
                  appBarTitle = TextField(
                    controller: _controller,
                    autofocus: true,
                    style: TextStyle(
                      color: primary,
                    ),
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search, color: primary),
                      hintText: getTranslated(context, "Search"),
                      hintStyle: TextStyle(color: primary),
                    ),
                    //  onChanged: searchOperation,
                  );
                  _handleSearchStart();
                } else {
                  _handleSearchEnd();
                }
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: iconSearch,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          decoration: shadow(),
          child: InkWell(
            borderRadius: BorderRadius.circular(4),
            onTap: filterDialog,
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Icon(
                Icons.filter_alt_outlined,
                color: primary,
                size: 25,
              ),
            ),
          ),
        ),
      ],
    );
  }

  _showContent() {
    print("checking order length ${orderList.length}");
    return
      //scrollNodata
      // ? getNoItem(context)
      // :
      NotificationListener<ScrollNotification>(
        // onNotification:
        //     (scrollNotification) {} as bool Function(ScrollNotification)?,
        child: RefreshIndicator(
          onRefresh: _refresh,
          key: _refreshIndicatorKey,
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            controller: scrollController,
            child: Column(
              children: <Widget>[
                _detailHeader(),
                _detailHeader2(),
                _filterRow(),
                orderList.length == 0
                    ? Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Text("No orders to show"),
                  ),
                )
                    : ListView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsetsDirectional.only(
                        bottom: 5, start: 10, end: 10),
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: orderList.length,
                    itemBuilder: (context, index) {
                      Order_Model? item;
                      try {
                        item = orderList.isEmpty ? null : orderList[index];
                        if (scrollLoadmore &&
                            index == (orderList.length - 1) &&
                            scrollController!.position.pixels <= 0) {
                          getOrder();
                        }
                      } on Exception catch (_) {}

                      return item == null ? Container() : orderItem(index);
                    }),
              ],
            ),
          ),
        ),
      );
  }

  _detailHeader() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Card(
              elevation: 0,
              child: InkWell(
                onTap: () {
                  setState(() {
                    activeStatus = null;
                    scrollLoadmore = true;
                    scrollOffset = 0;
                  });

                  getOrder();
                },
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    children: [
                      Icon(
                        Icons.shopping_cart,
                        color: primary,
                      ),
                      Text(
                        getTranslated(context, "ORDER")!,
                        style: Theme.of(context).textTheme.caption!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: grey,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        all ?? "",
                        style: TextStyle(
                          color: black,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Card(
              elevation: 0,
              child: InkWell(
                onTap: () {
                  setState(
                        () {
                      activeStatus = statusList[1];
                      scrollLoadmore = true;
                      scrollOffset = 0;
                    },
                  );
                  _refresh();
                  // getOrder();
                },
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    children: [
                      Icon(
                        Icons.archive,
                        color: primary,
                      ),
                      Text(
                        getTranslated(context, "RECEIVED_LBL")!,
                        style: Theme.of(context).textTheme.caption!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: grey,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        received ?? '',
                        style: TextStyle(
                            color: black, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Card(
              elevation: 0,
              child: InkWell(
                onTap: () {
                  setState(() {
                    activeStatus = statusList[2];
                    scrollLoadmore = true;
                    scrollOffset = 0;
                  });
                  _refresh();
                },
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    children: [
                      Icon(
                        Icons.work,
                        color: primary,
                      ),
                      Text(
                        getTranslated(context, "PROCESSED_LBL")!,
                        style: Theme.of(context).textTheme.caption!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: grey,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        processed ?? "",
                        style: TextStyle(
                            color: black, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Card(
              elevation: 0,
              child: InkWell(
                onTap: () {
                  setState(() {
                    activeStatus = statusList[3];
                    scrollLoadmore = true;
                    scrollOffset = 0;
                  });
                  _refresh();
                },
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    children: [
                      Icon(
                        Icons.airport_shuttle,
                        color: primary,
                      ),
                      Text(
                        getTranslated(context, "SHIPED_LBL")!,
                        style: Theme.of(context).textTheme.caption!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: grey,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        shipped ?? "",
                        style: TextStyle(
                            color: black, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _detailHeader2() {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Card(
            elevation: 0,
            child: InkWell(
              onTap: () {
                setState(() {
                  activeStatus = statusList[4];
                  scrollLoadmore = true;
                  scrollOffset = 0;
                });
                _refresh();
              },
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  children: [
                    Icon(
                      Icons.assignment_turned_in,
                      color: primary,
                    ),
                    Text(
                      getTranslated(context, "DELIVERED_LBL")!,
                      style: Theme.of(context).textTheme.caption!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: grey,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      delivered ?? "",
                      style:
                      TextStyle(color: black, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Card(
            elevation: 0,
            child: InkWell(
              onTap: () {
                setState(
                      () {
                    activeStatus = statusList[5];
                    scrollLoadmore = true;
                    scrollOffset = 0;
                  },
                );
                _refresh();
              },
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  children: [
                    Icon(
                      Icons.cancel,
                      color: primary,
                    ),
                    Text(
                      getTranslated(context, "CANCELLED_LBL")!,
                      style: Theme.of(context).textTheme.caption!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: grey,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      cancelled ?? "",
                      style:
                      TextStyle(color: black, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Card(
            elevation: 0,
            child: InkWell(
              onTap: () {
                setState(() {
                  activeStatus = statusList[6];
                  scrollLoadmore = true;
                  scrollOffset = 0;
                });
                _refresh();
              },
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  children: [
                    Icon(
                      Icons.upload,
                      color: primary,
                    ),
                    Text(
                      getTranslated(context, "RETURNED_LBL")!,
                      style: Theme.of(context).textTheme.caption!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: grey,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      returned ?? "",
                      style:
                      TextStyle(color: black, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  orderItem(int index) {
    Order_Model model = orderList[index];
    Color back;

    if ((model.itemList![0].activeStatus!) == DELIVERD)
      back = Colors.green;
    else if ((model.itemList![0].activeStatus!) == SHIPED)
      back = Colors.orange;
    else if ((model.itemList![0].activeStatus!) == CANCLED ||
        model.itemList![0].activeStatus! == RETURNED)
      back = red;
    else if ((model.itemList![0].activeStatus!) == PROCESSED)
      back = Colors.indigo;
    else if ((model.itemList![0].activeStatus!) == PROCESSED)
      back = Colors.indigo;
    else if (model.itemList![0].activeStatus! == "awaiting")
      back = Colors.black;
    else
      back = Colors.cyan;

    return model.itemList!.isNotEmpty
        ? Card(
      elevation: 0,
      margin: EdgeInsets.all(5.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(4),
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Row(
                      children: [
                        Text(
                          getTranslated(context, "Order_No")! + ".",
                          style: TextStyle(color: grey),
                        ),
                        Text(
                          model.id!,
                          style: TextStyle(color: black),
                        ),
                      ],
                    ),
                    Spacer(),
                    Container(
                      margin: EdgeInsets.only(left: 8),
                      padding: EdgeInsets.symmetric(
                          horizontal: 10, vertical: 2),
                      decoration: BoxDecoration(
                        color: back,
                        borderRadius: new BorderRadius.all(
                          const Radius.circular(
                            4.0,
                          ),
                        ),
                      ),
                      child: model.itemList![0].activeStatus ==
                          "processed"
                          ? Text(
                        "Preparing",
                        style: TextStyle(color: white),
                      )
                          : model.itemList![0].activeStatus == "shipped"
                          ? Text(
                        "Picked Up",
                        style: TextStyle(color: white),
                      )
                          : Text(
                        capitalize(
                            model.itemList![0].activeStatus!),
                        style: TextStyle(color: white),
                      ),
                    )
                  ],
                ),
              ),
              Divider(),
              /*Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5),
                child: Row(
                  children: [
                    Flexible(
                      child: Row(
                        children: [
                          Icon(
                            Icons.person,
                            size: 14,
                            color: secondary,
                          ),
                          Expanded(
                            child: Text(
                              model.name != null && model.name!.length > 0
                                  ? " " + capitalize(model.name!)
                                  : " ",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: black),
                            ),
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      child: Row(
                        children: [
                          Icon(
                            Icons.call,
                            size: 14,
                            color: secondary,
                          ),
                          Text(
                            " " + model.mobile!,
                            style: TextStyle(
                                color: black,
                                decoration: TextDecoration.underline),
                          ),
                        ],
                      ),
                      onTap: () {
                        //  _launchCaller(index);
                      },
                    ),
                  ],
                ),
              ),*/
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 8.0, vertical: 5),
                child: Row(
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.money,
                          size: 14,
                          color: secondary,
                        ),
                        Row(
                          children: [
                            Text(
                              " " +
                                  getTranslated(context, "PayableTXT")! +
                                  ": ",
                              style: TextStyle(color: grey),
                            ),
                            Text(
                              " " + CUR_CURRENCY + " " + model.payable!,
                              style: TextStyle(color: black),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Spacer(),
                    Row(
                      children: [
                        Icon(
                          Icons.payment,
                          size: 14,
                          color: secondary,
                        ),
                        Text(
                          " " + model.payMethod!,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 8.0, vertical: 5),
                child: Row(
                  children: [
                    Icon(
                      Icons.date_range,
                      size: 14,
                      color: secondary,
                    ),
                    Row(
                      children: [
                        Text(
                          " " +
                              getTranslated(context, "ORDER_DATE")! +
                              ": ",
                          style: TextStyle(color: grey),
                        ),
                        Text(
                          model.orderDate!,
                          style: TextStyle(color: black),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 8.0, vertical: 5),
                child: Row(
                  children: [
                    Icon(
                      Icons.watch_later_outlined,
                      size: 14,
                      color: secondary,
                    ),
                    Row(
                      children: [
                        Text(
                          " " + "Order Time" + ": ",
                          style: TextStyle(color: grey),
                        ),
                        Text(
                          model.orderTime!,
                          style: TextStyle(color: black),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              model.itemList![0].activeStatus == "received"
                  ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MaterialButton(
                    minWidth:
                    MediaQuery.of(context).size.width / 2.5,
                    shape: RoundedRectangleBorder(),
                    onPressed: () {
                      updateOrder('processed', model.id.toString());
                    },
                    child: Text(
                      "Accept",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500),
                    ),
                    color: Colors.green,
                  ),
                  MaterialButton(
                    minWidth:
                    MediaQuery.of(context).size.width / 2.5,
                    onPressed: () {
                      updateOrder(
                        'cancelled',
                        model.id.toString(),
                      );
                    },
                    child: Text(
                      "Reject",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500),
                    ),
                    color: Colors.red,
                  ),
                ],
              )
                  : model.itemList![0].activeStatus == "cancelled"
                  ? MaterialButton(
                onPressed: () {},
                child: Text(
                  "Rejected",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500),
                ),
                color: primary,
                minWidth: MediaQuery.of(context).size.width,
              )
                  : MaterialButton(
                onPressed: () {},
                child: Text(
                  "Accepted",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500),
                ),
                color: Colors.green,
                minWidth: MediaQuery.of(context).size.width,
              ),

              // model.deliverTime != "" || model.deliverTime != null
              //     ? Padding(
              //   padding:
              //   const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5),
              //   child: Row(
              //     children: [
              //       Icon(
              //         Icons.assignment_turned_in,
              //         size: 14,
              //         color: secondary,
              //       ),
              //       // Row(
              //       //   children: [
              //       //     Text(
              //       //       " " + "Delivered Time" + ": ",
              //       //       style: TextStyle(color: grey),
              //       //     ),
              //       //   model.deliverTime == null ? Text("") :  Text(
              //       //       model.deliverTime.toString(),
              //       //       style: TextStyle(color: black),
              //       //     ),
              //       //   ],
              //       // ),
              //     ],
              //   ),
              // )
              //     : SizedBox.shrink()
            ],
          ),
        ),
        onTap: () async {
          print("${model.id}");
          /*if (model.itemList![0].activeStatus == "cancelled" ||
                    model.itemList![0].activeStatus == "received") {
                  // setSnackbar("")
                } else {*/
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OrderDetail(
                model: orderList[index],
                id: model.id,
              ),
            ),
          );
          //}
          setState(
                () {
              getOrder();
            },
          );
        },
      ),
    )
        : Container();
  }

  Future<Null> _playAnimation() async {
    try {
      await buttonController!.forward();
    } on TickerCanceled {}
  }

  Future<Null> getOrder() async {
    print("ok new order here");
    if (readOrder) {
      print("read order here");
      _isNetworkAvail = await isNetworkAvailable();
      scrollLoadmore = true;
      if (_isNetworkAvail) {
        if (scrollLoadmore) {
          print("scroll load more");
          if (mounted)
            setState(() {
              scrollLoadmore = false;
              scrollGettingData = true;
              if (scrollOffset == 0) {
                orderList = [];
              }
            });
          CUR_USERID = await getPrefrence(Id);
          CUR_USERNAME = await getPrefrence(Username);

          var parameter = {
            SellerId: CUR_USERID,
            LIMIT: perPage.toString(),
            OFFSET: scrollOffset.toString(),
            SEARCH: _searchText.trim(),
          };
          if (start != null)
            parameter[START_DATE] = "${startDate.toLocal()}".split(' ')[0];
          if (end != null)
            parameter[END_DATE] = "${endDate.toLocal()}".split(' ')[0];
          if (activeStatus != null) {
            if (activeStatus == awaitingPayment) activeStatus = "awaiting";
            parameter[ActiveStatus] = activeStatus!;
          }
          print("checking here ${getOrdersApi} and ${parameter}");
          apiBaseHelper.postAPICall(getOrdersApi, parameter).then(
                (getdata) async {
              bool error = getdata["error"];
              String? msg = getdata["message"];
              scrollGettingData = false;
              if (scrollOffset == 0) scrollNodata = error;

              if (!error) {
                all = getdata["total"];
                received = getdata["received"];
                processed = getdata["processed"];
                shipped = getdata["shipped"];
                delivered = getdata["delivered"];
                cancelled = getdata["cancelled"];
                returned = getdata["returned"];
                awaiting = getdata["awaiting"];
                tempList.clear();
                var data = getdata["data"];
                print("data : $data");
                if (data.length != 0) {
                  tempList = (data as List)
                      .map((data) => new Order_Model.fromJson(data))
                      .toList();
                  print("temp List here ${tempList.length}");
                  // orderList.addAll(tempList);

                  orderList = tempList;
                  print("ooooooooooooo ${orderList.length}");
                  scrollLoadmore = true;
                  scrollOffset = scrollOffset + perPage;
                  print("ooooooooooooo1 ${orderList.length}");
                } else {
                  scrollLoadmore = false;
                }
              } else {
                scrollLoadmore = false;
              }
              if (mounted)
                setState(() {
                  scrollLoadmore = false;
                });
            },
            onError: (error) {
              // setSnackbar(error.toString());
            },
          );
        }
      } else {
        if (mounted)
          setState(
                () {
              _isNetworkAvail = false;
              scrollLoadmore = false;
            },
          );
      }
      return null;
    } else {
      setSnackbar('You have not authorized permission for read order!!');
    }
  }

  void filterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ButtonBarTheme(
          data: ButtonBarThemeData(
            alignment: MainAxisAlignment.center,
          ),
          child: new AlertDialog(
            elevation: 2.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(5.0),
              ),
            ),
            contentPadding: const EdgeInsets.all(0.0),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding:
                    EdgeInsetsDirectional.only(top: 19.0, bottom: 16.0),
                    child: Text(
                      'Filter By',
                      style: Theme.of(context)
                          .textTheme
                          .headline6!
                          .copyWith(color: fontColor),
                    ),
                  ),
                  Divider(color: lightBlack),
                  Flexible(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: getStatusList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  List<Widget> getStatusList() {
    return statusList
        .asMap()
        .map(
          (index, element) => MapEntry(
        index,
        Column(
          children: [
            Container(
              width: double.maxFinite,
              child: TextButton(
                  child: Text(
                      capitalize(
                        statusList[index],
                      ),
                      style: Theme.of(context)
                          .textTheme
                          .subtitle1!
                          .copyWith(color: lightBlack)),
                  onPressed: () {
                    setState(() {
                      activeStatus = index == 0 ? null : statusList[index];
                      scrollLoadmore = true;
                      scrollOffset = 0;
                    });

                    getOrder();

                    Navigator.pop(context, 'option $index');
                  }),
            ),
            Divider(
              color: lightBlack,
              height: 1,
            ),
          ],
        ),
      ),
    )
        .values
        .toList();
  }

  setSnackbar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
      content: new Text(
        msg,
        textAlign: TextAlign.center,
        style: TextStyle(color: black),
      ),
      backgroundColor: white,
      elevation: 1.0,
    ));
  }

  _filterRow() {
    return Row(
      children: [
        Container(
            margin: EdgeInsets.all(10),
            width: MediaQuery.of(context).size.width * .375,
            height: 45,
            child: ElevatedButton(
              onPressed: () => _startDate(context),
              child: Text(
                start == null ? 'Start Date' : start!,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                side: BorderSide(color: primary),
                primary: primary,
                onPrimary: Colors.white,
                onSurface: fontColor,
              ),
            )),
        Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            width: MediaQuery.of(context).size.width * .375,
            height: 45,
            child: ElevatedButton(
              onPressed: () => _endDate(context),
              child: Text(end == null ? 'End Date' : end!),
              style: ElevatedButton.styleFrom(
                primary: primary,
                onPrimary: Colors.white,
                onSurface: Colors.grey,
              ),
            )),
        Expanded(
          child: Container(
            margin: EdgeInsets.all(10),
            height: 45,
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  start = null;
                  end = null;
                  startDate = DateTime.now();
                  endDate = DateTime.now();
                  scrollLoadmore = true;
                  scrollOffset = 0;
                });
                getOrder();
              },
              child: Center(
                child: Icon(Icons.close),
              ),
              style: ElevatedButton.styleFrom(
                primary: primary,
                onPrimary: Colors.white,
                onSurface: Colors.grey,
                padding: EdgeInsets.all(0),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
