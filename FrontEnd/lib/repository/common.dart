// import 'package:dio/dio.dart';
// import 'dart:convert';
//
// // SocialKaKao.dart에서 User정보를 post요청할 시 사용
// // 공통 api 모듈은 곧 설계할 예정
// Future<String?> postUserInfo<T>(T params, String urlParams) async {
//   Dio dio = Dio();
//   dio.options.headers['content-type'] = 'application/json';
//
//   try {
//     String jsonParams = jsonEncode(params);
//     // 에뮬레이터에선 localhost가 아닌 10.0.2.2로 적어야함
//     String url = 'http://10.0.2.2:8080/api/v1/auth/${urlParams}';
//     Response response = await dio.post(url, data: jsonParams);
//     var res = response.data;
//     print('API 응답: $res');
//   } catch (err) {
//     print('유저 정보 POST 요청 실패: $err');
//   }
// }
//
// // 선택한 은행의 계좌들을 불러오는 요청
// Future<List<String>> getBankInfo<T>(T params) async {
//   Dio dio = Dio();
//   dio.options.headers['content-type'] = 'application/json';
//   dio.options.headers['Authorization'] = 'Bearer token';
//
//   try {
//     String jsonParams = jsonEncode(params);
//     String url = 'http://10.0.2.2:8080/api/v1/auth/test';
//     Response response = await dio.get(url, data: jsonParams);
//     var res = response.data;
//     return List<String>.from(res);
//   } catch (err) {
//     print(err);
//     return [];
//   }
// }
//
//
