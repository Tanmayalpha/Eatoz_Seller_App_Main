import 'dart:convert';

import 'package:eshopmultivendor/Helper/Session.dart';
import 'package:eshopmultivendor/Helper/String.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../Helper/Constant.dart';
import '../../Model/RestaurantListModel.dart';

class RestaurantReport extends StatefulWidget {
  const RestaurantReport({Key? key}) : super(key: key);

  @override
  State<RestaurantReport> createState() => _RestaurantReportState();
}

class _RestaurantReportState extends State<RestaurantReport> {
  RestaurantListModel? restaurantListModell;
  getRestaurantResports() async {
    var headers = {
      'Cookie': 'ci_session=2991faecda9f11bb27075abcabcecdbbcbdf589c'
    };
    var request = http.MultipartRequest(
        'POST', Uri.parse('${baseUrl}get_resturant_report'));
    request.fields.addAll({'seller_id': '${CUR_USERID}'});
    request.headers.addAll(headers);
    print(
        "dddddddddd ${baseUrl}get_resturant_report       and ${request.fields}");
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var finalResult = await response.stream.bytesToString();
      final jsonResponse =
          RestaurantListModel.fromJson(json.decode(finalResult));
      setState(() {
        restaurantListModell = jsonResponse;
      });
    } else {
      print(response.reasonPhrase);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(milliseconds: 300), () {
      return getRestaurantResports();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar("Restaurant Report", context),
      body: Container(
        child: restaurantListModell == null
            ? Center(
                child: CircularProgressIndicator(),
              )
            : restaurantListModell!.rows!.length == 0
                ? Center(
                    child: Text("No data to show"),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    reverse: true,
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 15),
                    physics: AlwaysScrollableScrollPhysics(),
                    itemCount: restaurantListModell!.rows!.length,
                    itemBuilder: (c, i) {
                      return Card(
                        elevation: 1,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "#Order Id",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                      "${restaurantListModell!.rows![i].orderId}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600)),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Order Date",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                      "${restaurantListModell!.rows![i].orderDate}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600)),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              /*Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Restaurant Name",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                      "${restaurantListModell!.rows![i].resturantName}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600)),
                                ],
                              ),*/
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Payment Mode",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                      "${restaurantListModell!.rows![i].paymentMethod}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600)),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Active Status",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                      "${restaurantListModell!.rows![i].activeStatus!.toUpperCase()}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600)),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Total",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                      "\u{20B9}${double.parse(restaurantListModell!.rows![i].total.toString()).toStringAsFixed(2)}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600)),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Restaurant Discount",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                  restaurantListModell!.rows![i]
                                                  .restaurantDiscount ==
                                              null ||
                                          restaurantListModell!.rows![i]
                                                  .restaurantDiscount ==
                                              ""
                                      ? Text("")
                                      : Text(
                                          "\u{20B9}${double.parse(restaurantListModell!.rows![i].restaurantDiscount.toString()).toStringAsFixed(2)}",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600)),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Admin Discount",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                  restaurantListModell!
                                                  .rows![i].adminDiscount ==
                                              null ||
                                          restaurantListModell!
                                                  .rows![i].adminDiscount ==
                                              ""
                                      ? Text("")
                                      : Text(
                                          "\u{20B9}${double.parse(restaurantListModell!.rows![i].adminDiscount.toString()).toStringAsFixed(2)}",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600)),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Net Bill",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                      "\u{20B9}${double.parse(restaurantListModell!.rows![i].netBill.toString()).toStringAsFixed(2)}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600)),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Total Gst",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                      "\u{20B9}${double.parse(restaurantListModell!.rows![i].totalGst.toString()).toStringAsFixed(2)}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600)),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Final Total",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                      "\u{20B9}${double.parse(restaurantListModell!.rows![i].finalTotal.toString()).toStringAsFixed(2)}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600)),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Commission",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                      "\u{20B9}${double.parse(restaurantListModell!.rows![i].finalAdminEarning.toString()).toStringAsFixed(2)}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600)),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Eatoz Fee",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                      " \u{20b9} ${double.parse(restaurantListModell!.rows![i].etozFee.toString()).toStringAsFixed(2)}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600)),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "TDS",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                      "\u{20b9} ${double.parse(restaurantListModell!.rows![i].tds.toString()).toStringAsFixed(2)}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600)),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Net Payable",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                      "\u{20b9} ${restaurantListModell!.rows![i].netPayble}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600)),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              /*Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Date",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                      "${restaurantListModell!.rows![i].dateAdded}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600)),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),*/
                            ],
                          ),
                        ),
                      );
                    }),
      ),
    );
  }
}
