import 'dart:convert';

import 'package:eshopmultivendor/Helper/Constant.dart';
import 'package:eshopmultivendor/Model/productReviewModel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../Helper/Session.dart';

class ProductReview extends StatefulWidget {
  String? id;
  ProductReview({this.id});

  @override
  State<ProductReview> createState() => _ProductReviewState();
}

class _ProductReviewState extends State<ProductReview> {
  ProductReviewModel? productReviewModel;

  getProductReview() async {
    var headers = {
      'Cookie': 'ci_session=bb7b139b5f9fa976b3941ab27a857004345cb88f'
    };
    var request = http.MultipartRequest(
        'POST', Uri.parse('${baseUrl}get_product_rating'));
    request.fields.addAll({'product_id': '${widget.id}'});
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var finalResult = await response.stream.bytesToString();
      final jsonResponse =
          ProductReviewModel.fromJson(json.decode(finalResult));
      setState(() {
        productReviewModel = jsonResponse;
      });
    } else {
      print(response.reasonPhrase);
    }
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 200), () {
      return getProductReview();
    });
  }

  @override
  Widget build(BuildContext context) {
    print("get id here now ${widget.id}");
    return Scaffold(
      appBar: getAppBar(
        "Food Reviews",
        //getTranslated(context, "Add New Product")!,
        context,
      ),
      body: Container(
        child: productReviewModel == null
            ? Center(
                child: Text("No review to show"),
              )
            : productReviewModel!.data!.length == 0
                ? Center(
                    child: Text("No review to show"),
                  )
                : ListView.separated(
                    shrinkWrap: true,
                    separatorBuilder: (context, index) {
                      return Divider();
                    },
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 15),
                    physics: AlwaysScrollableScrollPhysics(),
                    itemCount: productReviewModel!.data!.length,
                    itemBuilder: (c, i) {
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Container(
                          height: 55,
                          width: 55,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: Image.network(
                              "${productReviewModel!.data![i].userProfile}",
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        title: Text("${productReviewModel!.data![i].userName}"),
                        trailing:
                            Text("${productReviewModel!.data![i].dataAdded}"),
                        subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("${productReviewModel!.data![i].comment}"),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.star,
                                    color: Colors.yellow,
                                  ),
                                  SizedBox(
                                    width: 5, 
                                  ),
                                  Text("${productReviewModel!.productRating}")
                                ],
                              )
                            ]),
                      );

                      //  Container(
                      //   child: Column(
                      //     children: [
                      //       Row(
                      //         crossAxisAlignment: CrossAxisAlignment.center,
                      //         children: [
                      //           Container(
                      //             height: 55,
                      //             width: 55,
                      //             child: ClipRRect(
                      //               borderRadius: BorderRadius.circular(100),
                      //               child: Image.network(
                      //                 "${productReviewModel!.data![i].userProfile}",
                      //                 fit: BoxFit.fill,
                      //               ),
                      //             ),
                      //           ),
                      //           SizedBox(
                      //             width: 10,
                      //           ),
                      //           Text(
                      //               "${productReviewModel!.data![i].userName}"),
                      //         ],
                      //       )
                      //     ],
                      //   ),
                      // );
                    }),
      ),
    );
  }
}
