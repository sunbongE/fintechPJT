import 'package:dio/dio.dart';
import 'package:front/repository/commons.dart';

final api = ApiClient();

// 유저정보 post & JWT토큰 리턴
Future<Response> postUserInfo(data) async {
  try {
    final res = await api.post('/auth/login', data: data);
    return res;
  } catch (err) {
    print(err);
    throw Exception('Failed to post user info');
  }
}

// 싸피은행에서 회원정보 불러오기.
Future<Response> postMyData() async {
  try {
    final res = await api.post('/members/mydata/search');
    return res;
  } catch (err) {
    print(err);
    throw err;
  }
}

// 6자리 핀번호 post
Future<void> postPassWord(data) async {
  try {
    final res = await api.post('/members/pin', data: data);
    return res.data;
  } catch (err) {
    print(err);
  }
}

// FCM Token post
Future<void> postFcmToken(data) async {
  try {
    final res = await api.post('/members/fcmtoken', data: data);
    print('postFcmToken: ${res.data}');
    return res.data;
  } catch (err) {
    if (err is DioError) {
      if (err.response?.statusCode == 409) {
        print('이미 등록된 FCM 토큰입니다.');
      } else {
        print('Error Status Code: ${err.response?.statusCode}');
      }
    } else {
      print(err);
    }
  }
}

// 사용자가 선택한 은행과 연결된 계좌 목록 get
Future<List<Map<String, dynamic>>> getBankInfo(String code) async {
  try {
    final res = await api.get('/account/list/$code');
    final List<Map<String, dynamic>> formattedRes = (res.data as List).map((e) => e as Map<String, dynamic>).toList();
    return formattedRes;
  } catch (err) {
    print('err: $err');
    throw Exception('Failed to get bank info');
  }
}

// 사용자가 선택한 은행과 연결된 계좌 목록 post
Future<void> postBankInfo(data) async {
  try {
    final res = await api.post('/bank/myAccount', data: data);
    print('postBankInfo: ${res.data}');
    return res.data;
  } catch (err) {
    print(err);
  }
}

// 로그아웃을 한다.
Future<void> postLogOut(data) async {
  try {
    final res = await api.post('/auth/logout', data: data);
    return res.data;
  } catch (err) {
    print(err);
  }
}
