class ProductReviewModel {
  bool? error;
  String? message;
  int? noOfRating;
  String? total;
  String? star1;
  String? star2;
  String? star3;
  String? star4;
  String? star5;
  String? totalImages;
  String? productRating;
  List<Data>? data;

  ProductReviewModel(
      {this.error,
      this.message,
      this.noOfRating,
      this.total,
      this.star1,
      this.star2,
      this.star3,
      this.star4,
      this.star5,
      this.totalImages,
      this.productRating,
      this.data});

  ProductReviewModel.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    message = json['message'];
    noOfRating = json['no_of_rating'];
    total = json['total'];
    star1 = json['star_1'];
    star2 = json['star_2'];
    star3 = json['star_3'];
    star4 = json['star_4'];
    star5 = json['star_5'];
    totalImages = json['total_images'];
    productRating = json['product_rating'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['error'] = this.error;
    data['message'] = this.message;
    data['no_of_rating'] = this.noOfRating;
    data['total'] = this.total;
    data['star_1'] = this.star1;
    data['star_2'] = this.star2;
    data['star_3'] = this.star3;
    data['star_4'] = this.star4;
    data['star_5'] = this.star5;
    data['total_images'] = this.totalImages;
    data['product_rating'] = this.productRating;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? id;
  String? userId;
  String? productId;
  String? rating;
  List<String>? images;
  String? comment;
  String? dataAdded;
  String? userName;
  String? userProfile;

  Data(
      {this.id,
      this.userId,
      this.productId,
      this.rating,
      this.images,
      this.comment,
      this.dataAdded,
      this.userName,
      this.userProfile});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    productId = json['product_id'];
    rating = json['rating'];
    images = json['images'].cast<String>();
    comment = json['comment'];
    dataAdded = json['data_added'];
    userName = json['user_name'];
    userProfile = json['user_profile'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['product_id'] = this.productId;
    data['rating'] = this.rating;
    data['images'] = this.images;
    data['comment'] = this.comment;
    data['data_added'] = this.dataAdded;
    data['user_name'] = this.userName;
    data['user_profile'] = this.userProfile;
    return data;
  }
}
