class Transaction {
  final int transactionId;
  final String transactionDate;
  final String transactionTime;
  final String? transactionType;
  final String? transactionTypeName;
  final int transactionBalance;
  final int? transactionAfterBalance;
  final String transactionSummary;
  final bool receiptEnrolled;

  Transaction({
    required this.transactionId,
    required this.transactionDate,
    required this.transactionTime,
    this.transactionType,
    this.transactionTypeName,
    required this.transactionBalance,
    this.transactionAfterBalance,
    required this.transactionSummary,
    required this.receiptEnrolled,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      transactionId: json['transactionId'],
      transactionDate: json['transactionDate'],
      transactionTime: json['transactionTime'],
      transactionType: json['transactionType'],
      transactionTypeName: json['transactionTypeName'],
      transactionBalance: json['transactionBalance'],
      transactionAfterBalance: json['transactionAfterBalance'],
      transactionSummary: json['transactionSummary'],
      receiptEnrolled: json['receiptEnrolled'],
    );
  }
}
