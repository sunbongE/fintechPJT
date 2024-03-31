class RequestReceiptDetailMember {
  int receiptDetailId;
  String memberId;
  String name;
  String thumbnailImage;
  int amountDue;

  RequestReceiptDetailMember({
    required this.receiptDetailId,
    required this.memberId,
    required this.name,
    required this.thumbnailImage,
    required this.amountDue,
  });

  factory RequestReceiptDetailMember.fromJson(Map<String, dynamic> json) {
    return RequestReceiptDetailMember(
      receiptDetailId: json['receiptDetailId'] as int,
      memberId: json['memberId'] as String,
      name: json['name'] as String,
      thumbnailImage: json['thumbnailImage'] as String,
      amountDue: json['amountDue'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'receiptDetailId': receiptDetailId,
      'memberId': memberId,
      'name': name,
      'thumbnailImage': thumbnailImage,
      'amountDue': amountDue,
    };
  }
}