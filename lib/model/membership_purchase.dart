class MembershipPurchase {
  String? purchaseId;
  String? userId;
  String? membershipId;
  String? membershipName;
  String? purchaseAmount;
  String? purchaseDate;
  String? paymentStatus;
  String? transactionId;
  String? paymentMethod;
  String? expiryDate;

  MembershipPurchase({
    this.purchaseId,
    this.userId,
    this.membershipId,
    this.membershipName,
    this.purchaseAmount,
    this.purchaseDate,
    this.paymentStatus,
    this.transactionId,
    this.paymentMethod,
    this.expiryDate,
  });

  MembershipPurchase.fromJson(Map<String, dynamic> json) {
    purchaseId = json['purchase_id'];
    userId = json['user_id'];
    membershipId = json['membership_id'];
    membershipName = json['membership_name'];
    purchaseAmount = json['purchase_amount'];
    purchaseDate = json['purchase_date'];
    paymentStatus = json['payment_status'];
    transactionId = json['transaction_id'];
    paymentMethod = json['payment_method'];
    expiryDate = json['expiry_date'];
  }

  Map<String, dynamic> toJson() {
    return {
      'purchase_id': purchaseId,
      'user_id': userId,
      'membership_id': membershipId,
      'membership_name': membershipName,
      'purchase_amount': purchaseAmount,
      'purchase_date': purchaseDate,
      'payment_status': paymentStatus,
      'transaction_id': transactionId,
      'payment_method': paymentMethod,
      'expiry_date': expiryDate,
    };
  }
}
