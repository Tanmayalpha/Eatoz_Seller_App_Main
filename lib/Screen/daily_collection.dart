import 'package:flutter/material.dart';
import '../Helper/Color.dart';
import '../Helper/Session.dart';

class DailyCollection extends StatefulWidget {
  const DailyCollection({Key? key}) : super(key: key);

  @override
  State<DailyCollection> createState() => _DailyCollectionState();
}

class _DailyCollectionState extends State<DailyCollection> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightWhite,
      appBar: getAppBar("Daily Collection", context),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
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
                                    "model.id!",
                                    style: TextStyle(color: black),
                                  ),
                                ],
                              ),
                              // Spacer(),
                            ],
                          ),
                        ),
                        Divider(),
                        Padding(
                          padding:
                          const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5),
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
                                    " " + getTranslated(context, "ORDER_DATE")! + ": ",
                                    style: TextStyle(color: grey),
                                  ),
                                  Text(
                                    "model.orderDate!",
                                    style: TextStyle(color: black),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding:
                          const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5),
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
                                    "model.orderTime!",
                                    style: TextStyle(color: black),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  onTap: () async {},
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}