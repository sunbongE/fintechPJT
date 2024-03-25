import 'package:dio/dio.dart';
import 'package:front/repository/commons.dart';

final api = ApiClient();

//그룹 생성(완)
Future<Response?> postGroupInfo(Map<String, dynamic> data) async {
  final res = await api.post('/groups', data: data);
  return res; // res.data 대신 res를 반환
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

//그룹 멤버 조회
Future<Response> getGroupMemberList(groupId) async {
  try {
    final res = await api.get('/groups/$groupId/members');
    // print(res);
    return res;
  } catch (err) {
    print(err);
    throw Exception('멤버조회 실패');
  }
}

//그룹 멤버 초대
Future<void> inviteMemberToGroup(data, groupId) async {
  try {
    final res = await api.post('/groups/$groupId/invite', data: data);
    return res.data;
  } catch (err) {
    print(err);
    return null;
  }
}

//가입되어있는 멤버 조회
Future<Map<String, dynamic>?> getMemberByEmail(String email, Map<String, dynamic> queryParameters) async {
  try {
    final res = await api.get('/members/$email', queryParameters: queryParameters);
    return res.data;
  } catch (err) {
    print(err);
    return null;
  }
}
// {
// "kakaoId": "23423423",
// "email": "SSAFY01@naver.com",
// "name": "이싸피",
// "profileImage": "https://k.kakaocdn.net/dn/hQA8L/btr0BClPKjh/YgcBWlcOYigokCVkCLO6pK/img_640x640.jpg",
// "thumbnailImage": "https://k.kakaocdn.net/dn/hQA8L/btr0BClPKjh/YgcBWlcOYigokCVkCLO6pK/img_110x110.jpg"
// }

// //그룹 초대링크 생성
// Future<String?> postUserInfo(data) async {
//   try {
//     final res = await api.post('/auth', data: data);
//     return res.data;
//   } catch (err) {
//     print(err);
//     return null;
//   }
// }
