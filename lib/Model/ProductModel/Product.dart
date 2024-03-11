import '../../Helper/String.dart';
import 'Attribute.dart';
import 'FilterModel.dart';
import 'Variants.dart';

class Product {
  String? id,
      name,
      desc,
      image,
      catName,
      type,
      rating,
      noOfRating,
      attrIds,
      tax,
      categoryId,
      shortDescription,
      product_status,
      stock;
  List<String>? otherImage;
  List<Product_Varient>? prVarientList;
  List<Attribute>? attributeList;
  List<String>? selectedId = [];
  List<String>? tagList = [];
  List<AddOnModel>? addonList = [];
  String? isFav,
      isReturnable,
      is_prices_inclusive_tax,
      quantity_step_size,
      minimum_order_quantity,
      cod_allowed,
      isCancelable,
      isPurchased,
      availability,
      madein,
      indicator,
      stockType,
      cancleTill,
      total,
      banner,
      totalAllow,
      video,
      videType,
      warranty,
      gurantee;

  bool? isFavLoading = false, isFromProd = false;
  int? offset, totalItem, selVarient;

  List<Product>? subList;
  List<Filter>? filterList;

  Product(
      {this.id,
      this.is_prices_inclusive_tax,
      this.minimum_order_quantity,
      this.quantity_step_size,
      this.cod_allowed,
      this.name,
      this.desc,
      this.image,
      this.product_status,
      this.catName,
      this.type,
      this.otherImage,
      this.prVarientList,
      this.attributeList,
      this.isFav,
      this.isCancelable,
      this.isReturnable,
      this.isPurchased,
      this.availability,
      this.noOfRating,
      this.attrIds,
      this.selectedId,
      this.addonList,
      this.rating,
      this.isFavLoading,
      this.indicator,
      this.madein,
      this.tax,
      this.shortDescription,
      this.total,
      this.categoryId,
      this.subList,
      this.filterList,
      this.stockType,
      this.isFromProd,
      this.cancleTill,
      this.totalItem,
      this.offset,
      this.totalAllow,
      this.banner,
      this.selVarient,
      this.video,
      this.videType,
      this.tagList,
      this.warranty,
      this.stock,
      this.gurantee});

  factory Product.fromJson(Map<String, dynamic> json) {
    List<Product_Varient> varientList = (json['variants'] as List)
        .map((data) => new Product_Varient.fromJson(data))
        .toList();

    List<AddOnModel> addList = [];
    if (json['add_on'] != null) {
      addList = (json['add_on'] as List)
          .map((data) => new AddOnModel.fromJson(data))
          .toList();
    }
    List<Attribute> attList = (json[Attributes] as List)
        .map((data) => new Attribute.fromJson(data))
        .toList();

    var flist = (json[FILTERS] as List?);
    List<Filter> filterList = [];
    if (flist == null || flist.isEmpty)
      filterList = [];
    else
      filterList = flist.map((data) => new Filter.fromJson(data)).toList();

    List<String> other_image = List<String>.from(json[OtherImagesMd]);
    List<String> selected = [];

    return new Product(
      id: json[Id],
      cod_allowed: json['cod_allowed'],
      is_prices_inclusive_tax: json['is_prices_inclusive_tax'],
      minimum_order_quantity: json['minimum_order_quantity'].toString(),
      quantity_step_size: json['quantity_step_size'].toString(),
      shortDescription: json['short_description'].toString(),
      product_status: json['product_status'].toString(),
      name: json[Name],
      desc: json[Description],
      image: json[IMage],
      addonList: addList,
      catName: json[CategoryName],
      rating: json[Rating],
      noOfRating: json[NoOfRatings],
      stock: json[Stock],
      type: json[Type],
      isFav: json[IsFavorite].toString(),
      isCancelable: json[IsCancelable],
      availability: json[Availability].toString(),
      isPurchased: json[IsPurchased].toString(),
      isReturnable: json[IsReturnable],
      otherImage: other_image,
      prVarientList: varientList,
      attributeList: attList,
      filterList: filterList,
      isFavLoading: false,
      selVarient: 0,
      attrIds: json[AttrValueIds],
      madein: json[MadeIn],
      indicator: json[Indicator].toString(),
      stockType: json[StockType].toString(),
      tax: json[TaxPercentage],
      total: json[Total],
      categoryId: json[CategoryId],
      selectedId: selected,
      totalAllow: json[TotalAllowedQuantity],
      cancleTill: json[CancelableTill],
    );
  }

