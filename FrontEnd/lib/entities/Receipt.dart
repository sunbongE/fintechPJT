class Receipt {
  final String storeName;
  final String? subName;
  final String addresses;
  final String date;
  final List<Map<String, dynamic>>? items;
  final int totalPrice;

  Receipt({
    required this.storeName,
    required this.subName,
    required this.addresses,
    required this.date,
    required this.items,
    required this.totalPrice,
  });

  factory Receipt.fromJson(Map<String, dynamic> json) {
    String year = json['images'][0]['receipt']['result']['paymentInfo']['date']['formatted']['year'];
    String month = json['images'][0]['receipt']['result']['paymentInfo']['date']['formatted']['month'];
    String day = json['images'][0]['receipt']['result']['paymentInfo']['date']['formatted']['day'];
    String hour = json['images'][0]['receipt']['result']['paymentInfo']['time']['formatted']['hour'];
    String minute = json['images'][0]['receipt']['result']['paymentInfo']['time']['formatted']['minute'];
    String second = json['images'][0]['receipt']['result']['paymentInfo']['time']['formatted']['second'];
    String formattedDate = "$year-$month-$day $hour:$minute:$second";

    List<Map<String, dynamic>> items = [];
    List<dynamic>? subResults = json['images'][0]['receipt']['result']['subResults'];
    if (subResults != null) {
      for (var subResult in subResults) {
        var itemsList = subResult['items'] as List<dynamic>?;
        if (itemsList != null) {
          for (var item in itemsList) {
            String? name = item['name']['formatted']['value'];
            String? count = item['count']['formatted']['value'];
            int price = int.parse(item['price']['price']['formatted']['value']);
            items.add({
              'name': name ?? 'Unknown',
              'count': count ?? '0',
              'price': price,
            });
          }
        }
      }
    }

    int totalPrice = int.parse(json['images'][0]['receipt']['result']['totalPrice']['price']['formatted']['value']);

    return Receipt(
      storeName: json['images'][0]['receipt']['result']['storeInfo']['name']['formatted']['value'],
      subName: json['images']?[0]['receipt']['result']['storeInfo']['subName']['text'],
      addresses: json['images']?[0]['receipt']['result']['storeInfo']['addresses'][1]['formatted']['value'],
      date: formattedDate,
      items: items.isNotEmpty ? items : null,
      totalPrice: totalPrice,
    );
  }
}
