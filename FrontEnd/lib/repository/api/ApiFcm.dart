import 'package:dio/dio.dart';
import 'package:front/repository/commons.dart';
import 'package:front/entities/Notification.dart';

final api = ApiClient();

// 그룹 알림(완)
Future sendNotiGroup(data) async {
  final res = await api.post('/notification/group', data: data);
  print(res.runtimeType);
  return res.toString();
}

// 개인 알림
Future<Response> sendNotiPersonal() async {
  try {
    final res = await api.get('/notification');
    return res;
  } catch (err) {
    print(err);
    throw Exception('목록조회 실패');
  }
}