  factory Product.fromCat(Map<String, dynamic> parsedJson) {
    return new Product(
      id: parsedJson[Id],
      name: parsedJson[Name],
      image: parsedJson[Images],
      banner: parsedJson[BANNER],
      isFromProd: false,
      offset: 0,
      totalItem: 0,
      tax: parsedJson[TAX],
      subList: createSubList(parsedJson["children"]),
    );
  }

  static List<Product>? createSubList(List? parsedJson) {
    if (parsedJson == null || parsedJson.isEmpty) return null;

    return parsedJson.map((data) => new Product.fromCat(data)).toList();
  }
}

class ProductModel {
  String? total;
  String? sales;
  String? hsn;
  String? stockType;
  String? sub_category_id;
  String? isPricesInclusiveTax;
  String? type;
  String? attrValueIds;
  String? sellerRating;
  String? vendor_discount_price;
  String? sellerSlug;
  String? sellerNoOfRatings;
  String? sellerProfile;
  String? storeName;
  String? storeDescription;
  String? sellerId;
  String? sellerName;
  String? id;
  String? stock;
  String? name;
  String? today_special;
  String? categoryId;
  String? shortDescription;
  String? slug;
  String? description;
  String? totalAllowedQuantity;
  String? deliverableType;
  String? deliverableZipcodes;
  String? minimumOrderQuantity;
  String? quantityStepSize;
  String? codAllowed;
  String? rowOrder;
  String? rating;
  String? noOfRatings;
  String? image;
  String? isReturnable;
  String? isCancelable;
  String? cancelableTill;
  String? indicator;
  String? discount_date;
  String? today_special_date;
  List<String>? otherImages;
  String? videoType;
  String? video;
  List<String>? tags;
  String? warrantyPeriod;
  String? guaranteePeriod;
  String? madeIn;
  String? availability;
  String? categoryName;
  String? taxPercentage;
  List<String>? reviewImages;
  List<String>? attributes;
  List<Variants>? variants;
  MinMaxPrice? minMaxPrice;
  Null? deliverableZipcodesIds;
  bool? isDeliverable;
  bool? isPurchased;
  String? isFavorite;
  String? imageMd;
  String? imageSm;
  List<String>? otherImagesMd;
  List<AddOnModel>? newAddonList;
  List<String>? otherImagesSm;
  List<String>? variantAttributes;
  int? selVarient;
  ProductModel(
      {this.total,
        this.hsn,
      this.selVarient,
      this.sales,
      this.stockType,
      this.isPricesInclusiveTax,
      this.type,
      this.attrValueIds,
      this.sellerRating,
      this.sellerSlug,
      this.sellerNoOfRatings,
        this.today_special_date,
      this.sellerProfile,
      this.sub_category_id,
      this.storeName,
      this.vendor_discount_price,
      this.storeDescription,
      this.sellerId,
      this.sellerName,
      this.id,
      this.discount_date,
      this.stock,
      this.name,
      this.today_special,
      this.categoryId,
      this.shortDescription,
      this.newAddonList,
      this.slug,
      this.description,
      this.totalAllowedQuantity,
      this.deliverableType,
      this.deliverableZipcodes,
      this.minimumOrderQuantity,
      this.quantityStepSize,
      this.codAllowed,
      this.rowOrder,
      this.rating,
      this.noOfRatings,
      this.image,
      this.isReturnable,
      this.isCancelable,
      this.cancelableTill,
      this.indicator,
      this.otherImages,
      this.videoType,
      this.video,
      this.tags,
      this.warrantyPeriod,
      this.guaranteePeriod,
      this.madeIn,
      this.availability,
      this.categoryName,
      this.taxPercentage,
      this.reviewImages,
      this.attributes,
      this.variants,
      this.minMaxPrice,
      this.deliverableZipcodesIds,
      this.isDeliverable,
      this.isPurchased,
      this.isFavorite,
      this.imageMd,
      this.imageSm,
      this.otherImagesMd,
      this.otherImagesSm,
      this.variantAttributes});

