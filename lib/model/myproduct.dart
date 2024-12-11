class MyProduct {
  String? productId;
  String? productName;
  String? productDesc;
  String? productStatus;
  String? productPrice; // Use String to handle DECIMAL type
  int? productQty;
  String? productFileName;
  String? productDate;

  MyProduct(
      {this.productId,
      this.productName,
      this.productDesc,
      this.productStatus,
      this.productPrice,
      this.productQty,
      this.productFileName,
      this.productDate});

  MyProduct.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    productName = json['product_name'];
    productDesc = json['product_desc'];
    productStatus = json['product_status'];
    productPrice = json['product_price']?.toString(); // Directly use as String
    productQty = json['product_qty'] != null
        ? int.tryParse(json['product_qty'].toString())
        : null; // Parse as int
    productFileName = json['product_filename'];
    productDate = json['product_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['product_id'] = productId;
    data['product_name'] = productName;
    data['product_desc'] = productDesc;
    data['product_status'] = productStatus;
    data['product_price'] = productPrice; // Store as String
    data['product_qty'] = productQty?.toString();
    data['product_filename'] = productFileName;
    data['product_date'] = productDate;
    return data;
  }
}
