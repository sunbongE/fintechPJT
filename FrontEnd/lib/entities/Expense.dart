class Expense {
  final int transactionId;
  final String transactionSummary;
  final int transactionBalance;
  final String transactionDate;
  final bool isSettled;
  final bool receiptEnrolled;
  final String transactionTime;
  final String memo;
  final int? groupId;

  Expense({
    required this.transactionId,
    required this.transactionSummary,
    required this.transactionBalance,
    required this.transactionDate,
    required this.isSettled,
    required this.receiptEnrolled,
    required this.transactionTime,
    required this.memo,
    required this.groupId,
  });

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      transactionId: json['transactionId'] as int,
      transactionSummary: json['transactionSummary'] as String,
      transactionBalance: json['transactionBalance'] as int,
      transactionDate: json['transactionDate'] as String,
      transactionTime: json['transactionTime'] as String,
      isSettled: json['groupId'] == null ? false : true as bool,
      memo: json['memo'] as String,
      receiptEnrolled: json['receiptEnrolled'] as bool,
      groupId: json['groupId'] as int?,
    );
  }
}
