import 'package:dio/dio.dart';
import '../commons.dart';

final api = ApiClient();

//그룹에서 내 결제 목록 조회
Future<Response> getMyGroupPayments(groupId, page, size) async {
  try {
    final res = await api.get('/groups/$groupId/payments/my',
        queryParameters: {'page': 0, 'size': 10});
    return res;
  } catch (err) {
    print(err);
    throw Exception('내 목록 조회 실패');
  }
}

//정산 상세보기
Future<Response> getMyGroupPaymentsDetail(groupId, paymentId) async {
  try {
    final res = await api.get('/groups/$groupId/payments/$paymentId');
    return res;
  } catch (err) {
    //print(err);
    throw Exception('정산 상세보기 실패');
  }
}

// 현금 추가
Future<Response> postAddCash(groupId,data) async {
  try {
    final res = await api.post('/groups/$groupId/payments/cash', data: data);
    return res;
  } catch (err) {
    print(err);
    throw Exception('현금 등록을 하지 못 했습니다.');
  }
}

// 내 결제 목록에서 토글 on/off
Future<void> putPaymentsInclude(groupId, paymentId) async {
  try {
    final res = await api.put('/groups/$groupId/payments/$paymentId/include');
    print('putPaymentsInclude: ${res.data}');
    return res.data;
  } catch (err) {
    print(err);
  }
}

// 내 결제 상세보기에서 참여인원 토글 on/off or 수기입력 수정
Future<Map<String, dynamic>> putPaymentsMembers(groupId, paymentId, data) async {
  try {
    final res = await api.put('/groups/$groupId/payments/$paymentId',data: data);
    print('putPaymentsMember: ${res.data}');
    return res.data;
  } catch (err) {
    print(err);
    throw Exception('상세보기 데이터 갱신을 못 했습니다.');
  }
}