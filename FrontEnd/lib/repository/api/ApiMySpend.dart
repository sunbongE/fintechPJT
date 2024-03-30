import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:front/repository/commons.dart';

final api = ApiClient();

// 거래내역을 전부 조회하거나 일부 조회하여 저장 후 거래내역을 반환한다.
Future<Response> getMyAccount(Map<String, dynamic> queryParameters) async {
  try {
    final res = await api.get('/account/transaction', queryParameters: queryParameters);
    return res;
  } catch (err) {
    print(err);
    throw Exception('Failed to post user info');
  }
}
