class Membership {
  String? membershipId;
  String? membershipName;
  String? membershipDesc;
  String? membershipPrice;
  String? membershipDuration;
  String? membershipBenefits;
  String? membershipTerms;
  String? membershipDate;
  String? membershipStatus;

  Membership({
    this.membershipId,
    this.membershipName,
    this.membershipDesc,
    this.membershipPrice,
    this.membershipDuration,
    this.membershipBenefits,
    this.membershipTerms,
    this.membershipDate,
    this.membershipStatus,
  });

  // This is the method that parses JSON data into a Membership object
  factory Membership.fromJson(Map<String, dynamic> json) {
    return Membership(
      membershipId: json['membership_id'].toString(),
      membershipName: json['membership_name'],
      membershipDesc: json['membership_desc'],
      membershipPrice: json['membership_price'].toString(),
      membershipDuration: json['membership_duration'].toString(),
      membershipBenefits: json['membership_benefits'],
      membershipTerms: json['membership_terms'],
      membershipDate: json['membership_date'],
      membershipStatus: json['membership_status'],
    );
  }
}
