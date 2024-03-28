class SplitMemberResponse {
  final int memberId;
  final String name;
  final int receiveAmount;
  final int sendAmount;

  SplitMemberResponse({
    required this.memberId,
    required this.name,
    required this.receiveAmount,
    required this.sendAmount,
  });


  factory SplitMemberResponse.fromJson(Map<String, dynamic> json) {
    return SplitMemberResponse(
      memberId: json['memberId'] as int,
      name: json['name'] as String,
      receiveAmount: json['receiveAmount'] as int,
      sendAmount: json['sendAmount'] as int,
    );
  }

  @override
  String toString() {
    return 'Member ID: $memberId, Name: $name, Received Amount: $receiveAmount, Sent Amount: $sendAmount';
  }
}
