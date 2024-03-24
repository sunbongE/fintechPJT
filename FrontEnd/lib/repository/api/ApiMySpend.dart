import 'package:dio/dio.dart';
import 'package:front/repository/commons.dart';

final api = ApiClient();

// 회원 본인의 계좌정보를 조회한다.
Future<Response> getMyAccount() async {
  try {
    final res = await api.get('/members/account',);
    return res;
  } catch (err) {
    print(err);
    throw Exception('Failed to post user info');
  }
}