  ProductModel.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    hsn = json['hsn_code'];

    sales = json['sales'];
    stockType = json['stock_type'];
    isPricesInclusiveTax = json['is_prices_inclusive_tax'];
    type = json['type'];
    attrValueIds = json['attr_value_ids'];
    sellerRating = json['seller_rating'];
    sellerSlug = json['seller_slug'];
    sellerNoOfRatings = json['seller_no_of_ratings'];
    sellerProfile = json['seller_profile'];
    sub_category_id = json['sub_category_id'];
    storeName = json['store_name'];
    storeDescription = json['store_description'];
    sellerId = json['seller_id'];
    sellerName = json['seller_name'];
    id = json['id'];
    vendor_discount_price = json['vendor_discount_price'];
    stock = json['stock'];
    today_special = json['today_special'];
    name = json['name'];
    categoryId = json['category_id'];
    shortDescription = json['short_description'];
    slug = json['slug'];
    today_special_date = json['today_special_date'];
    description = json['description'];
    totalAllowedQuantity = json['total_allowed_quantity'];
    deliverableType = json['deliverable_type'];
    deliverableZipcodes = json['deliverable_zipcodes'];
    minimumOrderQuantity = json['minimum_order_quantity'].toString();
    quantityStepSize = json['quantity_step_size'].toString();
    codAllowed = json['cod_allowed'];
    discount_date = json['discount_date'];
    rowOrder = json['row_order'];
    rating = json['rating'];
    noOfRatings = json['no_of_ratings'];
    image = json['image'];
    isReturnable = json['is_returnable'];
    isCancelable = json['is_cancelable'];
    cancelableTill = json['cancelable_till'];
    indicator = json['indicator'];
    otherImages = json['other_images'].cast<String>();
    videoType = json['video_type'];
    video = json['video'];
    tags = json['tags'].cast<String>();
    warrantyPeriod = json['warranty_period'];
    guaranteePeriod = json['guarantee_period'];
    madeIn = json['made_in'];
    availability = json['availability'].toString();
    categoryName = json['category_name'];
    taxPercentage = json['tax_percentage'];
    if (json['review_images'] != null) {
      reviewImages = [];
      json['review_images'].forEach((v) {
        reviewImages!.add(v);
      });
    }
    // if (json['attributes'] != null) {
    //   attributes = [];
    //   json['attributes'].forEach((v) {
    //     attributes!.add(v);
    //   });
    // }
    if (json['variants'] != null) {
      variants = <Variants>[];
      json['variants'].forEach((v) {
        variants!.add(new Variants.fromJson(v));
      });
    }

