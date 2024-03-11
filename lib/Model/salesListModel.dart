class SalesListModel {
  bool? error;
  String? message;
  String? total;
  String? grandTotal;
  String? totalDeliveryCharge;
  String? grandFinalTotal;
  List<Rows>? rows;

  SalesListModel(
      {this.error,
      this.message,
      this.total,
      this.grandTotal,
      this.totalDeliveryCharge,
      this.grandFinalTotal,
      this.rows});

  SalesListModel.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    message = json['message'];
    total = json['total'];
    grandTotal = json['grand_total'];
    totalDeliveryCharge = json['total_delivery_charge'];
    grandFinalTotal = json['grand_final_total'];
    if (json['rows'] != null) {
      rows = <Rows>[];
      json['rows'].forEach((v) {
        rows!.add(new Rows.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['error'] = this.error;
    data['message'] = this.message;
    data['total'] = this.total;
    data['grand_total'] = this.grandTotal;
    data['total_delivery_charge'] = this.totalDeliveryCharge;
    data['grand_final_total'] = this.grandFinalTotal;
    if (this.rows != null) {
      data['rows'] = this.rows!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Rows {
  String? id;
  String? name;
  String? totalTax;
  String? total;
  String? taxAmount;
  String? discountedPrice;
  String? promoDiscount;
  String? active_status;
  String? deliveryCharge;
  String? finalTotal;
  String? paymentMethod;
  String? orderId;
  String? storeName;
  String? sellerName;
  String? dateAdded;

  Rows(
      {this.id,
      this.name,
      this.totalTax,
      this.total,
      this.taxAmount,
      this.orderId,
      this.active_status,
      this.discountedPrice,
      this.promoDiscount,
      this.deliveryCharge,
      this.finalTotal,
      this.paymentMethod,
      this.storeName,
      this.sellerName,
      this.dateAdded});

  Rows.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    totalTax = json['total_tax'].toString();
    total = json['total'];
    taxAmount = json['tax_amount'];
    discountedPrice = json['discounted_price'];
    orderId = json['order_id'];
    active_status = json['active_status'];
    promoDiscount = json['promo_discount'];
    deliveryCharge = json['delivery_charge'];
    finalTotal = json['final_total'];
    paymentMethod = json['payment_method'];
    storeName = json['store_name'];
    sellerName = json['seller_name'];
    dateAdded = json['date_added'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['total_tax'] = this.totalTax;
    data['total'] = this.total;
    data['tax_amount'] = this.taxAmount;
    data['discounted_price'] = this.discountedPrice;
    data['active_status'] = this.active_status;
    data['promo_discount'] = this.promoDiscount;
    data['delivery_charge'] = this.deliveryCharge;
    data['final_total'] = this.finalTotal;
    data['payment_method'] = this.paymentMethod;
    data['order_id'] = this.orderId;
    data['store_name'] = this.storeName;
    data['seller_name'] = this.sellerName;
    data['date_added'] = this.dateAdded;
    return data;
  }
}
