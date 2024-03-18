import 'package:front/repository/commons.dart';

final api = ApiClient();

// 프로필 사진 변경
Future<void> putProfileImage(data) async {
  try {
    final res = await api.put('/auth', data: data);
    return res.data;
  } catch (err) {
    print(err);
  }
}