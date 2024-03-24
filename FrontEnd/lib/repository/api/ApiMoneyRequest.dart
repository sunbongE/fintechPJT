import 'package:dio/dio.dart';
import '../commons.dart';

final api = ApiClient();

Future<Response> getMyGroupPayments(groupId, page, size) async {
  try {
    final res = await api.get('/groups/${groupId}/payments/my',
        queryParameters: {'page': 0, 'size': 10});
    return res;
  } catch (err) {
    print(err);
    throw Exception('내 목록 조회 실패');
  }
}

Future<Response> getMyGroupPaymentsDetail(groupId, paymentId) async {
  try {
    final res = await api.get('/groups/${groupId}/payments/${paymentId}');
    return res;
  } catch (err) {
    //print(err);
    throw Exception('정산 상세보기 실패');
  }
}


