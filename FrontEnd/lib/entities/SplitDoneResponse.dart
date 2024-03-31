class SplitDoneResponse {
  final String receiveKakaoId;
  final String receiveName;
  final String receiveImage;
  final String sendKakaoId;
  final String sendName;
  final String sendImage;
  final int amount;

  SplitDoneResponse({
    required this.receiveKakaoId,
    required this.receiveName,
    required this.receiveImage,
    required this.sendKakaoId,
    required this.sendName,
    required this.sendImage,
    required this.amount,
  });

  factory SplitDoneResponse.fromJson(Map<String, dynamic> json) {
    return SplitDoneResponse(
      receiveKakaoId: json['receiveKakaoId'],
      receiveName: json['receiveName'],
      receiveImage: json['receiveImage'],
      sendKakaoId: json['sendKakaoId'],
      sendName: json['sendName'],
      sendImage: json['sendImage'],
      amount: json['amount'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'receiveKakaoId': receiveKakaoId,
      'receiveName': receiveName,
      'receiveImage': receiveImage,
      'sendKakaoId': sendKakaoId,
      'sendName': sendName,
      'sendImage': sendImage,
      'amount': amount,
    };
  }
}