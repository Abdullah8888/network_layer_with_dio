class PhoneModel {
  List<Products>? products;

  PhoneModel({this.products});

  PhoneModel.fromJson(dynamic json) {
    if (json['products'] != null) {
      products = <Products>[];
      json['products'].forEach((v) {
        products!.add(Products.fromJson(v));
      });
    }
  }
}

class Products {
  int? id;
  String? title;

  Products({
    this.id,
    this.title,
  });

  Products.fromJson(dynamic json) {
    id = json['id'];
    title = json['title'];
  }
}
