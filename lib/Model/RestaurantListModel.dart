class RestaurantListModel {
  String? total;
  List<Rows>? rows;

  RestaurantListModel({this.total, this.rows});

  RestaurantListModel.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    if (json['rows'] != null) {
      rows = <Rows>[];
      json['rows'].forEach((v) {
        rows!.add(new Rows.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total'] = this.total;
    if (this.rows != null) {
      data['rows'] = this.rows!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Rows {
  String? operate;
  int? srNo;
  String? orderId;
  String? orderDate;
  String? resturantName;
  String? resturantId;
  String? paymentMethod;
  String? activeStatus;
  String? total;
  String? restaurantDiscount;
  String? adminDiscount;
  String? netBill;
  double? totalGst;
  double? totalMerchant;
  double? finalTotal;
  String? totalMarchant;
  String? commission;
  String? tds;
  // double? applicable;
  String? adminTotalEarning;
  String? etozFee;
  String? finalAdminEarning;
  String? netPayble;
  String? dateAdded;

  Rows(
      {this.operate,
      this.srNo,
      this.orderId,
      this.orderDate,
      this.resturantName,
      this.resturantId,
      this.paymentMethod,
      this.activeStatus,
      this.total,
      this.restaurantDiscount,
      this.adminDiscount,
      this.netBill,
      this.totalGst,
      this.totalMerchant,
      this.finalTotal,
      this.totalMarchant,
      this.commission,
      this.tds,
      // this.applicable,
      this.adminTotalEarning,
      this.etozFee,
      this.finalAdminEarning,
      this.netPayble,
      this.dateAdded});

  Rows.fromJson(Map<String, dynamic> json) {
    operate = json['operate'];
    srNo = json['sr_no'];
    orderId = json['order_id'];
    orderDate = json['order_date'];
    resturantName = json['resturant_name'];
    resturantId = json['resturant_id'];
    paymentMethod = json['payment_method'];
    activeStatus = json['active_status'];
    total = json['total'];
    restaurantDiscount = json['restaurant_discount'].toString();
    adminDiscount = json['admin_discount'].toString();
    netBill = json['net_bill'];
    totalGst = double.parse(json['total_gst']);
    totalMerchant = double.parse(json['total_merchant'].toString());
    finalTotal = double.parse(json['final_total'].toString());
    totalMarchant = json['total_marchant'];
    commission = json['commission'];
    tds = json['tds'];
    // applicable = double.parse(json['applicable']);
    adminTotalEarning = json['admin_total_earning'];
    etozFee = json['etoz_fee'];
    finalAdminEarning = json['final_admin_earning'];
    netPayble = json['net_payble'].toString();
    dateAdded = json['date_added'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['operate'] = this.operate;
    data['sr_no'] = this.srNo;
    data['order_id'] = this.orderId;
    data['order_date'] = this.orderDate;
    data['resturant_name'] = this.resturantName;
    data['resturant_id'] = this.resturantId;
    data['payment_method'] = this.paymentMethod;
    data['active_status'] = this.activeStatus;
    data['total'] = this.total;
    data['restaurant_discount'] = this.restaurantDiscount;
    data['admin_discount'] = this.adminDiscount;
    data['net_bill'] = this.netBill;
    data['total_gst'] = this.totalGst;
    data['total_merchant'] = this.totalMerchant;
    data['final_total'] = this.finalTotal;
    data['total_marchant'] = this.totalMarchant;
    data['commission'] = this.commission;
    data['tds'] = this.tds;
    // data['applicable'] = this.applicable;
    data['admin_total_earning'] = this.adminTotalEarning;
    data['etoz_fee'] = this.etozFee;
    data['final_admin_earning'] = this.finalAdminEarning;
    data['net_payble'] = this.netPayble;
    data['date_added'] = this.dateAdded;
    return data;
  }
}
