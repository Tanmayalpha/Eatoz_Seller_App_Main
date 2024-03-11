import 'dart:convert';

import 'package:eshopmultivendor/Helper/Color.dart';
import 'package:eshopmultivendor/Helper/String.dart';
import 'package:eshopmultivendor/Model/salesListModel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../Helper/Constant.dart';
import '../../Helper/Session.dart';

class SalesReport extends StatefulWidget {
  int? i;
  SalesListModel? salesModeldata;

  SalesReport({this.i, this.salesModeldata});

  @override
  State<SalesReport> createState() => _SalesReportState();
}

class _SalesReportState extends State<SalesReport> {
  SalesListModel? salesListModel;

  getSalesLists() async {
    var headers = {
      'Cookie': 'ci_session=2991faecda9f11bb27075abcabcecdbbcbdf589c'
    };
    var request =
        http.MultipartRequest('POST', Uri.parse('${baseUrl}get_sales_list'));
    request.fields.addAll({'seller_id': '${CUR_USERID}'});
    request.headers.addAll(headers);
    print(
        "sales report here now ${baseUrl}get_sales_list   s ${request.fields} ");
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var finalResult = await response.stream.bytesToString();
      final jsonResponse = SalesListModel.fromJson(json.decode(finalResult));
      setState(() {
        salesListModel = jsonResponse;
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
      return getSalesLists();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(
        "Sales Report",
        context,
      ),
      bottomNavigationBar: Container(
        height: 55,
        color: primary,
        width: MediaQuery.of(context).size.width,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              "Grand Total : ",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600),
            ),
            salesListModel == null
                ? SizedBox.shrink()
                : Text(
                    "\u{20B9} ${salesListModel!.grandFinalTotal}",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600),
                  )
          ],
        ),
      ),
      body: Container(
        child: salesListModel == null
            ? Center(
                child: CircularProgressIndicator(),
              )
            : salesListModel!.rows!.length == 0
                ? Center(
                    child: Text("No data to show"),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 15),
                    itemCount: salesListModel!.rows!.length,
                    itemBuilder: (c, i) {
                      return Card(
                        elevation: 1,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Order Id",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                  Text("${salesListModel!.rows![i].orderId}",
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
                                    "Name",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                  Text("${salesListModel!.rows![i].name}",
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
                                  Text("Restaurant Name",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600)),
                                  Text("${salesListModel!.rows![i].storeName}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600)),
                                ],
                              ),*/
                              // SizedBox(
                              //   height: 5,
                              // ),
                              // Row(
                              //   mainAxisAlignment:
                              //       MainAxisAlignment.spaceBetween,
                              //   children: [
                              //     Text("Owner Name",
                              //         style: TextStyle(
                              //             fontWeight: FontWeight.w600)),
                              //     Text("${salesListModel!.rows![i].sellerName}",
                              //         style: TextStyle(
                              //             fontWeight: FontWeight.w600)),
                              //   ],
                              // ),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Discount Price",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600)),
                                  Text(
                                      "\u{20B9}${double.parse(salesListModel!.rows![i].discountedPrice.toString()).toStringAsFixed(2)}",
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
                                  Text("Promo code discount",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600)),
                                  Text(
                                      "\u{20B9}${double.parse(salesListModel!.rows![i].promoDiscount.toString()).toStringAsFixed(2)}",
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
                                  Text("Delivery Charge",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600)),
                                  Text(
                                      "\u{20B9}${double.parse(salesListModel!.rows![i].deliveryCharge.toString()).toStringAsFixed(2)}",
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
                                  Text("Status",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600)),
                                  Text(
                                      "${salesListModel!.rows![i].active_status}",
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
                                  Text("Total GST",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600)),
                                  Text(
                                      "\u{20B9}${double.parse(salesListModel!.rows![i].totalTax.toString()).toStringAsFixed(2)}",
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
                                  Text("Payment Method",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600)),
                                  Text(
                                      "${salesListModel!.rows![i].paymentMethod}",
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
                                  Text("Sub Total",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600)),
                                  Text(
                                      "\u{20B9}${double.parse(salesListModel!.rows![i].total.toString()).toStringAsFixed(2)}",
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
                                  Text("Final Total",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600)),
                                  Text(
                                      "\u{20B9}${double.parse(salesListModel!.rows![i].finalTotal.toString()).toStringAsFixed(2)}",
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
                                  Text("Date",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600)),
                                  Text("${salesListModel!.rows![i].dateAdded}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
      ),
    );
  }
}
