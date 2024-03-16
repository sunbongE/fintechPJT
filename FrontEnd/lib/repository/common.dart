import 'package:dio/dio.dart';
import 'dart:convert';

// SocialKaKao.dart에서 User정보를 post요청할 시 사용
// 공통 api 모듈은 곧 설계할 예정
Future<void> postUserInfo<T>(T params) async {
  Dio dio = Dio();
  dio.options.headers['content-type'] = 'application/json';
  try {
    String jsonParams = jsonEncode(params);
    // String url = 'http://j10c203.p.ssafy.io:8080/api/v1/auth/jointest';
    // String url = 'http://10.0.2.2:8080/api/v1/auth/jointest';    // 에뮬레이터에선 localhost가 아닌 10.0.2.2로 적어야함
    String url = 'http://10.0.2.2:8080/api/v1/auth/test';
    Response response = await dio.post(url, data: jsonParams);
    var res = response.data;
    print('API 응답: $res');
  } catch (err) {
    print('유저 정보 POST 요청 실패: $err');
  }
}