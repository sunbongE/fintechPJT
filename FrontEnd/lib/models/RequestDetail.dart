import 'package:front/models/RequestMember.dart';

class RequestDetail {
  final String place;
  final int amount;
  final String date;
  final bool isSettled;
  final bool receiptExists;
  final String memo;
  final List<RequestMember> members;

  RequestDetail({
    required this.place,
    required this.amount,
    required this.date,
    required this.isSettled,
    required this.receiptExists,
    required this.memo,
    required this.members,
  });

  factory RequestDetail.fromJson(Map<String, dynamic> json) {
    var memberObjectsJson = json['함께한멤버'] as List;
    List<RequestMember> _members = memberObjectsJson
        .map((memberJson) => RequestMember.fromJson(memberJson))
        .toList();

    return RequestDetail(
      place: json['장소'],
      amount: json['금액'],
      date: json['날짜'],
      isSettled: json['정산올림'],
      receiptExists: json['영수증존재'],
      memo: json['메모'],
      members: _members,
    );
  }
}