import 'package:eshopmultivendor/Helper/String.dart';
import 'package:intl/intl.dart';
import 'AttachmentModel.dart';
import 'OrderItemsModel.dart';

class Order_Model {
  String? id,
      name,
      mobile,
      latitude,
      longitude,
      delCharge,
      walBal,
      promo,
      promoDis,
      payMethod,
      total,
      subTotal,
      payable,
      address,
      taxAmt,
      taxPer,
      orderDate,
      orderTime,
      dateTime,
      isCancleable,
      isReturnable,
      isAlrCancelled,
      isAlrReturned,
      rtnReqSubmitted,
      otp,
      // deliveryBoyId,
      invoice,
      delDate,
      delTime,
      countryCode,
      driverName,
      driverMobile,
      cgst,
      sgst,
      deliverTime;
  List<AddOnModel>? addonList = [];
  List<Attachment>? attachList = [];
  List<OrderItem>? itemList;
  List<String?>? listStatus = [];
  List<String?>? listDate = [];

  Order_Model(
      {this.id,
      this.name,
      this.mobile,
      this.delCharge,
      this.walBal,
      this.promo,
      this.promoDis,
      this.payMethod,
      this.total,
      this.subTotal,
      this.payable,
      this.address,
      this.addonList,
      this.taxPer,
      this.taxAmt,
      this.orderDate,
      this.dateTime,
      this.itemList,
      this.listStatus,
      this.listDate,
      this.isReturnable,
      this.isCancleable,
      this.isAlrCancelled,
      this.isAlrReturned,
      this.rtnReqSubmitted,
      this.sgst,
      this.cgst,
      this.otp,
      this.invoice,
      this.latitude,
      this.longitude,
      this.delDate,
      this.delTime,
      // this.deliveryBoyId,
      this.countryCode,
      this.orderTime,
      this.driverName,
      this.driverMobile,
      this.deliverTime});

  factory Order_Model.fromJson(Map<String, dynamic> parsedJson) {
    List<OrderItem> itemList = [];
    var order = (parsedJson[OrderItemss] as List);
    print("temp");
    print("order : $order");
    // if (order == null || order.isEmpty)
    //   return null;
    // else

    itemList = order.map((data) => new OrderItem.fromJson(data)).toList();
    String date = parsedJson[DateAdded];
    print("DATE++ $date");
    DateTime oTime = DateTime.parse(date);
    date = DateFormat('dd-MM-yyyy').format(DateTime.parse(date));
    String time = DateFormat.jm().format(oTime);
    print("TIME=== $time");

    List<AddOnModel> addList = [];
    if (parsedJson['add_ons'] != null) {
      addList = (parsedJson['add_ons'] as List)
          .map((data) => new AddOnModel.fromJson(data))
          .toList();
    }

    List<String?> lStatus = [];
    List<String?> lDate = [];

    return new Order_Model(
      id: parsedJson[Id],
      name: parsedJson[Username],
      mobile: parsedJson[Mobile],
      delCharge: parsedJson[DeliveryCharge],
      walBal: parsedJson[WalletBalance],
      promo: parsedJson[PromoCode],
      promoDis: parsedJson[PromoDiscount],
      payMethod: parsedJson[PaymentMethod],
      total: parsedJson[FinalTotal],
      subTotal: parsedJson[Total],
      payable: parsedJson[TotalPayable],
      addonList: addList,
      address: parsedJson[Address],
      taxAmt: parsedJson[TotalTaxAmount],
      taxPer: parsedJson[TotalTaxPercent],
      dateTime: parsedJson[DateAdded],
      cgst: parsedJson['cgst'],
      sgst: parsedJson['sgst'],
      isCancleable: parsedJson[IsCancelable],
      isReturnable: parsedJson[IsReturnable],
      isAlrCancelled: parsedJson[IsAlreadyCancelled],
      isAlrReturned: parsedJson[IsAlreadyReturned],
      rtnReqSubmitted: parsedJson[ReturnRequestSubmitted],
      orderDate: date,
      orderTime: time,
      itemList: itemList,
      listStatus: lStatus,
      listDate: lDate,
      otp: parsedJson[Otp],
      latitude: parsedJson[Latitude],
      longitude: parsedJson[Longitude],
      countryCode: parsedJson[COUNTRY_CODE],
      delDate: '',
      // parsedJson[DeliveryDate] != null || parsedJson[DeliveryDate] != ''
      //     ? DateFormat('dd-MM-yyyy')
      //         .format(DateTime.parse(parsedJson[DeliveryDate]))
      //     : '',
      delTime: parsedJson[DeliveryTime] != null ? parsedJson[DeliveryTime] : '',
      driverMobile: parsedJson["delivery_boy_number"],
      driverName: parsedJson["delivery_boy_name"],
      deliverTime: parsedJson["delivered_time"],
      //deliveryBoyId: parsedJson[Delivery_Boy_Id]
    );
  }
}

class AddOnModel {
  String? id;
  String? productId;
  String? price;
  String? image;
  String? name;
  String? totalAmount;
  String? quantity;

  AddOnModel({
    this.id,
    this.productId,
    this.price,
    this.image,
    this.name,
    this.quantity,
    this.totalAmount,
  });

  AddOnModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productId = json['product_id'];
    price = json['price'];
    image = json['image'];
    name = json['name'];
    quantity = json['quantity'];
    totalAmount = json['total_amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['product_id'] = this.productId;
    data['price'] = this.price;
    data['image'] = this.image;
    data['name'] = this.name;
    data['total_amount'] = this.totalAmount;
    data['quantity'] = this.quantity;
    return data;
  }
}
