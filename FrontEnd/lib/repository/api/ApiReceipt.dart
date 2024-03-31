import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:front/repository/commons.dart';

import '../../entities/Receipt.dart';

final api = ApiClient();

Future<Response> postReceiptImage(FormData formData) async {
  var dio = Dio();

  try {
    final res = await dio.post(
      dotenv.env['OCR_URL']!,
      data: formData,
      options: Options(
        headers: {
          'X-OCR-SECRET': dotenv.env['OCR_TOKEN']!,
        },
      ),
    );
    return res;
  } catch (err) {
    print("Error posting image: $err");
    throw Exception('Failed to post user info');
  }
}

Future<dynamic> postYjReceipt(groupId, data) async {
  try {
    final res = await api.post('/groups/${groupId}/payments/receipt', data: data);
    return res.data;
  } catch (err) {
    print(err);
    throw (err);
  }
}

// 영수증 더미데이터 추가하기~~
Future<dynamic> postReceiptFakeData(data) async {
  try {
    print(data);
    final res = await api.post('/account/dummytransaction', data: data);
    print(res.data);
    return res.data;
  } catch (err) {
    print(err);
    throw (err);
  }
}

Future<Response> getReceipt(groupId, paymentId, receiptId) async {
  print(groupId);
  print(paymentId);
  print(receiptId);
  try {
    final res = await api.get('/groups/$groupId/payments/$paymentId/receipt/$receiptId');
    return res;
  } catch (err) {
    print(err);
    throw Exception('영수증 보기 실패');
  }
}

Future<Response> getReceiptDetail(groupId, paymentId, receiptDetailId) async {
  print(groupId);
  print(paymentId);
  print(receiptDetailId);
  try {
    final res = await api.get('/groups/$groupId/payments/$paymentId/receipt/receipt-detail/$receiptDetailId');
    return res;
  } catch (err) {
    print(err);
    throw Exception('영수증 상세 보기 실패');
  }
}

// 내 영수증에서 메뉴 참여인원 토글 on/off
Future<Map<String, dynamic>> putPaymentsReceiptDatil(groupId, paymentId, receiptDetailId, data) async {
  try {
    print(groupId);
    print(paymentId);
    print(receiptDetailId);
    print(data);
    final res = await api.put('/groups/$groupId/payments/$paymentId/receipt/receipt-detail/$receiptDetailId', data: data);
    print('putPaymentsReceiptDatil: ${res.data}');
    return res.data;
  } catch (err) {
    print(err);
    throw Exception('상세보기 데이터 갱신 실패.');
  }
}