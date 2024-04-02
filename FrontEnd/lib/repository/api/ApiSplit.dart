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
Future<Map<String, dynamic>> postFinalRequest(groupId) async {
  print('최종정산 post요청');
  try {
    final res = await api.post('/groups/$groupId/calculate');
    print(res);
    print("---------------------------");
    String message = res.data['message'];
    int statusCode = res.data['statusCode'];
    return {'message': message, 'statusCode': statusCode};
  } catch (err) {
    if (err is DioException) {
      final dioError = err as DioException;
      final response = dioError.response;
      if (response != null) {
        String message = response.data['message'] ?? '에러 메시지 없음';
        int? statusCode = response.statusCode;
        return {'message': message, 'statusCode': statusCode};
      } else {
        return {'message': "네트워크 에러 또는 타임아웃", 'statusCode': 500};
      }
    } else {
      return {'message': "알 수 없는 에러 발생", 'statusCode': 500};
    }
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