    if (json['add_on'] != null) {
      newAddonList = <AddOnModel>[];
      json['add_on'].forEach((v) {
        newAddonList!.add(AddOnModel.fromJson(v));
      });
    }
    minMaxPrice = json['min_max_price'] != null
        ? new MinMaxPrice.fromJson(json['min_max_price'])
        : null;
    deliverableZipcodesIds = json['deliverable_zipcodes_ids'];
    isDeliverable = json['is_deliverable'];
    isPurchased = json['is_purchased'];
    isFavorite = json['is_favorite'];
    imageMd = json['image_md'];
    selVarient = 0;
    imageSm = json['image_sm'];
    otherImagesMd = json['other_images_md'].cast<String>();
    otherImagesSm = json['other_images_sm'].cast<String>();
    // if (json['variant_attributes'] != null) {
    //   variantAttributes = [];
    //   json['variant_attributes'].forEach((v) {
    //     variantAttributes!.add(v);
    //   });
    // }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total'] = this.total;
    data['sales'] = this.sales;
    data['stock_type'] = this.stockType;
    data['is_prices_inclusive_tax'] = this.isPricesInclusiveTax;
    data['type'] = this.type;
    data['attr_value_ids'] = this.attrValueIds;
    data['seller_rating'] = this.sellerRating;
    data['seller_slug'] = this.sellerSlug;
    data['seller_no_of_ratings'] = this.sellerNoOfRatings;
    data['seller_profile'] = this.sellerProfile;
    data['store_name'] = this.storeName;
    data['store_description'] = this.storeDescription;
    data['vendor_discount_price'] = this.vendor_discount_price;
    data['seller_id'] = this.sellerId;
    data['seller_name'] = this.sellerName;
    data['discount_date'] = this.discount_date;
    data['sub_category_id'] = this.sub_category_id;
    data['id'] = this.id;
    data['stock'] = this.stock;
    data['today_special_date'] = this.today_special_date;
    data['today_special'] = this.today_special;
    data['name'] = this.name;
    data['category_id'] = this.categoryId;
    data['short_description'] = this.shortDescription;
    data['slug'] = this.slug;
    data['description'] = this.description;
    data['total_allowed_quantity'] = this.totalAllowedQuantity;
    data['deliverable_type'] = this.deliverableType;
    data['deliverable_zipcodes'] = this.deliverableZipcodes;
    data['minimum_order_quantity'] = this.minimumOrderQuantity;
    data['quantity_step_size'] = this.quantityStepSize;
    data['cod_allowed'] = this.codAllowed;
    data['row_order'] = this.rowOrder;
    data['rating'] = this.rating;
    data['no_of_ratings'] = this.noOfRatings;
    data['image'] = this.image;
    data['is_returnable'] = this.isReturnable;
    data['is_cancelable'] = this.isCancelable;
    data['cancelable_till'] = this.cancelableTill;
    data['indicator'] = this.indicator;
    data['other_images'] = this.otherImages;
    data['video_type'] = this.videoType;
    data['video'] = this.video;
    data['tags'] = this.tags;
    data['warranty_period'] = this.warrantyPeriod;
    data['guarantee_period'] = this.guaranteePeriod;
    data['made_in'] = this.madeIn;
    data['availability'] = this.availability;
    data['category_name'] = this.categoryName;
    data['tax_percentage'] = this.taxPercentage;
    if (this.reviewImages != null) {
      data['review_images'] = this.reviewImages!.map((v) => v).toList();
    }
    if (this.attributes != null) {
      data['attributes'] = this.attributes!.map((v) => v).toList();
    }
    if (this.variants != null) {
      data['variants'] = this.variants!.map((v) => v).toList();
    }
    if (this.newAddonList != null) {
      data['add_on'] = this.newAddonList!.map((v) => v).toList();
    }
    if (this.minMaxPrice != null) {
      data['min_max_price'] = this.minMaxPrice!.toJson();
    }
    data['deliverable_zipcodes_ids'] = this.deliverableZipcodesIds;
    data['is_deliverable'] = this.isDeliverable;
    data['is_purchased'] = this.isPurchased;
    data['is_favorite'] = this.isFavorite;
    data['image_md'] = this.imageMd;
    data['image_sm'] = this.imageSm;
    data['other_images_md'] = this.otherImagesMd;
    data['other_images_sm'] = this.otherImagesSm;
    if (this.variantAttributes != null) {
      data['variant_attributes'] =
          this.variantAttributes!.map((v) => v).toList();
    }
    return data;
  }
}

