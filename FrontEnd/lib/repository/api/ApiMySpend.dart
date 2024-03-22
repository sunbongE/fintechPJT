import 'package:front/repository/commons.dart';

final api = ApiClient();

// 회원 본인의 계좌정보를 조회한다.
Future<List<Map<String, dynamic>>?> getMyAccount(data) async {
  try {
    final res = await api.get('/members/account', queryParameters: data);
    return res.data;
  } catch (err) {
    print(err);
    return null;
  }
}