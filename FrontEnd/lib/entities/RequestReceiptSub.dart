class RequestReceiptSub {
  final int receiptDetailId;
  final String menu;
  final int count;
  final int unitPrice;
  final int price;

  RequestReceiptSub({
    required this.receiptDetailId,
    required this.menu,
    required this.count,
    required this.unitPrice,
    required this.price,
  });

  factory RequestReceiptSub.fromJson(Map<String, dynamic> json) {
    return RequestReceiptSub(
      receiptDetailId: json['receiptDetailId'],
      menu: json['menu'],
      count: json['count'],
      unitPrice: json['unitPrice'],
      price: json['price'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'receiptDetailId': receiptDetailId,
      'menu': menu,
      'count': count,
      'unitPrice': unitPrice,
      'price': price,
    };
  }
}