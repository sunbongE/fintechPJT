import 'package:front/entities/RequestMember.dart';

class RequestDetail {
  final int receiptId;
  final String businessName;
  final String location;
  final String transactionDate;
  final String transactionTime;
  final int totalPrice;
  final int approvalAmount;
  final int authNumber;
  final bool visibility;
  final bool receiptExists;
  final String memo;
  final List<RequestMember> members;

  RequestDetail({
    required this.location,
    required this.transactionDate,
    required this.transactionTime,
    required this.totalPrice,
    required this.authNumber,
    required this.visibility,
    required this.receiptId,
    required this.businessName,
    required this.approvalAmount,
    this.receiptExists = false,
    this.memo = '',
    required this.members,
  });

  factory RequestDetail.fromJson(Map<String, dynamic> json) {
    var memberObjectsJson = json['memberList'] as List;
    List<RequestMember> _members = memberObjectsJson
        .map((memberJson) => RequestMember.fromJson(memberJson))
        .toList();

    return RequestDetail(
      receiptId: json['receiptId'],
      businessName: json['businessName'],
      location: json['location'],
      totalPrice: json['totalPrice'],
      approvalAmount: json['approvalAmount'],
      transactionDate: json['transactionDate'],
      transactionTime: json['transactionTime'],
      receiptExists: json['영수증존재'] ?? false,
      memo: json['memo'] ?? '',
      authNumber: json['authNumber'],
      visibility: json['visibility'],
      members: _members,
    );
  }

  factory RequestDetail.empty() {
    return RequestDetail(
      receiptId: 0,
      businessName: '',
      location: '',
      transactionDate: '',
      transactionTime: '',
      totalPrice: 0,
      approvalAmount: 0,
      authNumber: 0,
      visibility: false,
      receiptExists: false,
      memo: '',
      members: [],
    );
  }
}
