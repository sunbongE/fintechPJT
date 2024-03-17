import 'package:front/repository/commons.dart';

final api = ApiClient();

// 유저정보 post & JWT토큰 리턴
Future<String?> postUserInfo(data) async {
  try {
    final res = await api.post('/auth', data: data);
    return res.data;
  } catch (err) {
    print(err);
    return null;
  }
}

// 6자리 핀번호 post
Future<void> postPassWord(data) async {
  try {
    final res = await api.post('/auth', data: data);
    return res.data;
  } catch (err) {
    print(err);
  }
}

// 사용자가 선택한 은행과 연결된 계좌 목록 get
Future<List<Map<String, dynamic>>?> getBankInfo(data) async {
  try {
    final res = await api.get('/bank/myAccount/', data: data);
    return res.data;
  } catch (err) {
    print(err);
    return null;
  }
}

//사용자가 선택한 은행과 연결된 계좌 목록 post
Future<void> postBankInfo(data) async {
  try {
    final res = await api.post('/bank/myAccount/', data: data);
    return res.data;
  } catch (err) {
    print(err);
  }
}