import 'RequestReceiptDetailMember.dart';

class RequestReceiptDetail {
  int receiptId;
  String menu;
  int count;
  int unitPrice;
  List<RequestReceiptDetailMember>? memberList;

  RequestReceiptDetail({
    required this.receiptId,
    required this.menu,
    required this.count,
    required this.unitPrice,
    this.memberList,
  });

  factory RequestReceiptDetail.fromJson(Map<String, dynamic> json) {
    return RequestReceiptDetail(
      receiptId: json['receiptId'] as int,
      menu: json['menu'] as String,
      count: json['count'] as int,
      unitPrice: json['unitPrice'] as int,
      memberList: json['memberList'] != null
          ? (json['memberList'] as List<dynamic>)
          .map((e) => RequestReceiptDetailMember.fromJson(e as Map<String, dynamic>))
          .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'receiptId': receiptId,
      'menu': menu,
      'count': count,
      'unitPrice': unitPrice,
      'memberList': memberList?.map((e) => e.toJson()).toList(),
    };
  }
}
