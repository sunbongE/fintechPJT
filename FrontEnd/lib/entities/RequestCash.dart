import 'RequestMember.dart';

class RequestCash {
  final String transactionSummary;
  final String location;
  int transactionBalance;
  final String transactionDate;
  final String transactionTime;
  final List<RequestMember> members;
  final int remainder;

  RequestCash({
    required this.transactionSummary,
    required this.location,
    required this.transactionBalance,
    required this.transactionDate,
    required this.transactionTime,
    required this.members,
    required this.remainder,
  });

  Map<String, dynamic> toJson() {
    return {
      'transactionSummary': transactionSummary,
      'location': location,
      'transactionBalance': transactionBalance,
      'transactionDate': transactionDate,
      'transactionTime': transactionTime,
      'memberList': members.map((member) => member.toJson()).toList(),
      'remainder': remainder,
    };
  }
  @override
  String toString() {
    var memberListToString = members.map((member) => member.toString()).join(', ');
    return 'RequestCash(transactionSummary: $transactionSummary, location: $location, transactionBalance: $transactionBalance, transactionDate: $transactionDate, transactionTime: $transactionTime, memberList: [$memberListToString], remainder: $remainder)';
  }
  factory RequestCash.empty() {
    return RequestCash(
      transactionSummary: '',
      location: '',
      transactionBalance: 0,
      transactionDate: '',
      transactionTime: '',
      remainder: 0,
      members: [],
    );
  }
}