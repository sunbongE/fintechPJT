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

// 6자리 핀번호 post
Future<void> postPassWord(data) async {
  try {
    final res = await api.post('/members/pin', data: data);
    return res.data;
  } catch (err) {
    print(err);
  }
}

// 사용자가 선택한 은행과 연결된 계좌 목록 get
Future<Response> getBankInfo(data) async {
  try {
    final res = await api.get('/bank/myAccount', queryParameters: data);
    return res;
  } catch (err) {
    print(err);
    throw Exception('Failed to post user info');
  }
}

// 사용자가 선택한 은행과 연결된 계좌 목록 post
Future<void> postBankInfo(data) async {
  try {
    final res = await api.post('/bank/myAccount', data: data);
    return res.data;
  } catch (err) {
    print(err);
  }
}

// 로그아웃을 한다.
Future<void> postLogOut() async {
  try {
    final res = await api.post('/auth/logout',);
    return res.data;
  } catch (err) {
    print(err);
  }
}
