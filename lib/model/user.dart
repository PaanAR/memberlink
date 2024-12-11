class User {
  String? userid;
  String? useremail;

  User({this.userid, this.useremail});

  User.fromJson(Map<String, dynamic> json) {
    userid = json['user_id'];
    useremail = json['user_email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userid;
    data['user_email'] = useremail;
    return data;
  }
}
