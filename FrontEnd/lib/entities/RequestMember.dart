class RequestMember {
  String profileUrl;
  String name;
  int amount;
  bool isSettled;

  RequestMember({
    required this.profileUrl,
    required this.name,
    required this.amount,
    required this.isSettled,
  });

  factory RequestMember.fromJson(Map<String, dynamic> json) {
    return RequestMember(
      profileUrl: json['프로필주소'] as String,
      name: json['이름'] as String,
      amount: json['금액'] as int,
      isSettled: json['정산여부'] as bool,
    );
  }
}