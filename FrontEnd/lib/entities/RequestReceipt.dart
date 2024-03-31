import 'RequestReceiptDetail.dart';
import 'RequestReceiptSub.dart';

class RequestReceipt {
  final int receiptId;
  final String businessName;
  final String? subName;
  final String location;
  final String transactionDate;
  final String transactionTime;
  final int totalPrice;
  final int approvalAmount;
  final int authNumber;
  final bool visibility;
  final List<RequestReceiptSub> detailList;

  RequestReceipt({
    required this.receiptId,
    required this.businessName,
    this.subName,
    required this.location,
    required this.transactionDate,
    required this.transactionTime,
    required this.totalPrice,
    required this.approvalAmount,
    required this.authNumber,
    required this.visibility,
    required this.detailList,
  });

  factory RequestReceipt.fromJson(Map<String, dynamic> json) {
    var list = json['detailList'] as List;
    List<RequestReceiptSub> detailsList = list.map((i) => RequestReceiptSub.fromJson(i)).toList();

    return RequestReceipt(
      receiptId: json['receiptId'],
      businessName: json['businessName'],
      subName: json['subName'],
      location: json['location'],
      transactionDate: json['transactionDate'],
      transactionTime: json['transactionTime'],
      totalPrice: json['totalPrice'],
      approvalAmount: json['approvalAmount'],
      authNumber: json['authNumber'],
      visibility: json['visibility'],
      detailList: detailsList,
    );
  }
}
