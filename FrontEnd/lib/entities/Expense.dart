class Expense {
  final int transactionId;
  final String place;
  final int amount;
  final String date;
  final bool isSettled;
  final bool isReceipt;

  Expense(
      {required this.transactionId,
      required this.place,
      required this.amount,
      required this.date,
      required this.isSettled,
      required this.isReceipt});

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      transactionId: json['거래번호'] as int,
      place: json['장소'] as String,
      amount: json['금액'] as int,
      date: json['날짜'] as String,
      isSettled: json['정산올림'] as bool,
      isReceipt: json['영수증존재'] as bool,
    );
  }
}
