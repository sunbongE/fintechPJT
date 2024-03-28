class Receipt {
  final String businessName;
  final String? subName;
  final String? location;
  final String date;
  final List<Map<String, dynamic>>? detailList;
  final int totalPrice;
  final int? approvalAmount;

  Receipt({
    required this.businessName,
    this.subName,
    this.location,
    required this.date,
    required this.detailList,
    required this.totalPrice,
    this.approvalAmount,
  });

  factory Receipt.fromJson(Map<String, dynamic> json) {
    String year, month, day, hour, minute, second;
    try {
      year = json['images'][0]['receipt']['result']['paymentInfo']['date']['formatted']['year'];
      month = json['images'][0]['receipt']['result']['paymentInfo']['date']['formatted']['month'];
      day = json['images'][0]['receipt']['result']['paymentInfo']['date']['formatted']['day'];
      hour = json['images'][0]['receipt']['result']['paymentInfo']['time']['formatted']['hour'];
      minute = json['images'][0]['receipt']['result']['paymentInfo']['time']['formatted']['minute'];
      second = json['images'][0]['receipt']['result']['paymentInfo']['time']['formatted']['second'];
    } catch (e) {
      year = month = day = hour = minute = second = "인식오류";
    }
    String formattedDate = "$year-$month-$day $hour:$minute:$second";

    List<Map<String, dynamic>> items = [];
    int itemsTotalPrice = 0;
    List<dynamic>? subResults = json['images'][0]['receipt']['result']['subResults'];
    if (subResults != null) {
      for (var subResult in subResults) {
        var itemsList = subResult['items'] as List<dynamic>?;
        if (itemsList != null) {
          for (var item in itemsList) {
            String? name;
            int count, price;
            try {
              name = item['name']['formatted']['value'];
              count = int.parse(item['count']['formatted']['value']);
              price = int.parse(item['price']['price']['formatted']['value']);
              itemsTotalPrice += price;
            } catch (e) {
              name = "인식오류";
              count = price = 0;
            }
            items.add({
              'menu': name ?? 'Unknown',
              'count': count,
              'price': price,
            });
          }
        }
      }
    }

    String? addresses;
    try {
      List<dynamic>? addressesList = json['images'][0]['receipt']['result']['storeInfo']['addresses'];
      if (addressesList != null && addressesList.isNotEmpty && addressesList != ":") {
        for (var address in addressesList) {
          if (address is Map && address['formatted'] != null && address['formatted']['value'] != ":") {
            addresses = address['formatted']['value'];
            break;
          }
        }
      }
    } catch (e) {
      addresses = "인식오류";
    }

    String? subName;
    try {
      subName = json['images'][0]['receipt']['result']['storeInfo']['subName']['text'] ?? '';
    } catch (e) {
      subName = "인식오류";
    }

    return Receipt(
      businessName: json['images'][0]['receipt']['result']['storeInfo']['name']['formatted']['value'] ?? "인식오류",
      subName: subName,
      location: addresses,
      date: formattedDate,
      detailList: items.isNotEmpty ? items : null,
      // 합계금액
      totalPrice: itemsTotalPrice,
      // 승인금액
      approvalAmount: int.parse(json['images'][0]['receipt']['result']['totalPrice']['price']['formatted']['value']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'businessName': businessName,
      'subName': subName,
      'location': location,
      'date': date,
      'detailList': detailList,
      'totalPrice': totalPrice,
      'approvalAmount': approvalAmount,
    };
  }
}
