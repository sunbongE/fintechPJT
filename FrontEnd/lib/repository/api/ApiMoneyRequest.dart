import 'dart:convert';

import 'package:dio/dio.dart';
import '../commons.dart';

final api = ApiClient();

//그룹에서 내 결제 목록 조회
Future<Response> getMyGroupPayments(groupId, page, size) async {
  try {
    final res = await api.get('/groups/$groupId/payments/my', queryParameters: {'page': page, 'size': size});
    return res;
  } catch (err) {
    print(err);
    throw Exception('내 목록 조회 실패');
  }
}

//정산 상세보기
Future<Response> getMyGroupPaymentsDetail(groupId, paymentId) async {
  print('----------------------------------');
  print(groupId);
  print(paymentId);
  try {
    final res = await api.get('/groups/$groupId/payments/$paymentId');
    return res;
  } catch (err) {
    print(err);
    throw Exception('정산 상세보기 실패');
  }
}

// 현금 추가
Future<Response> postAddCash(groupId, data) async {
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
    print(groupId);
    print(paymentId);
    print(jsonEncode(data));
    final res = await api.put('/groups/$groupId/payments/$paymentId', data: data);
    print('putPaymentsMember: ${res.data}');
    return res.data;
  } catch (err) {
    print(err);
    throw Exception('상세보기 데이터 갱신을 못 했습니다.');
  }
}

//영수증 세부 인원이 수정된 상태인지 판별 - 수정 버튼 막기용
Future<bool> getMoneyRequestIsEdit(groupId, paymentId) async {
  print('-----------------수정된상태인가요?-----------------');
  print(groupId);
  print(paymentId);
  try {
    final res = await api.get('/groups/$groupId/payments/$paymentId/receipt/is-edit');
    String resBody = res.data.toString();
    return resBody.toLowerCase() == 'true';
  } catch (err) {
    print(err);
    throw Exception('is-edit 확인 실패');
  }
}

//금액 설정이 Lock이 걸려있는 상태인지 판별 - 세부 설정 불가용
Future<bool> getMoneyRequestIsLock(groupId, paymentId) async {
  print('-----------------락이 걸려있는 상태인가요?-----------------');
  print(groupId);
  print(paymentId);
  try {
    final res = await api.get('/groups/$groupId/payments/$paymentId/receipt/is-lock');
    String resBody = res.data.toString();
    return resBody.toLowerCase() == 'true';
  } catch (err) {
    print(err);
    throw Exception('is-lock 확인 실패');
  }
}