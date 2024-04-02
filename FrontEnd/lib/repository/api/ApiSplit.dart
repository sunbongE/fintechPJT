import 'package:dio/dio.dart';
import '../commons.dart';

final api = ApiClient();

//여정(스플릿)에서 내 여정(스플릿) 조회
Future<Response> getYeojung(groupId) async {
  try {
    final res = await api.get('/groups/$groupId/payments/yeojung');
    print(res);
    return res;
  } catch (err) {
    print(err);
    throw Exception('내 여정(스플릿) 조회 실패');
  }
}

// 여정(스플릿) 퍼스트 콜
Future<bool> putFirstCall(groupId) async {
  try {
    print(groupId);
    final res = await api.put('/groups/$groupId/firstcall');
    if (res.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  } catch (err) {
    print(err);
    throw Exception('퍼스트 콜 갱신 실패.');
  }
}

// 여정(스플릿) 세컨드 콜
Future<int> putSecondCall(groupId) async {
  try {
    print(groupId);
    final res = await api.put('/groups/$groupId/secondcall');
    print(res);
    print(res.data);
    return res.data;
  } catch (err) {
    print(err);
    throw Exception('세컨드 콜 갱신 실패.');
  }
}

//여정(스플릿) 세컨드 콜한 사람 목록
Future<Response> getSecondCallMember(groupId) async {
  try {
    final res = await api.get('/groups/$groupId/members/secondcall');
    print(res);
    return res;
  } catch (err) {
    print(err);
    throw Exception('세컨드 콜 멤버 조회 실패');
  }
}

// 여정(스플릿) 최종정산 - 세컨드 콜이 리턴값이 0이상인 사람이 호출
Future<dynamic> postFinalRequest(groupId) async {
  print('최종정산 post요청');
  try {
    final res = await api.post('/groups/$groupId/calculate');
    print(res.data);
    return res.data;
  } catch (err) {
    print(err);
    throw (err);
  }
}

//여정(스플릿) 결과
Future<Response> getSplitResult(groupId) async {
  try {
    final res = await api.get('/groups/$groupId/result');
    print(res);
    return res;
  } catch (err) {
    print(err);
    throw Exception('최종 결과 조회 실패');
  }
}

//그룹에서 회원 정산 상태 조회
Future<Response> getPersonalGroupStatus(groupId) async {
  try {
    final res = await api.get('/groups/$groupId/status');
    print(res);
    return res;
  } catch (err) {
    print(err);
    throw Exception('회원 상태 조회 실패');
  }
}

//여정(스플릿)에서 내 여정(스플릿) 상세조회
Future<Response> getYeojungDetail(groupId, type, otherMemberId) async {
  try {
    print(groupId);
    print(type);
    print(otherMemberId);
    final res = await api.get('/groups/$groupId/payments/yeojung/detail',
        queryParameters: {'type': type, 'otherMemberId': otherMemberId});
    print(res);
    return res;
  } catch (err) {
    print(err);
    throw Exception('내 여정(스플릿) 상세조회 실패');
  }
}
// 개인이 여정(스플릿) 퍼스트 콜 여부
Future<bool> getisSplit(groupId) async {
  try {
    print(groupId);
    final res = await api.get('/groups/$groupId/members/isSplit');
    return res.toString() == "true" ? true : false;
  } catch (err) {
    print(err);
    throw Exception('퍼스트 콜 실패.');
  }
}