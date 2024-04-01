import 'dart:math';

import 'package:dio/dio.dart';
import 'package:front/repository/commons.dart';
import 'package:front/entities/Group.dart';

final api = ApiClient();

//그룹 생성(완)
Future postGroupInfo(data) async {
  final res = await api.post('/groups', data: data);
  print(res.runtimeType);
  return res.toString();
}


//그룹 목록 조회(완)
Future<Response> getGroupList() async {
  try {
    final res = await api.get('/groups');
    return res;
  } catch (err) {
    print(err);
    throw Exception('목록조회 실패');
  }
}

//그룹 상세 조회(완)
Future<Group> getGroupDetail(groupId) async {
  try {
    final res = await api.get('/groups/$groupId');
    return Group.fromJson(res.data);;
  } catch (err) {
    print(err);
    throw Exception('그룹 조회 실패');
  }
}
//그룹 나가기(완)
Future<void> deleteGroup(groupId) async {
  try {
    final res = await api.post('/groups/$groupId');
    return res.data;
  } catch (err) {
    print(err);
    return null;
  }
}

//그룹 멤버 조회(완)
Future<Response> getGroupMemberList(groupId) async {
  try {
    final res = await api.get('/groups/$groupId/members');
    return res;
  } catch (err) {
    print(err);
    throw Exception('멤버조회 실패');
  }
}

//그룹 멤버 초대
Future<void> inviteMemberToGroup(int groupId) async {
  try {
    final res = await api.post('/groups/$groupId/invite');
    return res.data;
  } catch (err) {
    print(err);
    return null;
  }
}

//가입되어있는 멤버 조회(완)
Future<Response> getMemberByEmail(email) async {
  try {
    final res = await api.get('/members/$email');
    return res;
  } catch (err) {
    print(err);
    throw Exception('멤버 조회 실패');
  }
}


//그룹에서 회원의 상태를 조회
Future<String> fetchGroupMemberStatus(int groupId) async {
  try {
    final res = await api.get('/groups/$groupId/status');
    print(res.data);
    return res.data;
  } catch (err) {
    print(err);
    throw Exception('멤버 조회 실패');
  }
}