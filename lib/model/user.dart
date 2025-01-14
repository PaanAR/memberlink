class User {
  String? userId;
  String? username;
  String? userEmail;
  String? phoneNumber;

  User({
    this.userId,
    this.username,
    this.userEmail,
    this.phoneNumber,
  });

  // Create a User object from JSON
  User.fromJson(Map<String, dynamic> json) {
    userId = json['userid'];
    userEmail = json['useremail'];
    username = json['username'];
    phoneNumber = json['userphone'];
  }
  // Convert the User object to JSON
  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'user_name': username,
      'user_email': userEmail,
      'user_phoneNum': phoneNumber,
    };
  }
}
