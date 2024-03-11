import 'dart:convert';
/// message : "Category retrieved successfully"
/// error : false
/// data : [{"id":"2","name":"Starter food","parent_id":"1","slug":"starter-food","image":"uploads/media/2022/download_-_2022-01-29T130353_897.jpg","banner":null,"row_order":"0","status":"1","clicks":"0"},{"id":"3","name":"Chickens Handi","parent_id":"1","slug":"chickens-handi","image":"uploads/media/2022/th_(1).jpg","banner":null,"row_order":"0","status":"1","clicks":"0"}]

SubCategoryModel subCategoryModelFromJson(String str) => SubCategoryModel.fromJson(json.decode(str));
String subCategoryModelToJson(SubCategoryModel data) => json.encode(data.toJson());
class SubCategoryModel {
  SubCategoryModel({
      String? message, 
      bool? error, 
      List<Data>? data,}){
    _message = message;
    _error = error;
    _data = data;
}

  SubCategoryModel.fromJson(dynamic json) {
    _message = json['message'];
    _error = json['error'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(Data.fromJson(v));
      });
    }
  }
  String? _message;
  bool? _error;
  List<Data>? _data;

  String? get message => _message;
  bool? get error => _error;
  List<Data>? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['message'] = _message;
    map['error'] = _error;
    if (_data != null) {
      map['data'] = _data?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// id : "2"
/// name : "Starter food"
/// parent_id : "1"
/// slug : "starter-food"
/// image : "uploads/media/2022/download_-_2022-01-29T130353_897.jpg"
/// banner : null
/// row_order : "0"
/// status : "1"
/// clicks : "0"

Data dataFromJson(String str) => Data.fromJson(json.decode(str));
String dataToJson(Data data) => json.encode(data.toJson());
class Data {
  Data({
      String? id, 
      String? name, 
      String? parentId, 
      String? slug, 
      String? image, 
      dynamic banner, 
      String? rowOrder, 
      String? status, 
      String? clicks,}){
    _id = id;
    _name = name;
    _parentId = parentId;
    _slug = slug;
    _image = image;
    _banner = banner;
    _rowOrder = rowOrder;
    _status = status;
    _clicks = clicks;
}

  Data.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _parentId = json['parent_id'];
    _slug = json['slug'];
    _image = json['image'];
    _banner = json['banner'];
    _rowOrder = json['row_order'];
    _status = json['status'];
    _clicks = json['clicks'];
  }
  String? _id;
  String? _name;
  String? _parentId;
  String? _slug;
  String? _image;
  dynamic _banner;
  String? _rowOrder;
  String? _status;
  String? _clicks;

  String? get id => _id;
  String? get name => _name;
  String? get parentId => _parentId;
  String? get slug => _slug;
  String? get image => _image;
  dynamic get banner => _banner;
  String? get rowOrder => _rowOrder;
  String? get status => _status;
  String? get clicks => _clicks;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['parent_id'] = _parentId;
    map['slug'] = _slug;
    map['image'] = _image;
    map['banner'] = _banner;
    map['row_order'] = _rowOrder;
    map['status'] = _status;
    map['clicks'] = _clicks;
    return map;
  }

}