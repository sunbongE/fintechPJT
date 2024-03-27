class RequestMember {
  final String memberId;
  String profileUrl;
  String name;
  int amount;
  final bool lock;

  RequestMember({
    required this.memberId,
    required this.profileUrl,
    required this.name,
    required this.amount,
    required this.lock,
  });

  factory RequestMember.fromJson(Map<String, dynamic> json) {
    return RequestMember(
      profileUrl: json['thumbnailImage'] as String,
      name: json['name'] as String,
      amount: json['totalAmount'] as int,
      lock: json['lock'],
      memberId: json['memberId'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'memberId': memberId,
      'name': name,
      'thumbnailImage': profileUrl,
      'totalAmount': amount,
      'lock': lock,
    };
  }

  factory RequestMember.fromCashJson(Map<String, dynamic> json) {
    return RequestMember(
      profileUrl: json['thumbnailImage'] as String,
      name: json['name'] as String,
      amount: 0,
      lock: false,
      memberId: json['kakaoId'] as String,
    );
  }
}
