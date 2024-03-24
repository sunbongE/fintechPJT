import 'dart:io';
import 'package:dio/dio.dart';
import 'package:front/repository/commons.dart';

final api = ApiClient();
final fileApi = ApiFileClient();

// 프로필 사진 변경
Future<void> putProfileImage(data) async {
  try {
    final res = await api.put('/auth', data: data);
    return res.data;
  } catch (err) {
    print(err);
  }
}

// 회원 본인의 계좌 정보를 수정한다.
Future<void> putMyAccount(data) async {
  try {
    final res = await api.put('/members/account', data: data);
    return res.data;
  } catch (err) {
    print(err);
  }
}

// 회원의 프로필 이미지를 변경한다.
Future<Response> putUploadImage(formData) async {
  try {
    final res = await fileApi.put("/members/profile", data: formData);
    return res;
  } catch (e) {
    print(e);
    throw Exception('Failed to post user info');
  }
}