class Variants {
  String? id;
  String? productId;
  String? attributeValueIds;
  String? attributeSet;
  String? price;
  String? specialPrice;
  String? sku;
  String? stock;
  List<String>? images;
  String? availability;
  String? status;
  String? dateAdded;
  String? variantIds;
  String? attrName;
  String? variantValues;
  String? swatcheType;
  String? swatcheValue;
  List<Null>? imagesMd;
  List<Null>? imagesSm;
  String? cartCount;

  Variants(
      {this.id,
      this.productId,
      this.attributeValueIds,
      this.attributeSet,
      this.price,
      this.specialPrice,
      this.sku,
      this.stock,
      this.images,
      this.availability,
      this.status,
      this.dateAdded,
      this.variantIds,
      this.attrName,
      this.variantValues,
      this.swatcheType,
      this.swatcheValue,
      this.imagesMd,
      this.imagesSm,
      this.cartCount});

  Variants.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productId = json['product_id'];
    attributeValueIds = json['attribute_value_ids'];
    attributeSet = json['attribute_set'];
    price = json['price'];
    specialPrice = json['special_price'];
    sku = json['sku'];
    stock = json['stock'];
    if (json['images'] != null) {
      images = [];
      json['images'].forEach((v) {
        images!.add(v);
      });
    }
    availability = json['availability'].toString();
    status = json['status'];
    dateAdded = json['date_added'];
    variantIds = json['variant_ids'];
    attrName = json['attr_name'];
    variantValues = json['variant_values'];
    swatcheType = json['swatche_type'];
    swatcheValue = json['swatche_value'];
    // if (json['images_md'] != null) {
    //   imagesMd = <Null>[];
    //   json['images_md'].forEach((v) {
    //     imagesMd!.add(v);
    //   });
    // }
    // if (json['images_sm'] != null) {
    //   imagesSm = <Null>[];
    //   json['images_sm'].forEach((v) {
    //     imagesSm!.add(v);
    //   });
    // }
    cartCount = json['cart_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['product_id'] = this.productId;
    data['attribute_value_ids'] = this.attributeValueIds;
    data['attribute_set'] = this.attributeSet;
    data['price'] = this.price;
    data['special_price'] = this.specialPrice;
    data['sku'] = this.sku;
    data['stock'] = this.stock;
    if (this.images != null) {
      data['images'] = this.images!.map((v) => v).toList();
    }
    data['availability'] = this.availability;
    data['status'] = this.status;
    data['date_added'] = this.dateAdded;
    data['variant_ids'] = this.variantIds;
    data['attr_name'] = this.attrName;
    data['variant_values'] = this.variantValues;
    data['swatche_type'] = this.swatcheType;
    data['swatche_value'] = this.swatcheValue;
    if (this.imagesMd != null) {
      data['images_md'] = this.imagesMd!.map((v) => v).toList();
    }
    if (this.imagesSm != null) {
      data['images_sm'] = this.imagesSm!.map((v) => v).toList();
    }
    data['cart_count'] = this.cartCount;
    return data;
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

class MinMaxPrice {
  String? minPrice;
  String? maxPrice;
  String? specialPrice;
  String? maxSpecialPrice;
  String? discountInPercentage;

  MinMaxPrice(
      {this.minPrice,
      this.maxPrice,
      this.specialPrice,
      this.maxSpecialPrice,
      this.discountInPercentage});

  MinMaxPrice.fromJson(Map<String, dynamic> json) {
    minPrice = json['min_price'].toString();
    maxPrice = json['max_price'].toString();
    specialPrice = json['special_price'].toString();
    maxSpecialPrice = json['max_special_price'].toString();
    discountInPercentage = json['discount_in_percentage'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['min_price'] = this.minPrice;
    data['max_price'] = this.maxPrice;
    data['special_price'] = this.specialPrice;
    data['max_special_price'] = this.maxSpecialPrice;
    data['discount_in_percentage'] = this.discountInPercentage;
    return data;
  }
}
