import 'package:dio/dio.dart';
import '../commons.dart';

final api = ApiClient();

//여정(스플릿)에서 내 여정(스플릿) 조회
Future<Response> getMyGroupPayments(groupId) async {
  try {
    final res = await api.get('/groups/$groupId/payments/yeojung');
    return res;
  } catch (err) {
    print(err);
    throw Exception('내 여정(스플릿) 조회 실패');
  }
}