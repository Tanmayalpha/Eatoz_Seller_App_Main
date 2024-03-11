import 'package:eshopmultivendor/Helper/String.dart';

import '../ProductModel/Product.dart';

class OrderItem {
  String? id,
      name,
      qty,
      price,
      subTotal,
      status,
      image,
      varientId,
      isCancle,
      activeStatus,
      isReturn,
      isAlrCancelled,
      isAlrReturned,
      rtnReqSubmitted,
      varient_values,
      attr_name,
      productId,
      curSelected,
      deliveryBoyId,
      delivery_boy_name,
      cgst,
      sgst,
      deliveryBoyMobile,
      deliverBy;
  List<AddOnModel>? addonList = [];
  List<String?>? listStatus = [];
  List<String?>? listDate = [];

  OrderItem(
      {this.qty,
      this.id,
        this.delivery_boy_name,
      this.name,
      this.price,
      this.subTotal,
      this.status,
      this.image,
      this.varientId,
      this.activeStatus,
      this.listDate,
        this.addonList,
      this.listStatus,
      this.isCancle,
      this.isReturn,
        this.cgst,
        this.sgst,
      this.isAlrReturned,
      this.isAlrCancelled,
      this.rtnReqSubmitted,
      this.attr_name,
      this.productId,
      this.varient_values,
      this.curSelected,
      this.deliveryBoyId,
        this.deliveryBoyMobile,
      this.deliverBy});

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    List<String?> lStatus = [];
    List<String?> lDate = [];
    List<AddOnModel> addList = [];
    if(json['add_ons']!=null){
      addList = (json['add_ons'] as List)
          .map((data) => new AddOnModel.fromJson(data))
          .toList();
    }

    var allSttus = json[STATUS] == null  ? [] : json[STATUS];
    for (var curStatus in allSttus) {
      lStatus.add(curStatus[0]);
      lDate.add(curStatus[1]);
    }
    return new OrderItem(
        id: json[Id],
        qty: json[Quantity],
        name: json[Name],
        delivery_boy_name: json["delivery_boy_name"],
        deliveryBoyMobile: json["delivery_boy_number"],
        activeStatus: json[ActiveStatus],
        image: json[IMage],
        price: json[Price],
        subTotal: json[SubTotal],
        varientId: json[ProductVariantId],
        listStatus: lStatus,
        status: json[ActiveStatus],
        curSelected: json[ActiveStatus],
        listDate: lDate,
        isCancle: json[IsCancelable],
        addonList: addList,
        isReturn: json[IsReturnable],
        cgst: json['cgst'],
        sgst: json['sgst'],
        isAlrCancelled: json[IsAlreadyCancelled],
        isAlrReturned: json[IsAlreadyReturned],
        rtnReqSubmitted: json[ReturnRequestSubmitted],
        attr_name: json[AttrName],
        productId: json[ProductId],
        varient_values: json[VariantValues],
        deliveryBoyId: json[Delivery_Boy_Id],

        deliverBy: json[DeliverBy]);
  }
}
