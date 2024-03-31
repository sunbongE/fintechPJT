import 'package:front/entities/RequestMember.dart';

class RequestDetail {
  final int receiptId;
  final String businessName;
  final String? location;
  final String transactionDate;
  final String transactionTime;
  final int totalPrice;
  final int approvalAmount;
  final int authNumber;
  final bool visibility;
  final bool receiptExists;
  final int remainder;
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
    required this.remainder,
    required this.members,
  });

  factory RequestDetail.fromJson(Map<String, dynamic> json) {
    var memberObjectsJson = json['memberList'] as List;
    List<RequestMember> _members = memberObjectsJson.map((memberJson) => RequestMember.fromJson(memberJson)).toList();

    return RequestDetail(
      receiptId: json['receiptId'],
      businessName: json['businessName'],
      location: json['location'],
      totalPrice: json['totalPrice'],
      approvalAmount: json['approvalAmount'],
      transactionDate: json['transactionDate'],
      transactionTime: json['transactionTime'],
      receiptExists: json['receiptEnrolled'] ?? false,
      memo: json['memo'] ?? '',
      authNumber: json['authNumber'],
      visibility: json['visibility'],
      remainder: json['remainder'],
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
      remainder: 0,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'receiptId': receiptId,
      'businessName': businessName,
      'location': location,
      'transactionDate': transactionDate,
      'transactionTime': transactionTime,
      'totalPrice': totalPrice,
      'approvalAmount': approvalAmount,
      'authNumber': authNumber,
      'visibility': visibility,
      'memo': memo,
      'remainder': remainder,
      'receiptEnrolled': receiptExists,
      'memberList': members.map((member) => member.toJson()).toList(),
    };
  }

  @override
  String toString() {
    return 'RequestDetail(receiptId: $receiptId, businessName: $businessName, location: $location, transactionDate: $transactionDate, transactionTime: $transactionTime, totalPrice: $totalPrice, approvalAmount: $approvalAmount, authNumber: $authNumber, visibility: $visibility, receiptExists: $receiptExists, remainder: $remainder, memo: $memo, members: ${members.toString()})';
  }
}
