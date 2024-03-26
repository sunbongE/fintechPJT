class Receipt {
  final String storeName;
  final String? subName;
  final String? addresses;
  final String date;
  final List<Map<String, dynamic>>? items;
  final int totalPrice;

  Receipt({
    required this.storeName,
    this.subName,
    this.addresses,
    required this.date,
    required this.items,
    required this.totalPrice,
  });

  Map<String, dynamic> toJson() {
    return {
      'storeName': storeName,
      'subName': subName ?? "",
      'addresses': addresses ?? "",
      'date': date,
      'items': items?.map((item) => {
        'name': item['name'],
        'count': item['count'],
        'price': item['price'],
      }).toList(),
      'totalPrice': totalPrice,
    };
  }

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
    List<dynamic>? subResults = json['images'][0]['receipt']['result']['subResults'];
    if (subResults != null) {
      for (var subResult in subResults) {
        var itemsList = subResult['items'] as List<dynamic>?;
        if (itemsList != null) {
          for (var item in itemsList) {
            String? name, count;
            int price;
            try {
              name = item['name']['formatted']['value'];
              count = item['count']['formatted']['value'];
              price = int.parse(item['price']['price']['formatted']['value']);
            } catch (e) {
              name = count = "인식오류";
              price = 0;
            }
            items.add({
              'name': name ?? 'Unknown',
              'count': count ?? '0',
              'price': price,
            });
          }
        }
      }
    }

    int totalPrice;
    try {
      totalPrice = int.parse(json['images'][0]['receipt']['result']['totalPrice']['price']['formatted']['value']);
    } catch (e) {
      totalPrice = 0;
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
      storeName: json['images'][0]['receipt']['result']['storeInfo']['name']['formatted']['value'] ?? "인식오류",
      subName: subName,
      addresses: addresses,
      date: formattedDate,
      items: items.isNotEmpty ? items : null,
      totalPrice: totalPrice,
    );
  }
}
