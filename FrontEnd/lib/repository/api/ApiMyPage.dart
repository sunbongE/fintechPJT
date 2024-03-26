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
Future<void> putMyAccount(Map<String, dynamic> data) async {
  try {
    final res = await api.put('/members/account', data: data);
    print('putMyAccount: ${res.data}');
    return res.data;
  } catch (err) {
    print(err);
  }
}

// groupId로 그룹의 결제 내역을 조회한다.
Future<dynamic> getGroupSpend(groupId, queryParameters) async {
  try {
    final res = await api.get('/groups/${groupId}/payments', queryParameters: queryParameters);
    print('putMyAccount: ${res.data}');
    return res.data;
  } catch (err) {
    print(err);
  }
}

// paymentId로 결제 내역 상세보기 한다.
Future<Response> getGroupPaymentlist(groupId, paymentId) async {
  try {
    final res = await api.get('/groups/$groupId/payments/$paymentId');
    return res;
  } catch (err) {
    print(err);
    throw err;
  }
}

// 그룹 아이디로 위치 목록을 조회한다.
Future<Response> getGroupLocationList(groupId) async {
  try {
    final res = await api.get('map/group/${groupId}');
    return res;
  } catch (err) {
    print(err);
    throw err;
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
