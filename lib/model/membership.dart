class Membership {
  String? membershipId;
  String? membershipName;
  String? membershipDesc;
  String? membershipPrice;
  int? membershipDuration;
  String? membershipBenefits;
  String? membershipTerms;
  String? membershipStatus;
  String? membershipDate;

  Membership({
    this.membershipId,
    this.membershipName,
    this.membershipDesc,
    this.membershipPrice,
    this.membershipDuration,
    this.membershipBenefits,
    this.membershipTerms,
    this.membershipStatus,
    this.membershipDate,
  });

  Membership.fromJson(Map<String, dynamic> json) {
    membershipId = json['membership_id'];
    membershipName = json['membership_name'];
    membershipDesc = json['membership_desc'];
    membershipPrice = json['membership_price']?.toString();
    membershipDuration =
        int.tryParse(json['membership_duration']?.toString() ?? '0');
    membershipBenefits = json['membership_benefits'];
    membershipTerms = json['membership_terms'];
    membershipStatus = json['membership_status'];
    membershipDate = json['membership_date'];
  }

  Map<String, dynamic> toJson() {
    return {
      'membership_id': membershipId,
      'membership_name': membershipName,
      'membership_desc': membershipDesc,
      'membership_price': membershipPrice,
      'membership_duration': membershipDuration?.toString(),
      'membership_benefits': membershipBenefits,
      'membership_terms': membershipTerms,
      'membership_status': membershipStatus,
      'membership_date': membershipDate,
    };
  }
}
