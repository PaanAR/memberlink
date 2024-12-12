class Cart {
  final int cartId;
  final int productId;
  final String productName;
  final String productFileName;
  final int quantity;
  final double price;

  Cart({
    required this.cartId,
    required this.productId,
    required this.productName,
    required this.productFileName,
    required this.quantity,
    required this.price,
  });

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      cartId: json['cart_id'] ?? 0,
      productId:
          json['product_id'] ?? 0, // Add a default value to handle missing data
      productName: json['product_name'] ?? '',
      productFileName: json['product_filename'] ?? '',
      quantity: json['quantity'] ?? 0,
      price: double.tryParse(json['price']?.toString() ?? '0.0') ?? 0.0,
    );
  }
}
